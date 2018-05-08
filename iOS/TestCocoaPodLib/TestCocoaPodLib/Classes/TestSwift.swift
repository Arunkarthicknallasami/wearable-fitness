//
//  TestSwift.swift
//  Pods-TestCocoaPodLib_Example
//
//  Created by jeffrey on 8/5/2018.
//

import Foundation

// must extend NSObject in order to be visible 
public class TestSwift : NSObject {
    
    public func test() {
        print("TestSwift - test invoked")
        
        let testObjc = TestObjc()
        testObjc.test2()
        
        return
    }
    
    public func test2() {
        print("TestSwift - test2 invoked")
        
        return
    }
    
}
