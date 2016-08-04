//
//  Store.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/4/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import Foundation

public typealias Dispatch = Action -> Action

public struct Store<State> {
    typealias SubscriptionType = Subscription<State>
    
    var subscriptions = [SubscriptionType]()
    
    var reducer : Reducer
    
    var state: State?
    
    var dispatchFunc : Dispatch?
    
    public init(reducer: Reducer, state: State?) {
        self.init(reducer: reducer, state: state, dispatchFunc: nil)
    }
    
    public init(reducer: Reducer, state: State?, dispatchFunc : Dispatch?) {
        self.reducer = reducer
        self.state = state
        self.dispatchFunc = dispatchFunc
    }
    
    public func subscribe<S: StoreSubscriber
        where S.StoreSubscriberStateType == State>(subscriber: S) {
        subscribe(subscriber)
    }
    
    public mutating func subscribe<SelectedState, S: StoreSubscriber
        where S.StoreSubscriberStateType == SelectedState>
        (subscriber: S, selector: ((State) -> SelectedState)?) {
        if !_isNewSubscriber(subscriber) { return }
        
        subscriptions.append(Subscription(subscriber: subscriber, selector: selector))
        
        if let state = self.state {
            subscriber._newState(selector?(state) ?? state)
        }
    }
    
    public mutating func unsubscribe(subscriber: AnyStoreSubscriber) {
        if let index = subscriptions.indexOf({ return $0.subscriber === subscriber }) {
            subscriptions.removeAtIndex(index)
        }
    }
    
    private func _isNewSubscriber(subscriber: AnyStoreSubscriber) -> Bool {
        let contains = subscriptions.contains({ $0.subscriber === subscriber })
        
        if contains {
            print("Store subscriber is already added, ignoring.")
            return false
        }
        
        return true
    }

    public func dispatch(action: Action) -> Any {
        let returnValue = dispatchFunc!(action)
        
        return returnValue
    }
}