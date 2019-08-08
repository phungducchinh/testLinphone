//
//  ViewController.swift
//  TestVoip
//
//  Created by Saeid Basirnia on 2/20/18.
//  Copyright © 2018 Saeid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
//    var answerCall: Bool = true
    
    struct theLinphone {
        static var lc: OpaquePointer?
        static var lct: LinphoneCoreVTable?
        static var manager: AILinphoneManager?
    }
    
    let registrationStateChanged: LinphoneCoreRegistrationStateChangedCb  = {
        (lc: Optional<OpaquePointer>, proxyConfig: Optional<OpaquePointer>, state: _LinphoneRegistrationState, message: Optional<UnsafePointer<Int8>>) in
        
        switch state{
        case LinphoneRegistrationNone: /**<Initial state for registrations */
            print("Hey!!! LinphoneRegistrationNone")
            
        case LinphoneRegistrationProgress:
            print("Hey!!! LinphoneRegistrationProgress")
            
        case LinphoneRegistrationOk:
            print("Hey!!! LinphoneRegistrationOk")
            
        case LinphoneRegistrationCleared:
            print("Hey!!! LinphoneRegistrationCleared")
            
        case LinphoneRegistrationFailed:
            print("Hey!!! LinphoneRegistrationFailed")
            
        default:
            print("Hey!!! Unkown registration state")
        }
        } as LinphoneCoreRegistrationStateChangedCb
    
    let callStateChanged: LinphoneCoreCallStateChangedCb = {
        (lc: Optional<OpaquePointer>, call: Optional<OpaquePointer>, callSate: LinphoneCallState,  message: Optional<UnsafePointer<Int8>>) in
        
//        switch callSate{
//        case LinphoneCallStateIncomingReceived: /**<This is a new incoming call */
//            print("Hey!!! callStateChanged: LinphoneCallIncomingReceived")
//
//            if answerCall{
//                ms_usleep(3 * 1000 * 1000) // Wait 3 seconds to pickup
//                linphone_call_accept_update(call, lc)
//            }
//
//        case LinphoneCallStateStreamsRunning: /**<The media streams are established and running*/
//            print("Hey!!! callStateChanged: LinphoneCallStreamsRunning")
//
//        case LinphoneCallError: /**<The call encountered an error*/
//            print("Hey!!! callStateChanged: LinphoneCallError")
//
//        default:
//            print("Hey!!! Default call state")
//        }
    }
    
    var manager = AILinphoneManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.register()
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

