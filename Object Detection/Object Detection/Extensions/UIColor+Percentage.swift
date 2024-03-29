//
//  UIColor+Percentage.swift
//  Tensorflow_coreml_obj_detection
//
//  Created by Vasile Morari on 2/19/20.
//  Copyright © 2020 Vasile Morari. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     This method returns colors modified by percentage value of color represented by the current object.
     */
    func getModified(byPercentage percent: CGFloat) -> UIColor? {
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        // Returns the color comprised by percentage r g b values of the original color.
        let colorToReturn = UIColor(displayP3Red: min(red + percent / 100.0, 1.0), green: min(green + percent / 100.0, 1.0), blue: min(blue + percent / 100.0, 1.0), alpha: 1.0)
        
        return colorToReturn
    }
}

