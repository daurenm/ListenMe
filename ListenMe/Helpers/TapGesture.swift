//
//  TapGesture.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/3/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

class TapGesture: UITapGestureRecognizer {
    
    struct AssociatedKeys {
        static var onTap: UInt8 = 0
    }
    
    init(onTap: @escaping (UITapGestureRecognizer) -> ()) {
        let closureWrapper = ClosureWrapper<UITapGestureRecognizer>(onTap)
        super.init(target: closureWrapper, action: closureWrapper.selector)
        objc_setAssociatedObject(self, &AssociatedKeys.onTap, closureWrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
