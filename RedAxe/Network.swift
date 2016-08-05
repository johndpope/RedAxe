//
//  Network.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/5/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class Network : NSObject {
    let kMaxImagePizelSize = CGFloat(1200)
    
    var callback : ((UIImage)->Void)?
    let url = NSURL(string: "http://orig12.deviantart.net/ec0c/f/2012/033/b/7/nk_racing_nissan_240sx_formulad_drift_car_by_projektpm-d4odzdz.jpg")
    
    func loadImageWithCallBack(callback : (UIImage)->Void){
        self.callback = callback
        
        let backgroundSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundSessionRedAxe")
        let backgroundSession = NSURLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = backgroundSession.downloadTaskWithURL(url!)
        downloadTask.resume()
    }
    
    
}


extension Network : NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession,
                    downloadTask: NSURLSessionDownloadTask,
                    didFinishDownloadingToURL location: NSURL){
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectoryPath:String = path[0]
        
        
        
        let fileManager = NSFileManager()
        let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingString("drift.jpg"))
        
        if fileManager.fileExistsAtPath(destinationURLForFile.path!){
            self.loadImageWithPath(destinationURLForFile)
        }else{
            do {
                try fileManager.moveItemAtURL(location, toURL: destinationURLForFile)
                // show file
                self.loadImageWithPath(destinationURLForFile)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
    }
    
    @objc func URLSession(session: NSURLSession,
                          downloadTask: NSURLSessionDownloadTask,
                          didWriteData bytesWritten: Int64,
                                       totalBytesWritten: Int64,
                                       totalBytesExpectedToWrite: Int64){
        
        let percentage = Int(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite) * 100)
        print("\(percentage) %")
    }
    
    func URLSession(session: NSURLSession,task: NSURLSessionTask,didCompleteWithError error: NSError?){
        if error != nil {
            print("ERROR")
            print(error)
        }
    }
    
    private func loadImageWithPath(nsurl : NSURL){
        if let path = nsurl.path {
            let image = resizeImage(imageToResize: UIImage(contentsOfFile: path)!)
            if let cb = callback {
                cb(image)
            }
        }
    }

    
    //Lets save a little bit of memoty :)
    private func resizeImage(imageToResize image: UIImage) -> UIImage {
        //easy check
        if(image.size.width < kMaxImagePizelSize && image.size.width < kMaxImagePizelSize){
            return image
        }
        //scaling
        let scale = self.kMaxImagePizelSize / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(self.kMaxImagePizelSize, newHeight))
        image.drawInRect(CGRectMake(0, 0, self.kMaxImagePizelSize, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}