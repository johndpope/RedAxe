//
//  ActiveChanelViewController.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/9/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import UIKit
import ReSwift

class VoteChanelViewController: UIViewController, StoreSubscriber {
    override func viewWillAppear(animated: Bool) {
        mainStore.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        mainStore.unsubscribe(self)
    }
    
    func newState(state: AppState) {}

    
    @IBAction func voteUp(sender : UIButton){
    }
    
    @IBAction func voteDown(sender : UIButton){
    }
}
