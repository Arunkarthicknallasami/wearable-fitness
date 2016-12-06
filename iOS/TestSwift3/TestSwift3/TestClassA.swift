//
//  TestClassA.swift
//  TestSwift3
//
//  Created by Jeffrey Garcia on 12/6/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

import Foundation


// abstract class does not automatically inherit NSObject, better to explicitly declare to inherit NSObject?
class TestClassA:NSObject {
    var mName: String
    init(name: String) {
        self.mName = name
    }
}
