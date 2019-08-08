//
//  AppDelegate.swift
//  TestVoip
//
//  Created by Saeid Basirnia on 2/20/18.
//  Copyright © 2018 Saeid. All rights reserved.
//

import UIKit
import PushKit
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let callManager = CallManager()
    var del: ProviderDelegate!
    var configURL: String?
    var voipRegistry: PKPushRegistry?
    var isRegisteredForNotification: Bool?
    var shortcutItem: UIApplicationShortcutItem?
    private var provider: CXProvider?
    let linphoneManager = LinphoneManager.instance()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        providerDelegate = ProviderDelegate(callManager: callManager)
        AICallManager.shared.configPushkit()
        voipRegistration()
        return true
    }
    
    func voipRegistration(){
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
        linphoneManager?.startLinphoneCore()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.linphoneManager?.becomeActive()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: PKPushRegistryDelegate{
    
    private func configureProvider(){
        let config = CXProviderConfiguration(localizedName: "AI Call")
        config.supportsVideo = true
        config.supportedHandleTypes = [.emailAddress, .generic, .phoneNumber]
        provider = CXProvider(configuration: config)
        provider?.setDelegate(self, queue: DispatchQueue.main)
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
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let parts = pushCredentials.token.map { String(format: "%02.2hhx", $0) }
        let token = parts.joined()
        print("did update push credentials with token: \(token)")
        linphoneManager?.setupPushNotificationToken(token.data(using: .utf8))
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
extension AppDelegate: CXProviderDelegate{
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
