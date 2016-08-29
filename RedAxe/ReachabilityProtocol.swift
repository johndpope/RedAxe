//
//  ReachabilityProtocol.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/29/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import UIKit

protocol ReachabilityProtocol {
    func updateConnectionStatus(withSicess success : Bool)
}

extension ReachabilityProtocol where Self : UIViewController {
    func updateConnectionStatus(withSicess success : Bool){
        if let nav = self.navigationController {
            nav.navigationBar.backgroundColor = success ? UIColor.clearColor() : UIColor.redColor()
            nav.navigationBar.tintColor = success ? UIColor.redColor() : UIColor.whiteColor()
            title = success ? "" : "No connection"
        }
    }
}