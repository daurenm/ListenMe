//
//  UIButton.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/2/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

typealias UIButtonTargetClosure = (UIButton) -> ()

extension UIButton {
    
    struct AssociatedKeys {
        static var addTarget: UInt8 = 0
    }
    
    func addTarget(for controlEvents: UIControlEvents = .touchUpInside, closure: @escaping (UIButton) -> ()) {
        let closureWrapper = ClosureWrapper<UIButton>(closure)
        objc_setAssociatedObject(self, &AssociatedKeys.addTarget, closureWrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(closureWrapper, action: closureWrapper.selector, for: controlEvents)
    }
}
