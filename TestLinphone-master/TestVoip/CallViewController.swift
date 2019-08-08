//
//  CallViewController.swift
//  TestVoip
//
//  Created by Edmund on 8/7/19.
//  Copyright © 2019 Saeid. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {
    var manager = AILinphoneManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.register()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onActionSend(_ sender: Any) {
        AICallManager.shared.outgoingCall(from: "edmund@sip.linphone.org", connectAfter: 0)
        manager.demo()
    }
    
    @IBAction func onActionReceive(_ sender: Any) {
         AICallManager.shared.incomingCall(from: "testgumi@sip.linphone.org", delay: 0)
    }
    
    @IBAction func onActionReceiveWithDelay(_ sender: Any) {
         AICallManager.shared.incomingCall(from: "testDelaygumi@sip.linphone.org", delay:0 )
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
