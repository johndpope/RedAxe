//
//  Disposable.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/4/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import Foundation

public protocol Disposable {
    
    var disposed: Bool { get }
    
    var dispose: () -> () { get }
}

public struct SimpleReduxDisposable: Disposable {
    
    let disposedCallback: () -> Bool
    
    public var disposed: Bool { return disposedCallback() }
    
    public let dispose: () -> ()
    
    public init(disposed: () -> Bool, dispose: () -> ()) {
        disposedCallback = disposed
        self.dispose = dispose
    }
}