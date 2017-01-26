//
//  TimerTaskAction.swift
//  TestScheduler
//
//  Created by Jeffrey Garcia on 10/6/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//
import UIKit

public class TimerTaskAction {
    public static let shared = TimerTaskAction()
    
    private init() {}
    
    /**
     Called every time interval from the timer
     */
    @objc func perform(timer:Timer) {
        let identifier:String = timer.userInfo as! String
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        let isRunningForeground:Bool = UIApplication.shared.applicationState == UIApplicationState.active
        
        if (isRunningForeground) { // task will be killed immediately in real-device with no chance of survival under iOS 9.3.x
            print("@@@ perform... id: \(identifier)")
            
            // do some very light-weight work here
            
            // post event to the designated identifier
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: identifier), object: nil)
            
        } else {
            ///
            /// The maximum mount of time the app has to run in the background before it may be forcibly 
            /// killed by the system is 180 seconds, to enable it the app starts one or more long-running 
            /// tasks using the beginBackgroundTask(expirationHandler:) method and then transitions to the 
            /// background
            ///
            /// See: AppDelegate - applicationDidEnterBackground
            ///
            if (UIApplication.shared.backgroundTimeRemaining == DBL_MAX) {
                print("un-determined...")
            } else {
                print("@@@ perform... id:\(identifier) ,time remains: \(UIApplication.shared.backgroundTimeRemaining)")
                
                // do some very light-weight work here
                
                // post event to the designated identifier
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: identifier), object: nil)
            }
        }
    }
    
}
