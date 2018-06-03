//
//  Label.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/3/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import MarqueeLabel

class Label: UILabel {
    
    let givenFont: UIFont
    let givenTextColor: UIColor
    
    init(font: UIFont, textColor: UIColor) {
        givenFont = font
        givenTextColor = textColor
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String?) {
        attributedText = text?.withFont(givenFont).withTextColor(givenTextColor)
    }
}

extension MarqueeLabel {
    
    struct AssociatedKeys {
        static var font: UInt8 = 0
        static var textColor: UInt8 = 0
    }
    
    var givenFont: UIFont {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.font) as! UIFont }
        set { objc_setAssociatedObject(self, &AssociatedKeys.font, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var givenTextColor: UIColor {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.textColor) as! UIColor }
        set { objc_setAssociatedObject(self, &AssociatedKeys.textColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    convenience init(font: UIFont, textColor: UIColor) {
        self.init(frame: .zero, duration: 8, fadeLength: 10)
        self.givenFont = font
        self.givenTextColor = textColor
    }
    
    func set(text: String?) {
        attributedText = text?.withFont(givenFont).withTextColor(givenTextColor)
    }
}
