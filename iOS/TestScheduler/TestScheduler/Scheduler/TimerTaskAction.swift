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
        
        if (isRunningForeground) {
            // task will be killed immediately in real-device with no chance of survival under iOS 9.3.1
            // no longer an issue in iOS 9.3.5
            
            print("@@@ perform... id: \(identifier)")
            
            // do some very light-weight work here
            //LocalNotificationManager.shared.createNotification()
            
            // post event to the designated identifier
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: identifier), object: nil)
            
        } else {
            if (UIApplication.shared.backgroundTimeRemaining == DBL_MAX) {
                print("un-determined...")
            } else {
                /*
                 Have a total of 180s for executing tasks for each time the app goes into background,
                 once 180s is reached no more work can be executed by the Timer task.
                 The budget will be reset to 180s if when the app resumes to foreground
                */
                
                print("@@@ perform... id:\(identifier) ,time remains: \(UIApplication.shared.backgroundTimeRemaining)")
                
                // do some very light-weight work here
                //LocalNotificationManager.shared.createNotification()
                
                // post event to the designated identifier
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: identifier), object: nil)
            }
        }
    }
    
}
