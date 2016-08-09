//
//  TopicListViewController.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/9/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import UIKit

class TopicListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CloudKitManager().fetchTopicList({ (topic) in
            print("Topic didload \(topic.description)")
        })
    }
}
