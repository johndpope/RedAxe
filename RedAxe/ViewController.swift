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
    
    @IBOutlet weak var pageControl : UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "REDAXE"
    }
    
    override func viewWillAppear(animated: Bool) {
        mainStore.subscribe(self)
        updateBackroundColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        mainStore.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        pageControl.currentPage = state.pageIndex
    }
    
    func updateBackroundColor(){
        UIView.animateWithDuration(2) {
            self.view.backgroundColor = UIColor.whiteColor()
        }
    }
}



