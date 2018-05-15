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
    
    var player: AVAudioPlayer!
    
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
        player.play()
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
        player.pause()
    }

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparePlayer()
        setupViews()
    }
    
    private func preparePlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard player != nil else {
                assert(false, "couldn't create the player")
            }
        } catch {
            assert(false, error.localizedDescription)
        }
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










