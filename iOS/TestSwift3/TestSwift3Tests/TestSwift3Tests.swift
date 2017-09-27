//
//  TestSwift3Tests.swift
//  TestSwift3Tests
//
//  Created by Jeffrey Garcia on 9/1/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

import XCTest

@testable import TestSwift3

class TestSwift3Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitTimezoneWithLocale() {
        print("===========================================")
        
        let locale = Locale.init(identifier: "zh_Hant_HK") as Locale!
        let timezone = TimeZone(abbreviation: "zh_Hant_HK")
        print(timezone)
        
        print("===========================================")
    }
    
    func testTimeZoneWithOffset() {
        print("===========================================")
        
        let dateString:String = "2016-12-06T16:00:00.000Z"
        print("input: \(dateString)")
        
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let utcDate:Date = dateStringFormatter.date(from: dateString)!
        print("UTC Date: \(utcDate)") // will be in UTC
        
        // This will return nil for certain timezone
        // https://developer.apple.com/reference/foundation/timezone/2293181-init
        //let localTimezone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
        
        
        let localTimezone = NSTimeZone.local as TimeZone
        print("Local Timezone: \((NSTimeZone.local as NSTimeZone).abbreviation!)")
        print("Local Timezone: \(localTimezone.abbreviation())")
        let localGmtOffset:Int = localTimezone.secondsFromGMT(for: utcDate)
        print("Local GMT Offset: \(localGmtOffset)")
        let gmtDate = Date(timeInterval: TimeInterval(localGmtOffset), since: utcDate)
        print("Local Date: \(gmtDate)") // will be in GMT
        
        let hkTimezone = TimeZone(abbreviation: "HKT")
        print("HKT Timezone: \(hkTimezone?.abbreviation())")
        let hkGmtOffset:Int = hkTimezone!.secondsFromGMT(for: utcDate)
        print("HKT GMT Offset: \(localGmtOffset)")
        let hktDate = Date(timeInterval: TimeInterval(hkGmtOffset), since: utcDate)
        print("HKT Date: \(hktDate)") // will be in HKT
        
        let offsetInterval = hkGmtOffset - localGmtOffset
        print("Offset Interval: \(offsetInterval)")
        let utcDateWithOffset = Date(timeInterval: TimeInterval(offsetInterval), since: utcDate)
        print("UTC Date with Offset: \(utcDateWithOffset)")
        
        //let utcTimeZone = TimeZone(abbreviation: "UTC")
        //print("UTC Timezone: \(utcTimeZone)")
        
        print("===========================================")
    }
    
    func testDateComponent() {
        print("===========================================")
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.hour = 0
        components.minute = 0
        let from1 = calendar.date(from: components)!
        print(from1)
        
        let timeInterval = -3600 // minus 1 hour (60 * 60)
        let from2 = Date(timeInterval: TimeInterval(timeInterval), since: Date())
        print(from2)
        
        print("===========================================")
    }
    
    /**
     Comparison of Calendar and Date object
    */
    func testCalendarToDate() {
        print("===========================================")
        
        let input = Date()
        print(input)
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: input)
        components.hour = 12
//        components.minute = 29
        let output = calendar.date(from: components)!
        print(output)
        
        print("===========================================")
    }
    
    /**
     Convert of "UTC" date string to UTC date object
     */
    func testConvertStringToDate2() {
        print("===========================================")
        
        let dateString:String = "2016-12-06T08:31:49.000Z"
        print("input: \(dateString)")
        
        // if data string is assumed UTC, convert the date back to local system
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        // force specify the data string timezone as UTC, such that to retain the same date/time stamp after converted to UTC data object
        print("UTC timezone: \(TimeZone(abbreviation: "UTC"))")
        dateStringFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let utcDate:Date = dateStringFormatter.date(from: dateString)!
        print("UTC: \(utcDate)")
        
        print("===========================================")
    }
    
    /**
     Convert local date string (GMT+8) to UTC date object
     */
    func testConvertStringToDate() {
        print("===========================================")
        
        //let dateString:String = "2016-12-06T10:52:30.111Z"
        let dateString:String = "2016-12-06T16:00:00.000Z"
        print("input: \(dateString)")
        
        // system will assume date string in local time zone and default convert to UTC Date if timezone not specify
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        print("local timezone: \(TimeZone(secondsFromGMT: 8)?.abbreviation())")
        dateStringFormatter.timeZone = TimeZone(secondsFromGMT: 8) // force the timezone to GMT+8
        
//        print("local timezone: \(NSTimeZone.local.abbreviation())")
//        dateStringFormatter.timeZone = TimeZone(abbreviation: NSTimeZone.local.abbreviation()!)
        
        //dateStringFormatter.locale = NSLocale.init(localeIdentifier: "zh_Hant_HK") as Locale!
        
        let outputDate:Date = dateStringFormatter.date(from: dateString)!
        print("output: \(outputDate)")
        
        print("===========================================")
    }
    
    /**
     Convert of UTC date object to local date string (GMT+8)
    */
    func testConvertDateToString() {
        print("===========================================")
        
        let testDate:Date = Date() // Date object will default to UTC
        print("input: \(testDate)")
        
        // system will assume date string in local time zone and convert to local date string if timezone not specify
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateString = dateStringFormatter.string(from: testDate) //
        print("output: \(dateString)")
        
        print("===========================================")
    }

    func testEndOfDate() {
        print("===========================================")
        
        let inputDate:Date = Date() // default in UTC
        print("input: \(inputDate)")
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: inputDate)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        let outputDate:Date = calendar.date(from: components)!
        print("output: \(outputDate)")
        
        print("===========================================")
    }
    
    func testReflection() {
        print("===========================================")
        
        let test = Test()
        print("### \(NSStringFromClass(object_getClass(test)))")
        
        var testInstance: Test!
        let testClass = NSClassFromString("TestSwift3.Test") as! Test.Type
        testInstance = testClass.init()
        print("result: \(testInstance.testFunction())")
        
        print("===========================================")
    }
    
    func testCastDataType() {
        print("===========================================")
    
        let inputCount:Int? = 1500
        let test:TestStruct = TestStruct(string: String(describing: inputCount))
        
        // casting from String to Int like this will cause runtime error and the compiler cannot catch it
        // since the runtime will assume the value is non-optional and hit error when casting to optional value
        let count:Int = Int(test.string)! // crash in this line
        
        print("@@@ \(count)")
        
        print("===========================================")
    }
    
    func testTryCatch() {
        print("===========================================")
        
        do {
            try testGuard(count: nil)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        print("===========================================")
    }
    
    func testGuard(count:Int?) throws {
        // guard cannot protect from runtime type casting error
        guard
            count != nil // count should not be nil or otherwise goto the else block
            else {
                throw DataConversionError.NonOptionalUnwrappingError
        }
        let countDouble:Double = Double((count)!)
        print("success: \(countDouble))")
    }
    
    func testDataTypeParsing2() {
        print("===========================================")
        
        var testDataTypeArray:[TestDataType] = []
        
        testDataTypeArray.append(TestDataType.steps)
        
        if !testDataTypeArray.contains(TestDataType.steps) {
            print("steps type not specify")
        } else {
            print("steps type specified")
        }
        
        print("===========================================")
    }
    
    
    func testDataTypeParsing() {
        print("===========================================")
        
        var testDataTypeDict:[String: TestDataType] = [:]
        
        testDataTypeDict["steps"] = TestDataType.steps
        print(testDataTypeDict["steps"]!)
        
        if (testDataTypeDict["weight"] == nil) {
            print("weight type not specify")
        }
        
        if (testDataTypeDict["steps"] == nil) {
            print("steps type not specify")
        }
        
        print("===========================================")
    }
    
    func testAbstractDataType4() {
        print("===========================================")
        
        var temp : AnyObject
        temp = NSString()
        temp = NSNull()
        
        if (temp is NSString) {
            print("running instance is NSString")
        }
        
        if (temp is NSNull) {
            print("running instance is NSNull")
        }
        
        print("actual class - \(NSStringFromClass(object_getClass(temp)))")
        print("===========================================")
    }
    
    func testAbstractDataType3() {
        print("===========================================")
        
        var temp : [String]! // temp is an array of type TestClassA and must not be nil
        //print(temp) //accessing temp here will trigger runtime exception
        
        temp = [String]() // now temp has been instantied, but is an empty array
        print(temp) //accessing temp here will be okay
        
        temp.append("test")
        print(temp)
        
        print("===========================================")
    }
    
    func testAbstractDataType2() {
        print("===========================================")
        
        var temp : [String]? // temp is an array of String, but its default is nil
        print(temp)
        
        /* if temp is set to optional, even if its nil,
         * accessing it will not trigger runtime error
         */
        temp?.append("test")
        print(temp?[0])
        
        print("===========================================")
    }
    
    func testAbstractDataType1() {
        print("===========================================")
        
        var temp : [String]! // default will be nil
        
        temp = ["A", "B", "C"]
        
        print(temp)
        
        print("===========================================")
    }
    
    func testAbstractDataType5() {
        print("===========================================")
        
        var temp : [AnyObject]
        temp = [AnyObject]() //instantiate as an empty array
        
        if (temp is AnyObject) {
            print("running instance is AnyObject")
            temp = [NSNull]()
        }
        
        print("actual class - \(NSStringFromClass(object_getClass(temp)))")
        
        print("===========================================")
    }
    
    func testDataType5() {
        print("===========================================")
        
        var temp2 : Int? // temp2 will default to nil
        
        /* To effectively prevent the runtime excepton when certain
         * statement in the code attempt to force un-wrap temp2,
         * add the fail-safe handling to check for nil first
         */
        if (temp2 != nil) {
            print(temp2!)
        } else {
            print(NSNull())
        }
        
        print("===========================================")
    }
    
    func testDataType4() {
        print("===========================================")
        
        var temp1 : Int! = 0 // temp1 will default to 0 and assumed won't be nil in runtime
        
        /* suprisingly assigning nil to a non-optional value here would
         * not introduce compile-time error!!!
         */
        temp1 = nil
        
        /* To effectively prevent the runtime excepton,
         * add the fail-safe handling to check for nil
         * first
         */
        if (temp1 == nil) {
            print(NSNull())
        } else {
            print(temp1)
        }
        
        print("===========================================")
    }
    
    func testDataType3() {
        print("===========================================")
        
        var temp1 : Int! = 0 // temp1 will default to 0 and assumed won't be nil in runtime
        
        /* suprisingly assigning nil to a non-optional value here would
         * not introduce compile-time error!!!
         */
        temp1 = nil
        
        /* since the value is assumed non-optional, during runtime it will force
         * un-wrapping of temp1 but immediately throw runtime exception
         */
        print(temp1)
        
        print("===========================================")
    }
    
    func testDataType2() {
        print("===========================================")
        
        var temp2 : Int? // temp2 will default to nil
        
        /* suprisingly force un-wrapping of temp2 (which is nil) here
         * would not introduce compile-time error!!!
         *
         * Instead a runtime exception will be thrown upon execution
         */
        print(temp2!)
        
        print("===========================================")
    }
    
    func testDataType1() {
        print("===========================================")
        
        var temp1 : Int! = 0 // temp1 will default to 0 and assumed won't be nil in runtime
        
        /* on a 32-bit platform, int is the same as int32
         * on a 64-bit platform, int is the same as int64
         */
        print(temp1)
        
        print("===========================================")
    }
    
    
    func testThreading3() {
        print("===========================================")
        
        DispatchQueue.main.async {
            print("in main thread? \(Thread.isMainThread)")
            Thread.main.setValue("MainThread", forKey: "name")
            print("current thread name: \(Thread.main.name!)")
        }
        
        print("===========================================")
    }
    
    func testThreading2() {
        print("===========================================")
        
        let queue = DispatchQueue(label: "com.test.myqueue")
        queue.async {
            print("in main thread? \(Thread.isMainThread)")
            print("current thread label: \(queue.label)")
            
            // if not in main thread, dispatch the work in main thread
            if !Thread.isMainThread {
                DispatchQueue.main.async {
                    print("in main thread? \(Thread.isMainThread)")
                    print("current queue label: \(queue.label)")
                }
            }
        }
        
        print("===========================================")
    }
    
    func testThreading1() {
        print("===========================================")
        
        for i in 1...10 {
            // just spawn a new thread
            let queue = DispatchQueue(label: "com.test.myqueue-\(i)")
            queue.async {
                print("in main thread? \(Thread.isMainThread)")
                print("current queue label: \(queue.label)")
            }
        }
        
        print("===========================================")
    }
    
    func testCasting4() -> AnyObject {
        print("===========================================")
        
        let temp1 = TestClassA(name: "testing")
        
        /* fail-safe handling to use as? for conditional
         * casting, this can avoid the run-time error (crash)
         * when down-casting an incompatible type
         */
        if let temp2 = temp1 as? NSString {
            return temp2
        } else {
            return NSNull()
        }
        
        print("===========================================")
    }
    
    func testCasting3() -> String {
        print("===========================================")
        
        let temp1 = "testing"
        let temp2 = temp1 as! AnyObject
        
        if temp2 is String {
            print("temp2 is String")
        }
        
        if temp2 is AnyObject {
            print("temp2 is AnyObject")
        }
        
        /* although the actual instance of temp2 is String, it has been
         * casted into AnyObject, therefore cannot match the return type
         * String unless casted back into String
         */
        return temp2 as! String
        
        print("===========================================")
    }
    
    func testCasting2() -> AnyObject {
        print("===========================================")
        
        let temp1 = "testing"
        let temp2 = temp1 as! NSObject
        
        /* since String is a primitive in Swift but not NSObject, in
         * order to match the return type AnyObject, should cast the
         * String into NSObject
         */
        return temp2
        
        print("===========================================")
    }
    
    func testCasting1() -> [String:AnyObject] {
        print("===========================================")
        
        let temp = TestClassA(name: "testing")
        
        if (temp is NSObject) {
            print ("temp is NSObject")
        }
        
        /* if TestClass is an abstract class, it can always match the
         * type AnyObject but NOT NSObject
         *
         * if TestClass inherits NSObject, it will also match the
         * type AnyObject
         */
        return ["1":temp, "2":temp, "3":temp]
        
        print("===========================================")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
}
