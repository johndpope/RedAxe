//
//  TopicListViewController.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/9/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import UIKit
import ReSwift

class TopicListViewController: UITableViewController,ReachabilityProtocol, StoreSubscriber {
    var loadController : UIAlertController?
    var topic = [Topic]()
    var reachable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 65.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        mainStore.subscribe(self)
        uploadTopicList()
    }
    
    override func viewWillDisappear(animated: Bool) {
        mainStore.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        reachable = state.reachability
        updateConnectionStatus(withSicess: state.reachability)
        setupTopicList(state.availableTopics)
        presentLoadingView(state.loading)
    }
    
    func displaySignUpPendingAlert() -> UIAlertController {
        let pending = UIAlertController(title: "Loading...", message: nil, preferredStyle: .Alert)
        self.presentViewController(pending, animated: true, completion: nil)
        return pending
    }
    func uploadTopicList(){
        guard topic.count == 0 else { return }
        mainStore.dispatch { (state, store, actionCreatorCallback) in
            
            //mainStore.dispatch(ActionStatrtUploadTopic())
            
            CloudKitManager().fetchTopicList({ (topic) in
                dispatch_async(dispatch_get_main_queue(), {
                    actionCreatorCallback({ (state, store) -> Action? in
                        //TODO: Hardcoded list of topics
                        return ActionDidUploadWithTopicResult(topic: [topic])
                    })
                })
            })
        }
    }
    
    func setupTopicList(list : [Topic]){
        guard list.count > 0 else { return }
        topic = list
        tableView.reloadData()
    }
    
    func presentLoadingView(loading : Bool){
        if loading {
            loadController = displaySignUpPendingAlert()
        }else{
            if let loading = loadController {
                loading.dismissViewControllerAnimated(true, completion: nil)
            }
            loadController = nil
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if reachable {
            mainStore.dispatch(ActionSetActiveTopic(topic: topic[indexPath.row]))
            self.performSegueWithIdentifier("SegueGoVoteController", sender: nil)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let index = indexPath.row
        let topic = self.topic[index]
        let cell = tableView.dequeueReusableCellWithIdentifier("TopicCell") as! TopicCell
        cell.author.text = topic.author
        cell.descriptionLabel.text = topic.description
        
        cell.stackView.subviews.forEach({ $0.removeFromSuperview()})
        for theme in topic.themes! {
            let label = UILabel()
            label.textColor = UIColor.whiteColor()
            label.text = "  •  \(theme.description!)"
            cell.stackView.addArrangedSubview(label)
        }
        
        return cell
    }
}
