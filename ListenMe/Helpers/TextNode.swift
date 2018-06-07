//
//  TextNode.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/7/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class TextNode: ASTextNode {
    
    // MARK: - Shared methods
    func setText(_ text: String?) {
        var attributedText = text?.withFont(font).withTextColor(textColor)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        attributedText = attributedText?.withParagraphStyle(paragraphStyle)

        self.attributedText = attributedText
    }
    
    // MARK: - Properties
    let font: UIFont
    let textColor: UIColor
    let alignment: NSTextAlignment
    
    // MARK: - Lifecycle methods
    init(font: UIFont, textColor: UIColor, alignment: NSTextAlignment = .left) {
        self.font = font
        self.textColor = textColor
        self.alignment = alignment
        
        super.init()
    }
}
