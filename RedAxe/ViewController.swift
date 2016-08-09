//
//  ViewController.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/4/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import UIKit
import ReSwift

class ViewController: UIViewController, StoreSubscriber {
    override func viewWillAppear(animated: Bool) {
        mainStore.subscribe(self)
        updateBackroundColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        mainStore.unsubscribe(self)
    }
    
    func newState(state: AppState) {
    }
    
    func updateBackroundColor(){
        UIView.animateWithDuration(1.0) {
            self.view.backgroundColor = UIColor.whiteColor()
        }
    }
}



