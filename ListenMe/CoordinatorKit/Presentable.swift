//
//  Presentable.swift
//  Testing
//
//  Created by Dauren Muratov on 6/10/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController {
        return self
    }
}
