//
//  CoreMLModelDataHandler.swift
//  Tensorflow_coreml_obj_detection
//
//  Created by Vasile Morari on 2/19/20.
//  Copyright © 2020 Vasile Morari. All rights reserved.
//

import UIKit
import Vision

class CoreMLModelDataHandler: NSObject, ModelDataHandler {
    
    private let mlModel: MLModel
    private let vnCoreMLModel: VNCoreMLModel
    
    init?(mlModel: MLModel) {
        guard let vnCoreMLModel = try? VNCoreMLModel(for: mlModel) else {
            return nil
        }
        
        self.mlModel = mlModel
        self.vnCoreMLModel = vnCoreMLModel
    }
    
    func runModel(onFrame pixelBuffer: CVPixelBuffer, completion: @escaping ((Result?) -> ())) {
        // Tell Vision about the orientation of the image.
        let orientation = exifOrientationFromDeviceOrientation()
        
        let request = VNCoreMLRequest(model: vnCoreMLModel) { (req, err) in
            completion(self.getResult(from: req, pixelBuffer: pixelBuffer))
        }
        
        request.imageCropAndScaleOption = .scaleFill
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation, options: [:]).perform([request])
    }
    
    private func getResult(from request: VNRequest, pixelBuffer: CVPixelBuffer) -> Result? {
        guard let results = request.results else { return nil }
        
        var resultArray: [Inference] = []
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            
            let width = CVPixelBufferGetWidth(pixelBuffer)
            let height = CVPixelBufferGetHeight(pixelBuffer)
            
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let color = colorForClass(withLabel: topLabelObservation.identifier)
            
            var objectBounds = objectObservation.boundingBox.applying(CGAffineTransform(scaleX: CGFloat(width), y: CGFloat(height)))
            
            objectBounds.origin.y = CGFloat(height) - objectBounds.origin.y - objectBounds.height
            
            resultArray.append(Inference(confidence: topLabelObservation.confidence, className: topLabelObservation.identifier, rect: objectBounds, displayColor: color))
        }
        
        return Result(inferences: resultArray)
    }
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
    
    private func colorForClass(withLabel label: String) -> UIColor {
        let classIndex = mlModel.classes.firstIndex(of: label) ?? 1
        return UIColor.colorForClass(withIndex: classIndex)
    }
}

protocol ModelDataHandler {
    func runModel(onFrame pixelBuffer: CVPixelBuffer, completion: @escaping ((Result?) -> ()))
}
