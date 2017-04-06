//
//  SchedulerService.swift
//  TestScheduler
//
//  Created by Jeffrey Garcia on 10/6/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//
import UIKit

public class SchedulerService {
    public static let shared = SchedulerService()
    
    private init() {}
    
    private var timerTaskDict:Dictionary = [String:Timer]()
    
    
    /**
     Create the schedule task
     
     some description here
     
     - parameters:
       - identifier: a String to uniquely identify the specific timer task
     
     - returns: return true if the timer task is created, otherwise false
     */
    public func createTask(identifier:String) -> Bool {
        if (timerTaskDict[identifier] == nil) {
            print("create timer task: \(identifier)")
            
            // schedule a timer task that runs every 5 seconds
            let timerTask:Timer = Timer.scheduledTimer(timeInterval: 5.0, target: TimerTaskAction.shared, selector: #selector(TimerTaskAction.shared.perform), userInfo: identifier, repeats: true)
            
            // register an observer in notification center and exectue the observer task when being notified
            print("register observer to NotificationCenter with id: \(identifier)")
            NotificationCenter.default.addObserver(TimerTaskObserver.shared, selector: #selector(TimerTaskObserver.execute), name:NSNotification.Name(rawValue: identifier), object: nil)
            
            //
            timerTaskDict[identifier] = timerTask
            
            return true
        }
        
        return false
    }
    
    /**
     Destroy the schedule task
     
     some description here
     
     - parameters:
     - identifier: a String to uniquely identify the specific timer task
     
     - returns: return true if the timer task is destroy, otherwise false
     */
    public func destroyTask(identifier:String) -> Bool {
        if (timerTaskDict[identifier] != nil) {
            print("invalidte timer task: \(identifier)")
            
            // invalidate the timer task
            let timerTask:Timer = timerTaskDict[identifier]!
            timerTask.invalidate()
            timerTaskDict.removeValue(forKey: identifier)
            
            // un-register the observer task from the notification center
            print("destroy observer to NotificationCenter with id: \(identifier)")
            NotificationCenter.default.removeObserver(TimerTaskObserver.shared, name: NSNotification.Name(rawValue: identifier), object: nil)
            
            return true
        }
        
        return false
    }
}
