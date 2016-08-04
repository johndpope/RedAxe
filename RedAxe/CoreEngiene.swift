//
//  CoreEngiene.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/4/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import Foundation

public protocol Action {}
public protocol State {}
public protocol Reducer {}
public protocol StateType { }

struct AppState {
    var counter = 0
}

struct CounterActionIncrease: Action {}
struct CounterActionDecrease: Action {}



struct CounterReducer: Reducer {
    func handleAction(action: Action, state: AppState?) -> AppState {
        var state = state ?? AppState()
        
        switch action {
        case _ as CounterActionIncrease:
            state.counter += 1
        case _ as CounterActionDecrease:
            state.counter -= 1
        default:
            break
        }
        
        return state
    }
    
}