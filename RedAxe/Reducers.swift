//
//  CoreRedAxe.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/5/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    var counter : Int = 0
    var isEditableField : Bool = false
    var mainUserName : String = ""
    var image : UIImage?
    var loading = false
}

struct FirstScreenActionIncrease: Action {}
struct FirstScreenActionDecrease: Action {}
struct FirstScreenActionDidStatrtUpload: Action {}
struct FirstScreenActionDidEndUpload: Action {}
struct FirstScreenActionEditUser: Action {
    var userName : String
}

struct FirstScreenActionImage: Action {
    var image : UIImage
}

struct FirstScreenReducer: Reducer {
    func handleAction(action: Action, state: AppState?) -> AppState {
        var state = state ?? AppState()
        
        switch action {
        case _ as FirstScreenActionIncrease:
            state.counter += 1
            
        case _ as FirstScreenActionDecrease:
            state.counter -= 1
            
        case let action as FirstScreenActionEditUser:
            state.isEditableField = !state.isEditableField
            state.mainUserName = action.userName
            
        case let action as FirstScreenActionImage:
            state.image = action.image
            
        case _ as FirstScreenActionDidStatrtUpload:
            state.loading = true
            
        case _ as FirstScreenActionDidEndUpload:
            state.loading = false
            
        default:
            break
        }
        
        return state
    }
}