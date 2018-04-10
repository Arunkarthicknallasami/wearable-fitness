//
//  AppDelegate.swift
//  TestScheduler
//
//  An experimental app to illustrate task scheduling in iOS which 
//
//
//  High-level implementation
//  1. first to create a Timer task which runs itself periodically
//  2. the task will check for any outstanding job and post event to NotificationCenter
//  3. an observer monitoring the event will then execute the outstanding job
//  4. keep the task survival for a small amount of time (180s) to allow the completion of job in progress
//  5. wake the app periodicially from background using background fetch to run the job
//
//  Refereces:
//  http://stackoverflow.com/questions/27158970/possible-to-make-a-task-scheduler-for-ios
//  http://stackoverflow.com/questions/24007518/how-can-i-use-nstimer-in-swift
//  http://stackoverflow.com/questions/24049020/nsnotificationcenter-addobserver-in-swift
//  http://stackoverflow.com/questions/20112445/best-way-to-schedule-a-background-task-for-ios
//
//  Background App Refresh:
//  https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/BackgroundExecution/BackgroundExecution.html
//  https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/BackgroundExecution/BackgroundExecution.html#//apple_ref/doc/uid/TP40007072-CH4-SW56
//  https://developer.apple.com/reference/uikit/uiapplication/1623029-backgroundtimeremaining
//  https://developer.apple.com/reference/uikit/uiapplicationdelegate/1623125-application
//  https://blog.newrelic.com/2016/01/13/ios9-background-execution/
//  http://stackoverflow.com/questions/9220494/how-do-i-make-my-app-run-an-nstimer-in-the-background/9623490#9623490
//  
//  Grand-Central-Dispatch:
//  https://developer.apple.com/reference/dispatch
//  https://www.raywenderlich.com/60749/grand-central-dispatch-in-depth-part-1
//
//  Created by Jeffrey Garcia on 10/6/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var backgroundTask: UIBackgroundTaskIdentifier?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("--> applicationDidFinishLaunchingWithOptions - \(UIApplication.shared.applicationState.rawValue)")
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("--> applicationDidBecomeActive - \(UIApplication.shared.applicationState.rawValue)")

        LocalNotificationManager.shared.requestForPushAuthorization()
        
//        let result1:Bool = SchedulerService.shared.createTask(identifier: "test-id-1")
//        print("--> task creation result: \(result1)");
        
//        let result2:Bool = SchedulerService.shared.createTask(identifier: "test-id-2")
//        print("--> task creation result: \(result2)");
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("--> applicationWillResignActive - \(UIApplication.shared.applicationState.rawValue)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("--> applicationDidEnterBackground - \(UIApplication.shared.applicationState.rawValue)")
        
//        let result1:Bool = SchedulerService.shared.destroyTask(identifier: "test-id-1")
//        print("--> task detroy result: \(result1)");

//        let result2:Bool = SchedulerService.shared.destroyTask(identifier: "test-id-2")
//        print("--> task detroy result: \(result2)");
        
        // keep the app survival in background to complete some long running task (only have at most 180s to complete the work)
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            // Clean up any unfinished task business by marking where you
            // stopped or ending the task outright
            
            UIApplication.shared.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = UIBackgroundTaskInvalid
            
            print("--> Background task expired!")
        })
        
        // Start the long-running task and return immediately (only have at most 180s to complete the work)
        // Move to a background thread to do some long running work
        DispatchQueue.main.async( execute: {
            // Do the work associated with the task, preferably in chunks.
            print("Async")
            let result1:Bool = SchedulerService.shared.createTask(identifier: "test-id-1")
            print("--> task creation result: \(result1)");
        })
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("--> applicationWillEnterForeground - \(UIApplication.shared.applicationState.rawValue)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // this function will get called only when Background Modes is enabled in App's Capabilities
        // (background fetch is not necessary)
        
        // schedule a local notification that happens in future
        LocalNotificationManager.shared.createNotification()
        
        // give a little break for the tasks ahead to be executed before iOS swap the app's process away from memory
        sleep(5)
        
        print("--> applicationWillTerminate - \(UIApplication.shared.applicationState.rawValue)")
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        // use the iOS Background Fetch feature where we can specify minimum background fetch interval. But actual interval between successive invocation of the code will be determined by iOS framework, out of control from the hands of developer
        print("--> performFetchWithCompletionHandler");
        
        // do some work then invoke the completion handler
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // Called when Local Notification is received while the application is active and running in the foreground
        print("--> didReceive UILocalNotification - \(UIApplication.shared.applicationState.rawValue)")
        
        LocalNotificationManager.shared.createAlert()
    }
    
}

