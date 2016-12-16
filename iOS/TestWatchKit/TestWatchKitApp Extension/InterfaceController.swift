//
//  InterfaceController.swift
//  TestWatchKitApp Extension
//
//  Created by Jeffrey Garcia on 12/4/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//
//  [References:]
//  https://developer.apple.com/library/content/documentation/General/Conceptual/WatchKitProgrammingGuide/SharingData.html#//apple_ref/doc/uid/TP40014969-CH29-SW1
//
//  https://forums.developer.apple.com/thread/16003
//
//  https://developer.apple.com/reference/watchconnectivity/wcsession
//  https://developer.apple.com/reference/watchconnectivity/wcsession/1615687-sendmessage
//  https://developer.apple.com/reference/watchconnectivity/wcsessiondelegate
//
//  https://forums.developer.apple.com/thread/4034
//  https://forums.developer.apple.com/thread/52363
//
//  http://stackoverflow.com/questions/31282834/wcsession-sendmessage-works-50-50
//  http://stackoverflow.com/questions/37500753/watchconnectivity-sendmessagereplyhandler-dont-work-when-linker-have-flag-ob
//
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet var button: WKInterfaceButton!
    
    var mSession: WCSession?
    
    override init() {
        // Initialize properties here.
        super.init()
        print("\(NSStringFromClass(object_getClass(self))) - init")
    }
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        print("\(NSStringFromClass(object_getClass(self))) - awake")
        
        initSession()
        
        // It is now safe to access interface objects.
        initUI()
    }
    
    func initUI() {
        // Configure an attributed string with custom font information
        guard let customFont = UIFont(name: "Helvetica", size: 17.0) else {
            label.setText("Hello World!!!")
            return
        }
        
        let fontAttrs = [NSFontAttributeName : customFont]
        let attrString = NSAttributedString(string: "Hello World!!!", attributes: fontAttrs)
        label.setAttributedText(attrString)
        
        button.setTitle("click me")
    }
    
    override func willActivate() {
        // This method is called whenever watch view controller is about to be visible to user
        super.willActivate()
        print("\(NSStringFromClass(object_getClass(self))) - willActivate")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func buttonAction() {
        print("\(NSStringFromClass(object_getClass(self))) - buttonAction")
        sendMessageToPhone()
    }
    
    
    /**
     Send data immediately to the phone app. 
     
     Note that the counterpart app must be reachable before calling this method 
     while the Phone app is always considered reachable, and calling this method 
     from the Watch app wakes up the Phone app in the background as needed.
     
     Data is transmitted immediately and messages are queued and delivered in 
     the order in which they were sent. These methods must initiate their 
     transfers in the foreground.
    */
    func sendMessageToPhone() {
        print("\(NSStringFromClass(object_getClass(self))) - sendMessageToPhone")
        
        guard mSession != nil else {
            print("no valid session to connect")
            return
        }
        
        var dict:[String:Any] = [:]
        dict["test_data_1"] = "Test Data 1"
        
        print("phone is reachable? \(mSession?.isReachable)")
        
        guard mSession?.activationState == WCSessionActivationState.activated else {
            print("Session not activated")
            return
        }
        
        mSession?.sendMessage(dict, replyHandler: {
            (replyDict) in
            print("Response message: \(replyDict["Send"])")
            
            guard let responseStr:String = replyDict["Send"] as? String else {
                return
            }
            self.label.setText(responseStr)
            
        }, errorHandler: {
            (error) in
            print("Error occured: \(error)")
        })
    }
    
    func initSession() {
        let session: WCSession? = WCSession.isSupported() ? WCSession.default():nil
        
        if (session != nil) {
            guard let _:Bool = session?.isReachable else {
                return
            }
            
            print("WCSession state: \(session?.activationState)")
            if (session?.activationState != WCSessionActivationState.activated) {
                session?.delegate = self
                session?.activate()
            }
        }
    }
    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("\(NSStringFromClass(object_getClass(self))) - activationDidComplete")
        mSession = session
    }
    
//    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        print(message.values)
//        
//        var replyValues = Dictionary<String, Any>()
//        replyValues["Send"] = "Received from watch"
//        // Using the block to send back a message to the Watch
//        replyHandler(replyValues)
//    }
//    
//    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        print(message.values)
//    }
    
}
