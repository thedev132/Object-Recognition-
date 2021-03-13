//
//  StoryboardLoadable.swift
//  Tensorflow_coreml_obj_detection
//
//  Created by Vasile Morari on 2/18/20.
//  Copyright © 2020 Vasile Morari. All rights reserved.
//

import UIKit

protocol StoryboardLoadable: class {
    static var storyboardName: String { get }
}

extension StoryboardLoadable where Self: UIViewController {
    static func instance() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError(String(describing: Self.self) + "not found in \(storyboardName)")
        }
        
        return viewController
    }
}
