//
//  UIViewController+helpers.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/11/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy

extension UIViewController {
    func add(_ child: UIViewController, attributes: [Attribute]? = nil) {
        addChildViewController(child)
        view.addSubview(child.view)
        if let attributes = attributes {
            child.view.easy.layout(attributes)
        }
        child.didMove(toParentViewController: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
