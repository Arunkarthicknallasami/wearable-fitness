//
//  LocalNotificationManager.swift
//  TestScheduler
//
//  Created by jeffrey on 2/11/2017.
//  Copyright © 2017 Jeffrey Garcia. All rights reserved.
//

import UIKit
import UserNotifications

public class LocalNotificationManager {
    public static let shared = LocalNotificationManager()
    
    private init() {}
    
    // at most 180 local notifications can be scheduled
    public func createNotification() {
        // Create a new local notification
        if #available(iOS 10.0, *) {
            let notification = UNMutableNotificationContent()
            notification.title = "Test Local Push"
            notification.body = "this is a test local push notification"
            notification.sound = UNNotificationSound.default()
            
            // Deliver the notification immediately.
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 10, repeats: false)
            
            // Schedule the notification
            let request = UNNotificationRequest(identifier: "LocalPushNotification", content: notification, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    center.add(request) { (error) in
                        if let error = error {
                            print("error: \(error.localizedDescription)")
                        } else {
                            print("should have been added")
                        }
                    }
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    public func requestForPushAuthorization() {
        if #available(iOS 10.0, *) {
            let options: UNAuthorizationOptions = [.alert, .sound];
            let center = UNUserNotificationCenter.current()
            
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    // Notifications not allowed
                    center.requestAuthorization(options: options) {
                        (granted, error) in
                        if !granted {
                            print("error: \(String(describing: error?.localizedDescription))")
                            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                        }
                    }
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    public func createAlert() {
        // call this when the notification is received while app in foreground
        let alert = UIAlertController(title: "Test Local Push", message: "this is a test local push notification", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
