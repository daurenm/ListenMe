//
//  ClosureWrapper.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/2/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import Foundation

class ClosureWrapper<T> {
    
    let selector: Selector
    private let closure: (T) -> ()
    
    init(_ closure: @escaping (T) -> ()) {
        self.closure = closure
        selector = #selector(invoke(_:))
    }
    
    @objc func invoke(_ sender: AnyObject) {
        closure(sender as! T)
    }
}
