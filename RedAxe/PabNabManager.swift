//
//  PabNabManager.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/9/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import UIKit
import ReSwift
import PubNub
import SwiftyJSON

typealias HistorySesponse = (success : Bool,history : [VoteMessage])

class PabNabManager : NSObject, StoreSubscriber {
    static let shared = PabNabManager()
    
    // Instance property
    var client: PubNub?
    
    func setup(){
        let configuration = PNConfiguration(publishKey: "pub-c-7bb3524d-e1f1-4e25-99e9-fee74585e3d9", subscribeKey: "sub-c-d7238842-5e0d-11e6-9bf3-02ee2ddab7fe")
        client = PubNub.clientWithConfiguration(configuration)
        mainStore.subscribe(self)
        client?.addListener(PabNabManager.shared)
    }

    func newState(state: AppState) {
        
    }
    
    func sendMessage(toChannel : String, message : VoteMessage){
        if let jsonMessage = toJSONString(message) {
            client?.publish(jsonMessage, toChannel: toChannel, withCompletion: { (status) in
                print(status.statusCode)
            })
        }
    }
    
    func voteUp(toChannel : String,rating : Int){
        let voteUp = VoteMessage(rating: rating, voteUp: true)
        sendMessage(toChannel,message: voteUp)
    }
    
    func voteDown(toChannel : String,rating : Int){
        let voteDownMesage = VoteMessage(rating: rating, voteUp: false)
        sendMessage(toChannel,message: voteDownMesage)
    }
    
    func uploadVoteHistory(){
        mainStore.dispatch({ (state, store, actionCreatorCallback) in
            self.client?.historyForChannel(Constants.chanel, start: nil, end: nil, limit: 50, withCompletion: { (result, error) in
                actionCreatorCallback({ (state, store) -> Action? in
                    return ActionDidUploadWithResult(history: result?.data.messages as? [VoteMessage])
                })
            })
        })
    }
    
    func dispatchStoreWithConnection(connection : Bool){
        mainStore.dispatch(ActionConnectWithPubNub(succes: connection))
    }
    
    deinit{
        mainStore.unsubscribe(self)
    }
}

extension PabNabManager : PNObjectEventListener {
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.actualChannel != nil {
            
            // Message has been received on channel group stored in message.data.subscribedChannel.
        }
        else {
            
            // Message has been received on channel stored in message.data.subscribedChannel.
        }
        
        print("Received message: \(message.data.message) on channel " +
            "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
            "\(message.data.timetoken)")
    }
    
    // New presence event handling.
    func client(client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout, state-change).
        if event.data.actualChannel != nil {
            
            // Presence event has been received on channel group stored in event.data.subscribedChannel.
        }
        else {
            
            // Presence event has been received on channel stored in event.data.subscribedChannel.
        }
        
        if event.data.presenceEvent != "state-change" {
            
            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) " +
                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        }
        else {
            
            print("\(event.data.presence.uuid) changed state at: " +
                "\(event.data.presence.timetoken) " +
                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) to:\n" +
                "\(event.data.presence.state)");
        }
    }
    
    // Handle subscription status change.
    func client(client: PubNub, didReceiveStatus status: PNStatus) {
        
        if status.category == .PNUnexpectedDisconnectCategory {
            dispatchStoreWithConnection(false)
            // This event happens when radio / connectivity is lost.
        }
        else if status.category == .PNConnectedCategory {
            
            /**
             Connect event. You can do stuff like publish, and know you'll get it.
             Or just use the connected event to confirm you are subscribed for
             UI / internal notifications, etc.
             */
            
            // Select last object from list of channels and send message to it.
            let targetChannel = client.channels().last!
            client.publish("Hello from the PubNub Swift SDK", toChannel: targetChannel,
                           compressed: false, withCompletion: { (publishStatus) -> Void in
                            
                            if !publishStatus.error {
                                self.dispatchStoreWithConnection(true)
                                // Message successfully published to specified channel.
                            }
                            else {
                                self.dispatchStoreWithConnection(false)
                                /**
                                 Handle message publish error. Check 'category' property to find out
                                 possible reason because of which request did fail.
                                 Review 'errorData' property (which has PNErrorData data type) of status
                                 object to get additional information about issue.
                                 
                                 Request can be resent using: publishStatus.retry()
                                 */
                            }
            })
        }
        else if status.category == .PNReconnectedCategory {
            dispatchStoreWithConnection(true)
            /**
             Happens as part of our regular operation. This event happens when
             radio / connectivity is lost, then regained.
             */
        }
        else if status.category == .PNDecryptionErrorCategory {
            
            /**
             Handle messsage decryption error. Probably client configured to
             encrypt messages and on live data feed it received plain text.
             */
        }
    }
}


extension PabNabManager {
    func toJSONString(message : VoteMessage) -> String? {
        let json : JSON = ["rating" : message.rating, "voteUp": message.voteUp]
        return json.string
    }
    
    func fromJSONString(jsonString : String) -> VoteMessage? {
        if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            return voteMEssageFromJSON(json)
        }
        
        return nil
    }
    
    func voteMEssageFromJSON(json : JSON)-> VoteMessage?{
        if let voteUp = json["voteUp"].bool, let rating = json["rating"].int {
            return VoteMessage(rating: rating, voteUp: voteUp)
        }
        return nil
    }
}