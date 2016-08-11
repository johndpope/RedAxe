//
//  CoreRedAxe.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/5/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    var availableTopics = [Topic]()
    var statistic = Statistic()
    var activeTopic : Topic?
    var connectionStatus : Int = 0
    var connectedWithPubNub = false
    var loading = false
}

struct ActionIncrease: Action { var rating : Int}
struct ActionDecrease: Action { var rating : Int}

struct ActionStatrtUploadHistory: Action {}
struct ActionDidUploadWithResult: Action { var history : [VoteMessage]? }
struct ActionDidReceiveVote: Action { var vote : VoteMessage }
struct ActionDidConnect: Action { var vote : VoteMessage }
struct ActionStatrtUploadTopic: Action {}
struct ActionDidUploadWithTopicResult: Action { var topic : [Topic]?}
struct ActionSetActiveTopic: Action { var topic : Topic}
struct ActionConnectWithPubNub: Action { var succes : Bool}

struct FirstScreenReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        var state = state ?? AppState()
        
        switch action {
        case let action as ActionIncrease:
            if let channel = state.activeTopic?.channel {
                PabNabManager.shared.voteUp(channel, rating: action.rating)
            }
            break
        case let action as ActionDecrease:
            if let channel = state.activeTopic?.channel {
                PabNabManager.shared.voteDown(channel, rating: action.rating)
            }
            break
        case let action as ActionConnectWithPubNub:
            state.connectedWithPubNub = action.succes
            break
        case _ as ActionStatrtUploadHistory:
            break
        case let action as ActionSetActiveTopic:
            state.activeTopic = action.topic
            break
        case _ as ActionStatrtUploadTopic:
            state.loading = true
            break
        case let action as ActionDidUploadWithResult:
            state.statistic.insertHistory(action.history)
            break
        case let action as ActionDidReceiveVote:
            state.statistic.appendVote(action.vote)
            break
        case let action as ActionDidUploadWithTopicResult:
            if let availTopic = action.topic {
              state.availableTopics = availTopic
            }
            state.loading = false
            break
        default:
            break
        }
        
        return state
    }
}