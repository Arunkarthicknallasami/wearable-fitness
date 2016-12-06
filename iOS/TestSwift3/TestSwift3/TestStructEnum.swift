//
//  TestStruct.swift
//  TestSwift3
//
//  Created by Jeffrey Garcia on 12/6/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

import Foundation

public struct TestStruct {
    let string: String
    
    internal init(string: String) {
        self.string = string
    }
}

public enum DataConversionError: Error {
    case NonOptionalUnwrappingError
}

public enum TestDataType {
    case steps
    case sleep
    case caloriesBurned
    case weight
}

