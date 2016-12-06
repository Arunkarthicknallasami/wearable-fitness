//
//  ViewController.swift
//  TestWatchKit
//
//  Created by Jeffrey Garcia on 12/4/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    var mSession: WCSession?
    
    var testBtn1:UIButton?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initSession()
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initUI() {
        print("\(NSStringFromClass(object_getClass(self))) - initUI")
        guard let view = self.view.viewWithTag(1) else {
            return
        }
        
        if (view is UIButton) {
            testBtn1 = view as? UIButton
            testBtn1?.addTarget(self, action:#selector(test1), for: UIControlEvents.touchUpInside)
        }
    }
    
    
    public func test1() {
        print("\(NSStringFromClass(object_getClass(self))) - test1 clicked")
    }
    
    func initSession() {
        print("\(NSStringFromClass(object_getClass(self))) - initSession")
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
    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("\(NSStringFromClass(object_getClass(self))) - activationDidComplete")
        mSession = session
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        print("\(NSStringFromClass(object_getClass(self))) - sessionDidDeactivate")
        mSession = session
    }
    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(NSStringFromClass(object_getClass(self))) - sessionDidBecomeInactive")
        mSession = session
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print(message.values)
        
        var replyValues = Dictionary<String, Any>()
        replyValues["Send"] = "Resp from Phone"
        // Using the block to send back a message to the Watch
        replyHandler(replyValues)
        
        DispatchQueue.main.async {
            self.testBtn1?.setTitle("received", for: UIControlState.normal)
        }
        
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message.values)
    }
    
    
}

