//
//  VoteMessage.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/9/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import Foundation

class VoteMassage {
  init(rating : Int, voteUp : Bool, targetID : Int){
        self.rating = rating
        self.voteUp = voteUp
        self.targetID = targetID
    }
    var targetID : Int
    var rating : Int
    var voteUp : Bool
}