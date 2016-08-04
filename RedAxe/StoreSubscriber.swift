//
//  StoreSubscriber.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/4/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import Foundation

public protocol AnyStoreSubscriber: class {
    func _newState(state: Any)
}

public protocol StoreSubscriber: AnyStoreSubscriber {
    associatedtype StoreSubscriberStateType
    
    func newState(state: StoreSubscriberStateType)
}

extension StoreSubscriber {
    public func _newState(state: Any) {
        if let typedState = state as? StoreSubscriberStateType {
            newState(typedState)
        }
    }
}