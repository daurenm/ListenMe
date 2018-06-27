//
//  UINavigationController+helpers.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/26/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
