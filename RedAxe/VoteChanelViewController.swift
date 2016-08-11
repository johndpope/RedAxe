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
    var red : CGFloat = 68
    var green : CGFloat = 68
    var blue : CGFloat = 68
    
    @IBOutlet weak var themeActualSegment: UISegmentedControl!
    @IBOutlet weak var topicDescriptionText: UITextView!
    
    @IBOutlet weak var ratingPicker: UIPickerView!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var blurCoverLayer: UIVisualEffectView!
    @IBOutlet weak var waitButtonCountdown: RoundedButton!
    
    var activeTopic : Topic?

    var readyForVote = false
    var connectedWithPubNub = false
    
    var timer : NSTimer?
    
    func newState(state: AppState) {
        activeTopic = state.activeTopic
        
        generateSegmentForEachTheme(activeTopic?.status, themes: activeTopic?.themes)
        userName.text = activeTopic?.author ?? ""
        topicTitle.text = activeTopic?.description ?? ""
        topicDescriptionText.text = activeTopic?.description ?? ""
        connectedWithPubNub = state.connectedWithPubNub
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingPicker.tintColor = UIColor.whiteColor()
        ratingPicker.showsSelectionIndicator = false
        ratingPicker.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        mainStore.subscribe(self)
        invalidatePicker()
        runWaitTimer()
        
        subscribeForVoteAction()
    }
    
    override func viewWillDisappear(animated: Bool) {
        mainStore.unsubscribe(self)
        invalidatePicker()
        cancelTimer()
    }
    
    
    func invalidatePicker(){
        ratingPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    @IBAction func voteUp(sender : UIButton){
        //guard readyForVote else {return}
        let rating = ratingPicker.selectedRowInComponent(0) + 1
        mainStore.dispatch(ActionIncrease(rating: rating))
    }
    
    @IBAction func voteDown(sender : UIButton){
        //guard readyForVote else {return}
        let rating = ratingPicker.selectedRowInComponent(0) + 1
        mainStore.dispatch(ActionDecrease(rating: rating))
    }
    
    private func generateSegmentForEachTheme(status : Int?,themes : [Themes]?){
        guard let themes = themes, let status = status else { return }
        guard status != themeActualSegment.selectedSegmentIndex else { return }
        
        themeActualSegment.removeAllSegments()
        
        themes.forEach({ themeActualSegment.insertSegmentWithTitle(($0.id! + 1).description, atIndex: $0.id!, animated: true)})
        
        themeActualSegment.selectedSegmentIndex = status
    }
    
    @IBAction func waitButtonClick(sender: RoundedButton) {
        guard red <= 240 else {
            navigationController?.popViewControllerAnimated(true)
            return
        }
        red += 10
        blue = (blue - 10) < 0 ? 0 : blue - 10
        green = (green - 10) < 0 ? 0 : green - 10
        
        waitButtonCountdown.backgroundColor = UIColor(red: red/255.0, green: blue/255, blue: blue/255, alpha: 1.0)
    }
    
    @objc private func updateTimeLess(){
        if let expDate = activeTopic?.expireDate {
            switch expDate {
            case expDate.timeIntervalSinceNow < 1000:
                let seconds = Int(expDate.timeIntervalSinceNow)
                waitButtonCountdown.setTitle("\(seconds)", forState: .Normal)
                break
            case expDate.timeIntervalSinceNow < -360:
                closeTopic()
                break
            case expDate.timeIntervalSinceNow < 0:
                startTopic()
                break
            default:
                waitingForStartWithTimeUpdates(expDate)
            }
        }
    }
    
    private func waitingForStartWithTimeUpdates(date : NSDate){
        let daysLess = Int(date.timeIntervalSinceNow / Constants.secondInDay)
        waitButtonCountdown.setTitle("\(daysLess)d", forState: .Normal)
    }
    
    private func startTopic(){
        readyForVote = true
        waitButtonCountdown.hidden = true
        blurCoverLayer.hidden = true
        
        subscribeForVoteAction()
    }
    
    private func closeTopic(){
        waitButtonCountdown.setTitle("X", forState: .Normal)
        readyForVote = false
        waitButtonCountdown.hidden = false
        blurCoverLayer.hidden = false
        
        PabNabManager.shared.client?.unsubscribeFromAll()
    }
    
    private func subscribeForVoteAction(){
//        guard readyForVote else { return }
//        guard !connectedWithPubNub else { return }
        guard let topicChanel = activeTopic?.channel else {return}
        
        PabNabManager.shared.client?.subscribeToChannels([topicChanel], withPresence: true)
    }
    
    private func runWaitTimer(){
        //TODO: REMOVE FOR TEST
        //timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTimeLess), userInfo: nil, repeats: true)
    }
    
    private func cancelTimer(){
        if let timer = timer {
            timer.invalidate()
        }
    }
}

extension VoteChanelViewController : UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text = (row + 1).description
        let font = UIFont.systemFontOfSize(30.0, weight: UIFontWeightRegular)
        let color = UIColor.whiteColor()
        return NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: color, NSFontAttributeName: font])
    }
}
