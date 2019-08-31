//
//  UIView.swift
//  ListenMe
//
//  Created by Dauren Muratov on 7/17/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

extension UIView {
    func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
