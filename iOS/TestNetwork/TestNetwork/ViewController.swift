//
//  ViewController.swift
//  TestNetwork
//
//  Created by Jeffrey Garcia on 11/5/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var testNetworkBtn1 : UIButton?
    var testNetworkBtn2 : UIButton?
    var testStatusLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(NSStringFromClass(object_getClass(self))) - viewDidLoad")
        
        // Get the parent controller - will be the Navigation Controller if its contained by it
        print("parent class: \(NSStringFromClass(object_getClass(self.parent)))")
        
        // Set the title of the navigation bar
        self.title = "Main"
        
        self.initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func initUI() -> Void {
        self.testStatusLabel = self.view.viewWithTag(1) as? UILabel
        print("status label: \(object_getClass(testStatusLabel))")
        
        if let btn1 = self.view.viewWithTag(2) as? UIButton {
            testNetworkBtn1 = btn1
            print("btn1: \(object_getClass(testNetworkBtn1))")
            testNetworkBtn1?.addTarget(self, action: #selector(ViewController.testNetwork1), for: UIControlEvents.touchUpInside)
        }

        if let btn2 = self.view.viewWithTag(3) as? UIButton {
            testNetworkBtn2 = btn2
            print("btn2: \(object_getClass(testNetworkBtn2))")
            testNetworkBtn2?.addTarget(self, action: #selector(ViewController.testNetwork2), for: UIControlEvents.touchUpInside)
        }
    }
    
    func testNetwork1() {
        let result = CustomReachability.isNetworkAvailable()
        print("network available? \(result)")
        testStatusLabel?.text = "network available? \(result)"
    }
    
    func testNetwork2() {
        let result = CustomReachability.isConnectedToInternet()
        print("internet connected? \(result)")
        testStatusLabel?.text = "internet connected? \(result)"
    }

    func testNetwork3() {
        let result = CustomReachability.isConnectedToInternet_NSURLConnection()
        print("internet connected? \(result)")
        testStatusLabel?.text = "internet connected? \(result)"
    }
}

