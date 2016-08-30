//
//  GifViewController.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/30/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import UIKit
import Gifu

class GifViewController: UIViewController {
    @IBOutlet weak var imageView : AnimatableImageView!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        imageView.animateWithImage(named: "timetravel.gif")
    }
    
    override func viewWillAppear(animated: Bool) {
        if !imageView.isAnimatingGIF {
            imageView.startAnimatingGIF()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        if imageView.isAnimatingGIF {
            imageView.stopAnimatingGIF()
        }
    }
}
