//
//  ViewController.swift
//  TestSwift3
//
//  Created by Jeffrey Garcia on 9/1/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(NSStringFromClass(object_getClass(self))) - viewDidLoad")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

