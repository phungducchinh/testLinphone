//
//  AICallManager.swift
//  TestVoip
//
//  Created by Edmund on 8/7/19.
//  Copyright © 2019 Saeid. All rights reserved.
//

import Foundation
import UIKit
import CallKit
import PushKit

class AICallManager: NSObject{
    static let shared: AICallManager = AICallManager()
    private var provider: CXProvider?
    
    private override init() {
        super.init()
        self.configureProvider()
    }
    
    private func configureProvider(){
        let config = CXProviderConfiguration(localizedName: "AI Call")
        config.supportsVideo = true
        config.supportedHandleTypes = [.emailAddress, .generic, .phoneNumber]
        provider = CXProvider(configuration: config)
        provider?.setDelegate(self, queue: DispatchQueue.main)
    }
    
    private let voipRegistry = PKPushRegistry(queue: nil)
    public func configPushkit(){
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    public func incomingCall(from: String){
        incomingCall(from: from, delay: 0)
    }
    
    public func incomingCall(from: String, delay: TimeInterval){
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .emailAddress, value: from)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            self.provider?.reportNewIncomingCall(with: UUID(), update: update, completion: {(_) in})
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
    
    public func outgoingCall(from: String, connectAfter: TimeInterval){
        let controller = CXCallController()
        let fromHandle = CXHandle(type: .emailAddress, value: from)
        let startCallAction = CXStartCallAction(call: UUID(), handle: fromHandle)
        startCallAction.isVideo = true
        let startCallTransaction = CXTransaction(action: startCallAction)
        controller.request(startCallTransaction, completion: {(error) in })
        
        self.provider?.reportOutgoingCall(with: UUID(), startedConnectingAt: nil)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + connectAfter){
            self.provider?.reportOutgoingCall(with: startCallAction.callUUID, startedConnectingAt: nil)
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
}

extension AICallManager: CXProviderDelegate{
    func providerDidReset(_ provider: CXProvider) {
        print("provider did reset")
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("call answered")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("call ended")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("call started")
        action.fulfill()
    }
    
}

extension AICallManager: PKPushRegistryDelegate{
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let parts = pushCredentials.token.map { String(format: "%02.2hhx", $0) }
        let token = parts.joined()
        print("did update push credentials with token: \(token)")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        if let callerID = payload.dictionaryPayload["callerID"] as? String{
            print(callerID)
            self.incomingCall(from: callerID)
        }else{
            print(payload.dictionaryPayload as Any)
        }
    }
    
}
