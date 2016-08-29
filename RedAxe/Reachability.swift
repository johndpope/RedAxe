//
//  Reachability.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/29/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import ReachabilitySwift

class ReachabilityManager {
    private init(){}
    static let shared = ReachabilityManager()
    //declare this property where it won't go out of scope relative to your listener
    var reachability: Reachability?
    
    func startNotification(){
        //declare this inside of viewWillAppear
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
                mainStore.dispatch(ActionReachability(succes: true))
            } else {
                print("Reachable via Cellular")
                mainStore.dispatch(ActionReachability(succes: true))
            }
        } else {
            print("Network not reachable")
            mainStore.dispatch(ActionReachability(succes: false))
        }
    }
    
    func stopNotification(){
        if let r = reachability {
            r.stopNotifier()
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
        }
    }
}