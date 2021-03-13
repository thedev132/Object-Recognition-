//
//  MLModel+Classes.swift
//  Tensorflow_coreml_obj_detection
//
//  Created by Vasile Morari on 2/20/20.
//  Copyright © 2020 Vasile Morari. All rights reserved.
//

import Vision

extension MLModel {
    var classes: [String] {
        guard let userDefined = modelDescription.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String : String] else {
            print("Failed to retrieve mlModel creatorDefinedKey.")
            return []
        }
        return userDefined["classes"]?.components(separatedBy: ",") ?? []
    }
}
