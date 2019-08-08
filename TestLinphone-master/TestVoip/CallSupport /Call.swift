//
//  Call.swift
//  TestVoip
//
//  Created by Edmund on 8/6/19.
//  Copyright © 2019 Saeid. All rights reserved.
//

import Foundation

enum CallStates {
    case connecting
    case active
    case held
    case ended
}

enum ConnectedState {
    case pending
    case complete
}

class Call {
    let uuid: UUID
    let outgoing: Bool
    let handle: String
    
    var state: CallStates = .ended{
        didSet{
            stateChanged?()
        }
    }
    
    var connectedStates: ConnectedState = .pending{
        didSet{
            connectedStateChanged?()
        }
    }
    
    var stateChanged: (() -> Void)?
    var connectedStateChanged: (() -> Void)?
    
    init(uuid: UUID, outgoing: Bool = false, handle: String) {
        self.uuid = uuid
        self.outgoing = outgoing
        self.handle = handle
    }
    
    func start(completion: ((_ success: Bool) -> Void)?){
        completion?(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.state = .connecting
            self.connectedStates = .pending
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                self.state = .active
                self.connectedStates = .complete
            }
        }
    }
    
    func answer(){
        state = .active
    }
    
    func end(){
        state = .ended
    }
}
