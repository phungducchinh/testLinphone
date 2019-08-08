//
//  CallManager.swift
//  TestVoip
//
//  Created by Edmund on 8/6/19.
//  Copyright © 2019 Saeid. All rights reserved.
//

import Foundation
import CallKit
import PushKit

class CallManager{
    var callsChangedHandler: (() -> Void)?
    
    private(set) var calls: [Call] = []
    
    func callWithUUID(uuid: UUID) -> Call? {
        guard  let index = calls.index(where: { $0.uuid == uuid}) else {
            return nil
        }
        return calls[index]
    }
    
    func add(call: Call){
        calls.append(call)
        call.stateChanged = {[weak self] in
            guard let self = self else { return }
            self.callsChangedHandler?()
        }
        callsChangedHandler?()
    }
    
    func remove(call: Call){
        guard let index = calls.index(where: { $0 === call }) else { return }
        calls.remove(at: index)
        callsChangedHandler?()
    }
    
    func removeAllCalls(){
        calls.removeAll()
        callsChangedHandler?()
    }
}
