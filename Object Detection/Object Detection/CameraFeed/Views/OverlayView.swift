//
//  OverlayView.swift
//  Tensorflow_coreml_obj_detection
//

//

import UIKit

/**
 This structure holds the display parameters for the overlay to be drawon on a detected object.
 */
struct ObjectOverlay {
    let name: String
    let borderRect: CGRect
    let nameStringSize: CGSize
    let color: UIColor
    let font: UIFont
}

/**
 This UIView draws overlay on a detected object.
 */
class OverlayView: UIView {
    
    var objectOverlays: [ObjectOverlay] = []
    private let stringBgAlpha: CGFloat = 0.7
    private let lineWidth: CGFloat = 3
    private let stringFontColor = UIColor.white
    private let stringHorizontalSpacing: CGFloat = 13.0
    private let stringVerticalSpacing: CGFloat = 7.0
    
    private let edgeOffset: CGFloat = 2.0
    private let displayFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        for objectOverlay in objectOverlays {
            
            drawBorders(of: objectOverlay)
            drawBackground(of: objectOverlay)
            drawName(of: objectOverlay)
        }
    }
    
    /**
     This method draws the borders of the detected objects.
     */
    func drawBorders(of objectOverlay: ObjectOverlay) {
        
        let path = UIBezierPath(rect: objectOverlay.borderRect)
        path.lineWidth = lineWidth
        objectOverlay.color.setStroke()
        
        path.stroke()
    }
    
    /**
     This method draws the background of the string.
     */
    func drawBackground(of objectOverlay: ObjectOverlay) {
        
        let stringBgRect = CGRect(x: objectOverlay.borderRect.origin.x, y: objectOverlay.borderRect.origin.y , width: 2 * stringHorizontalSpacing + objectOverlay.nameStringSize.width, height: 2 * stringVerticalSpacing + objectOverlay.nameStringSize.height
        )
        
        let stringBgPath = UIBezierPath(rect: stringBgRect)
        objectOverlay.color.withAlphaComponent(stringBgAlpha).setFill()
        stringBgPath.fill()
    }
    
    /**
     This method draws the name of object overlay.
     */
    func drawName(of objectOverlay: ObjectOverlay) {
        
        // Draws the string.
        let stringRect = CGRect(x: objectOverlay.borderRect.origin.x + stringHorizontalSpacing, y: objectOverlay.borderRect.origin.y + stringVerticalSpacing, width: objectOverlay.nameStringSize.width, height: objectOverlay.nameStringSize.height)
        
        let attributedString = NSAttributedString(string: objectOverlay.name, attributes: [NSAttributedString.Key.foregroundColor : stringFontColor, NSAttributedString.Key.font : objectOverlay.font])
        attributedString.draw(in: stringRect)
    }
    
    /**
     This method takes the results, translates the bounding box rects to the current view, draws the bounding boxes, classNames and confidence scores of inferences.
     */
    func drawAfterPerformingCalculations(onInferences inferences: [Inference], withImageSize imageSize:CGSize) {
        
        objectOverlays = []
        setNeedsDisplay()
        
        guard !inferences.isEmpty else {
            return
        }
        
        var objectOverlays: [ObjectOverlay] = []
        
        for inference in inferences {
            
            // Translates bounding box rect to current view.
            var convertedRect = inference.rect.applying(CGAffineTransform(scaleX: bounds.size.width / imageSize.width, y: bounds.size.height / imageSize.height))
            
            if convertedRect.origin.x < 0 {
                convertedRect.origin.x = edgeOffset
            }
            
            if convertedRect.origin.y < 0 {
                convertedRect.origin.y = edgeOffset
            }
            
            if convertedRect.maxY > bounds.maxY {
                convertedRect.size.height = bounds.maxY - convertedRect.origin.y - edgeOffset
            }
            
            if convertedRect.maxX > bounds.maxX {
                convertedRect.size.width = bounds.maxX - convertedRect.origin.x - edgeOffset
            }
            
            let confidenceValue = Int(inference.confidence * 100.0)
            let string = "\(inference.className)  (\(confidenceValue)%)"
            
            let size = string.size(usingFont: displayFont)
            
            let objectOverlay = ObjectOverlay(name: string, borderRect: convertedRect, nameStringSize: size, color: inference.displayColor, font: displayFont)
            
            objectOverlays.append(objectOverlay)
        }
        
        // Hands off drawing to the OverlayView
        draw(objectOverlays: objectOverlays)
    }
    
    /** Calls methods to update overlay view with detected bounding boxes and class names.
     */
    func draw(objectOverlays: [ObjectOverlay]) {
        self.objectOverlays = objectOverlays
        setNeedsDisplay()
    }
    
    func clear() {
        draw(objectOverlays: [])
    }
    
}

struct Result {
    let inferences: [Inference]
}

/// Stores one formatted inference.
struct Inference {
    let confidence: Float
    let className: String
    let rect: CGRect
    let displayColor: UIColor
}

/// Information about a model file or labels file.
typealias FileInfo = (name: String, extension: String)
