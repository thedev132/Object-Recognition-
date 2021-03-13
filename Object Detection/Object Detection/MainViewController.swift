//
//  ViewController.swift
//  Tensorflow_coreml_obj_detection
//
//  Created by Vasile Morari on 2/18/20.
//  Copyright © 2020 Vasile Morari. All rights reserved.
//

import UIKit
import AVKit
import Vision

final class MainViewController: CameraFeedViewController {
    
    
    // MARK: Controllers that manage functionality
    private var modelDataHandler: ModelDataHandler?
    
    // MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        modelDataHandler = CoreMLModelDataHandler(mlModel: CoreML1().model)
        title = "CoreML"
    }
    
  

   
    // MARK: Override
    override func didOutput(pixelBuffer: CVPixelBuffer) {
        
        modelDataHandler?.runModel(onFrame: pixelBuffer, completion: { (result) in
            guard let result = result else { return }

            let width = CVPixelBufferGetWidth(pixelBuffer)
            let height = CVPixelBufferGetHeight(pixelBuffer)
            
            let imageSize = CGSize(width: CGFloat(width), height: CGFloat(height))
            
            DispatchQueue.main.async {
                // Draws the bounding boxes and displays class names and confidence scores.
                self.overlayView.drawAfterPerformingCalculations(onInferences: result.inferences, withImageSize: imageSize)
            }
        })
    }
    
}
