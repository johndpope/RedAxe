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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frame = self.view.frame
        frame.size.height = 250.0
        
        graphView = ScrollableGraphView(frame: frame)
        let data = [4.0, 8.0, 15.0, 16.0, 23.0, 42.0]
        let labels = ["one", "two", "three", "four", "five", "six"]
        
        graphView.backgroundFillColor = UIColor.colorFromHex("#333333")
        
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
        
        graphView.dataPointSpacing = 80
        graphView.dataPointSize = 2
        graphView.dataPointFillColor = UIColor.whiteColor()
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFontOfSize(8)
        graphView.referenceLineColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        graphView.referenceLineLabelColor = UIColor.whiteColor()
        graphView.dataPointLabelColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        graphView.setData(data, withLabels: labels)
        graphView.shouldAnimateOnStartup = true
        self.view.addSubview(graphView)
    }
    
    func newState(state: AppState) {}
}