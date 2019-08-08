//
//  LinphoneProviderDelegate.swift
//  TestVoip
//
//  Created by Edmund on 8/7/19.
//  Copyright © 2019 Saeid. All rights reserved.
//

import Foundation
import UIKit
import CallKit
import AVFoundation

class LinphoneProviderDelegate: NSObject, CXProviderDelegate, CXCallObserverDelegate{
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        
    }
    
    
    var provider: CXProvider?
    var observer: CXCallObserver?
    var controller: CXCallController?
    var calls: [AnyHashable: Any] = [:]
    var uuids: [AnyHashable: Any] = [:]
//    var pendingCall: LinphoneCall?
//    var pendingAddr: LinphoneAddress?
    
}
