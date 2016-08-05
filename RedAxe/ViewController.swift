//
//  ViewController.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/4/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import UIKit
import ReSwift

class ViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewWillAppear(animated: Bool) {
        mainStore.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        mainStore.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        counterLabel.text = "\(state.counter)"
        setUserEditable(state.isEditableField)
        userNameInput.text = state.mainUserName
        
        state.loading ? loading.startAnimating() : loading.stopAnimating()
        
        setupImage(state.image)
    }
    
    @IBAction func increaseButtonTapped(sender: UIButton) {
        mainStore.dispatch(
            FirstScreenActionIncrease()
        )
    }
    
    @IBAction func decreaseButtonTapped(sender: UIButton) {
        mainStore.dispatch(
            FirstScreenActionDecrease()
        )
    }
    
    @IBAction func editUserNameAction(sender: UIButton) {
        mainStore.dispatch(
            FirstScreenActionEditUser(userName : userNameInput.text ?? "")
        )
    }
    @IBAction func startLoadingAction(sender: UIButton) {
        loadImage()
    }
    
    func startLoading(){
        mainStore.dispatch(
            FirstScreenActionDidStatrtUpload()
        )
    }
    
    func stopLoading(){
        mainStore.dispatch(
            FirstScreenActionDidEndUpload()
        )
    }
    
    func loadImage(){
        startLoading()
        
        mainStore.dispatch { (state, store, actionCreatorCallback) in
            
            Network().loadImageWithCallBack({ (image) in
                actionCreatorCallback({ (state, store) -> Action? in
                    self.stopLoading()
                    return FirstScreenActionImage(image : image)
                })
            })
        }
    }
    
    func setUserEditable(editable : Bool){
        var editTiitle = "Edit"
        
        if editable {
            editTiitle = "Done"
        }
        
        userNameInput.endEditing(editable)
        userNameInput.userInteractionEnabled = editable
        editButton.setTitle(editTiitle, forState: .Normal)
    }
    
    func setupImage(image : UIImage?){
        guard let img = image else { return }
        self.image.image = img
    }
}



