//
//  VoteMessage.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/9/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import Foundation

class VoteMessage {
    init(rating : Int, voteUp : Bool){
        self.rating = rating
        self.voteUp = voteUp
    }
    
    var rating : Int
    var voteUp : Bool
}