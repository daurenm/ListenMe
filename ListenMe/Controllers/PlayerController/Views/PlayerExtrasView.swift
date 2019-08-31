//
//  PlayerAdditionalView.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/3/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy

enum PlayerRate: Float {
    case normal = 1
    case oneAnd25 = 1.25
    case oneAndHalf = 1.5
    case oneAnd75 = 1.75
    case two = 2
    
    static var all: [PlayerRate] = [.normal, oneAnd25, .oneAndHalf, oneAnd75, .two, .normal]
    
    mutating func next() {
        let index = PlayerRate.all.firstIndex(of: self)! + 1
        self = PlayerRate.all[index]
    }
}

class PlayerExtrasView: UIView {
    
    // MARK: - Constants
    static var rateViewSize: CGFloat { return 50 }
    
    // MARK: - Properties
    var curRate: PlayerRate
    
    lazy var formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 3
        nf.decimalSeparator = "."
        return nf
    }()
    
    var rateDidChange: ((PlayerRate) -> ())!
    
    // MARK: - Views
    lazy var rateLabel: Label = {
        let label = Label(font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium), textColor: .white)
        label.layer.backgroundColor = UIColor.iconTint.cgColor
        label.layer.cornerRadius = PlayerExtrasView.rateViewSize / 2
        label.textAlignment = .center
        updateRateLabel(rate: curRate, label: label)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(TapGesture { _ in
            self.curRate.next()
            self.updateRateLabel(rate: self.curRate, label: label)
            self.rateDidChange(self.curRate)
        })
        return label
    }()
    
    // MARK: - Lifecycle methods
    init(savedRate: PlayerRate?) {
        curRate = savedRate ?? .normal
        super.init(frame: .zero)
        
        addSubview(rateLabel)
        rateLabel.easy.layout(
            Bottom(), Right(),
            Size(PlayerExtrasView.rateViewSize)
        )
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension PlayerExtrasView {
    func updateRateLabel(rate: PlayerRate, label: Label) {
        let value = formatter.string(from: rate.rawValue as NSNumber)!
        let text = "\(value)x"
        label.set(text: text)
    }
}
