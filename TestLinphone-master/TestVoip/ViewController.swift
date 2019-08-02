//
//  ViewController.swift
//  TestVoip
//
//  Created by Saeid Basirnia on 2/20/18.
//  Copyright © 2018 Saeid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var manager = LinphoneManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.idle()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onActionCall(_ sender: Any) {
        manager.demo()
    
    }
    
}

