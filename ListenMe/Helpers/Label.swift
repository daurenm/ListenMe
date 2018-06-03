//
//  Label.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/3/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

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

