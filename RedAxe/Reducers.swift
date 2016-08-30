//
//  CoreRedAxe.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/5/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    var pageIndex = 0
    var reachability  = true
    var connectedWithPubNub = false
    
    var availableTopics = [Topic]()
    var statistic = Statistic()
    var activeTopic : Topic?
    var connectionStatus : Int = 0
    
    var loading = false
}

struct ActionIncrease: Action { var rating : Int, targetID : Int}
struct ActionDecrease: Action { var rating : Int, targetID : Int}

struct ActionStatrtUploadHistory: Action {}
struct ActionDidUploadWithResult: Action { var history : [VoteMassage]? }
struct ActionDidReceiveVote: Action { var vote : VoteMassage }
struct ActionDidConnect: Action { var vote : VoteMassage }
struct ActionStatrtUploadTopic: Action {}
struct ActionDidUploadWithTopicResult: Action { var topic : [Topic]?}
struct ActionSetActiveTopic: Action { var topic : Topic}
//Reachability
struct ActionConnectWithPubNub: Action { var succes : Bool}
struct ActionReachability: Action { var succes : Bool}
//Page index
struct ActionDidChangePageIndex: Action { var index : Int}

struct ActionUpdateTopicVoteLevel: Action { var rating : Int, vote : Bool, targetID : Int}

struct FirstScreenReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        var state = state ?? AppState()
        
        switch action {
        case let action as ActionUpdateTopicVoteLevel:
            if let status = state.activeTopic?.status {
                let voteValue = action.vote ? action.rating : -action.rating
                let rating = state.activeTopic!.themes![status].rating! + voteValue
                let targetID = action.targetID
                var appendRating = rating > 50 ? 0 : voteValue
                appendRating = rating >= 0 ? appendRating : 0
                
                state.activeTopic!.themes![targetID].rating! += appendRating
                state.activeTopic!.themes![targetID].votesCount! += 1
                state.activeTopic!.themes![targetID].votesLevel! += action.vote ? 1 : -1
            }
            break
        case let action as ActionIncrease:
            if let channel = state.activeTopic?.channel {
                state.activeTopic?.status = action.targetID
                PabNabManager.shared.voteUp(channel, rating: action.rating, targetID: action.targetID)
            }
            break
        case let action as ActionDecrease:
            if let channel = state.activeTopic?.channel {
                state.activeTopic?.status = action.targetID
                PabNabManager.shared.voteDown(channel, rating: action.rating, targetID: action.targetID)
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
        case let action as ActionReachability:
            state.reachability = action.succes
            break
        case let action as ActionDidChangePageIndex:
            state.pageIndex = action.index
            break
        default:
            break
        }
        
        return state
    }
}