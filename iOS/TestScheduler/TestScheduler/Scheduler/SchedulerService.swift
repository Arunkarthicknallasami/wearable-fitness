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
     Create the task
     
     some description here
     
     - parameters:
       - identifier: a String to unique identify the specific timer task
     
     - returns: return data
     */
    public func createTask(identifier:String) -> Bool {
        if (timerTaskDict[identifier] == nil) {
            
            // schedule a timer task that runs every 5 seconds
            print("create timer task: \(identifier)")
            
            let timerTask:Timer = Timer.scheduledTimer(timeInterval: 5.0, target: TimerTaskAction.shared, selector: #selector(TimerTaskAction.shared.perform), userInfo: identifier, repeats: true)
            
            // register an observer with a designated identifier
            print("register observer to NotificationCenter with id: \(identifier)")
            NotificationCenter.default.addObserver(TimerTaskObserver.shared, selector: #selector(TimerTaskObserver.execute), name:NSNotification.Name(rawValue: identifier), object: nil)
            
            timerTaskDict[identifier] = timerTask
            
            return true
        }
        
        return false
    }
    
    public func destroyTask(identifier:String) -> Bool {
        if (timerTaskDict[identifier] != nil) {
            
            print("invalidte timer task: \(identifier)")
            let timerTask:Timer = timerTaskDict[identifier]!
            timerTask.invalidate()
            timerTaskDict.removeValue(forKey: identifier)
            
            print("destroy observer to NotificationCenter with id: \(identifier)")
            NotificationCenter.default.removeObserver(TimerTaskObserver.shared, name: NSNotification.Name(rawValue: identifier), object: nil)
            
            return true
        }
        
        return false
    }
}
