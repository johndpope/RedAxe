//
//  VoteController.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/9/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import UIKit
import ScrollableGraphView
import ReSwift

class VoteGraphController: UIViewController, StoreSubscriber {
    var graphView : ScrollableGraphView!
    var data : [Double]?
    var labels : [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGraph()
    }
    
    override func viewWillAppear(animated: Bool) {
        mainStore.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        mainStore.unsubscribe(self)
    }

    
    func newState(state: AppState) {
        if let active = state.activeTopic {
            mapActiveTopicOnChart(active)
        }
    }
    
    private func mapActiveTopicOnChart(topic : Topic){
        guard var data = self.data, let labels = self.labels else {
            fillInitialData(topic)
            return
        }
        
        if let themes = topic.themes {
            themes.forEach({
                guard $0.id != nil else { return }
                guard data.count > $0.id! else {
                    fillInitialData(topic)
                    return
                }
                
                data[$0.id!] = Double($0.rating!)
            })
            graphView.dataPointSpacing = view.frame.width / CGFloat(themes.count + 1)
        }

        graphView.setData(data, withLabels: labels)
    }
    
    func fillInitialData(topic : Topic){
        var data = [Double]()
        var labels = [String]()
        if let themes = topic.themes {
            for theme in themes {
                data.append(Double(theme.rating!))
                labels.append((theme.id! + 1).description)
            }
            
            self.data = data
            self.labels = labels
            graphView.dataPointSpacing = view.frame.width / CGFloat(themes.count + 1)
        }
        
        graphView.setData(data, withLabels: labels)
    }
    
    func setupGraph(){
        var frame = self.view.frame
        frame.size.height = 364.0
        
        graphView = ScrollableGraphView(frame: frame)
        graphView.backgroundFillColor = UIColor.colorFromHex("#333333")
        
        graphView.topMargin = 64
        graphView.rangeMax = 50
        
        graphView.lineWidth = 1
        graphView.lineColor = UIColor.colorFromHex("#777777")
        graphView.lineStyle = ScrollableGraphViewLineStyle.Smooth
        
        graphView.shouldFill = true
        graphView.fillType = ScrollableGraphViewFillType.Gradient
        graphView.fillColor = UIColor.colorFromHex("#555555")
        graphView.fillGradientType = ScrollableGraphViewGradientType.Linear
        graphView.fillGradientStartColor = UIColor.colorFromHex("#555555")
        graphView.fillGradientEndColor = UIColor.colorFromHex("#444444")
        
        graphView.dataPointSpacing = view.frame.width/(5 + 1)
        graphView.dataPointSize = 2
        graphView.dataPointFillColor = UIColor.whiteColor()
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFontOfSize(8)
        graphView.referenceLineColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        graphView.referenceLineLabelColor = UIColor.whiteColor()
        graphView.dataPointLabelColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)

        graphView.animationDuration = 0.3
        graphView.shouldAnimateOnStartup = true
        self.view.addSubview(graphView)
 
    }
}