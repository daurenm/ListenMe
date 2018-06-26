//
//  SmallPlayerController.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/10/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy
import Hero
import MarqueeLabel

class SmallPlayerController: UIViewController {
    
    static var height: CGFloat { return 60 }
    
    // MARK: - Properties
    
    
    // MARK: - Views
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    lazy var progressView: UIProgressView = {
        let pv = UIProgressView()
        pv.trackTintColor = .clear
        pv.progressTintColor = .iconTint
        pv.progress = 0.75
        return pv
    }()
    
    lazy var coverIV: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 6
        iv.layer.backgroundColor = UIColor.iconTint.cgColor
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var trackNameLabel: MarqueeLabel = {
        let label = MarqueeLabel(font: UIFont.systemFont(ofSize: 14, weight: .medium), textColor: .iconTint)
        label.set(text: "Top 10 rules - GaryVee")
        return label
    }()
    
    lazy var jumpBackwardButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "player_controls_backward_jump").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .iconTint
        button.addTarget { _ in self.onBackwardJump() }
        return button
    }()
    
    @objc func onBackwardJump() {
        print(#function)
    }

    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "player_controls_triangle").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .iconTint
        button.addTarget { _ in self.onPlay() }
        return button
    }()
    
    @objc func onPlay() {
        print(#function)
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

private extension SmallPlayerController {
    func setupViews() {
        view.hero.id = "player"
        view.backgroundColor = UIColor.background
        [separatorView, progressView, coverIV, trackNameLabel, playButton, jumpBackwardButton].forEach {
            view.addSubview($0)
        }
        
        separatorView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top), Height(1),
            Left(), Right()
        )
        progressView.easy.layout(
            Top().to(separatorView), Height(3),
            Left(), Right()
        )
        coverIV.easy.layout(
            CenterY(),
            Left(20),
            Size(40)
        )
        trackNameLabel.easy.layout(
            CenterY(),
            Left(20).to(coverIV), Right(20).to(jumpBackwardButton)
        )
        jumpBackwardButton.easy.layout(
            CenterY(),
            Size(30),
            Right(10).to(playButton)
        )
        playButton.easy.layout(
            CenterY(),
            Size(30),
            Right(20)
        )
    }
}












