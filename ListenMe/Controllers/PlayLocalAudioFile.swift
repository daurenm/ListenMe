//
//  PlayLocalAudioFile.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/15/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy
import AVFoundation
import SwiftyAttributes

class PlayLocalAudioFile: UIViewController {
    
    // MARK: - Constants
    var buttonHeight: CGFloat { return 44 }
    
    // MARK: - Properties
    lazy var url: URL = {
        let url = Bundle.main.url(forResource: "this is water", withExtension: ".mp3")!
        return url
    }()
    
    var playerManager: PlayerManager { return PlayerManager.default }
    
    // MARK: - Views
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.flatGreen.cgColor
        button.layer.cornerRadius = buttonHeight / 2
        let title = "Play".withTextColor(.white)
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(playTap), for: .touchUpInside)
        return button
    }()
    
    @objc func playTap() {
        playerManager.play(url: url)
    }
    
    lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.flatGreen.cgColor
        button.layer.cornerRadius = buttonHeight / 2
        let title = "Pause".withTextColor(.white)
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(pauseTap), for: .touchUpInside)
        return button
    }()
    
    @objc func pauseTap() {
        playerManager.pause()
    }

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        layoutGuide.easy.layout(Center())
        
        view.addSubview(playButton)
        view.addSubview(pauseButton)
        
        playButton.easy.layout(
            CenterY(), Right(20).to(layoutGuide),
            Height(buttonHeight), Width(100)
        )
        pauseButton.easy.layout(
            CenterY(), Left(20).to(layoutGuide),
            Height(buttonHeight), Width(100)
        )
    }
}










