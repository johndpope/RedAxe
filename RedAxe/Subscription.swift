//
//  Subscription.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/4/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import Foundation

struct Subscription<State> {
    private(set) weak var subscriber: AnyStoreSubscriber? = nil
    let selector: ((State) -> Any)?
}