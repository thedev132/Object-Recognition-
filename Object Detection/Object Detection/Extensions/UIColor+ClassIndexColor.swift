//
//  UIColor+ClassIndexColor.swift
//  Tensorflow_coreml_obj_detection
//
//  Created by Vasile Morari on 2/20/20.
//  Copyright © 2020 Vasile Morari. All rights reserved.
//

import UIKit

extension UIColor {
    private static var colorStrideValue: Int {
        return 10
    }
    
    private static var colors: [UIColor] {
        return [
            UIColor.red,
            UIColor(displayP3Red: 90.0/255.0, green: 200.0/255.0, blue: 250.0/255.0, alpha: 1.0),
            UIColor.green,
            UIColor.orange,
            UIColor.blue,
            UIColor.purple,
            UIColor.magenta,
            UIColor.yellow,
            UIColor.cyan,
            UIColor.brown
        ]
    }
    
    /// This assigns color for a particular class.
    static func colorForClass(withIndex index: Int) -> UIColor {
        // We have a set of colors and the depending upon a stride, it assigns variations to of the base
        // colors to each object based on its index.
        let baseColor = colors[index % colors.count]
        
        var colorToAssign = baseColor
        
        let percentage = CGFloat((colorStrideValue / 2 - index / colors.count) * colorStrideValue)
        
        if let modifiedColor = baseColor.getModified(byPercentage: percentage) {
            colorToAssign = modifiedColor
        }
        
        return colorToAssign
    }
}
