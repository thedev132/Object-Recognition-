//
//  String+Size.swift
//  Tensorflow_coreml_obj_detection
//
//  Created by Vasile Morari on 2/19/20.
//  Copyright © 2020 Vasile Morari. All rights reserved.
//

import UIKit

extension String {
    
    /**This method gets size of a string with a particular font.
     */
    func size(usingFont font: UIFont) -> CGSize {
        let attributedString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font : font])
        return attributedString.size()
    }
    
}
