//
//  Statistic.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/9/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import Foundation

typealias StatisticResponce = (Int, Int, Int)
class Statistic {
    private var votes = [VoteMassage]()
    
    func appendVote(vote : VoteMassage)-> StatisticResponce {
        votes.append(vote)
        return calculate()
    }
    
    func insertHistory(votes : [VoteMassage]?){
        guard let history = votes else {return}
        self.votes.appendContentsOf(history)
    }
    
    private func calculate()->StatisticResponce {
        var sum = 0
        var voteLevel = 0
        
        for vote in votes {
            voteLevel += vote.voteUp ? 1 : -1
            sum += vote.rating
        }
        let rating = sum/votes.count
        let points = voteLevel >= 0 ? voteLevel : 0
        return (rating, points, votes.count)
    }
}