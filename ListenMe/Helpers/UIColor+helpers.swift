//
//  UIColor.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/2/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

extension UIColor {
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 1)
    }
    
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }    
}

extension UIColor {
    static let navigationBarBackground = UIColor(hexString: "#457B9D")!
    static let navigationBarTint = UIColor.white
    
    static let background = UIColor.white
    static let activeText = UIColor(hexString: "#457B9D")!
    static let passiveText = UIColor(hexString: "#0D171D")!
    
    static let separator = UIColor(hexString: "#1D3557")!.withAlphaComponent(0.2)
    static let iconTint = UIColor(hexString: "#457B9D")!
}
