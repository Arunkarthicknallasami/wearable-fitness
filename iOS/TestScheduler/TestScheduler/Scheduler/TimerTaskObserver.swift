//
//  JobExecutor.swift
//  TestScheduler
//
//  Created by Jeffrey Garcia on 10/6/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//
import UIKit

public class TimerTaskObserver {
    public static let shared = TimerTaskObserver()
    
    private init() {}
    
    /**
     Job executor when observer recieved an event
     */
    @objc public func execute(notification: NSNotification) {
        //let identifier:String = notification.object as! String
        
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        print("execute... id: \(notification.name.rawValue)")
//        for index in 1...10000 {
//            print("@@@ \(index)")
//        }
        
    }
}
