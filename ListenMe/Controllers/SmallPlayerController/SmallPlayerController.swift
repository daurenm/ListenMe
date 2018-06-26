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

protocol SmallPlayerControllerDelegate: class {
    func smallPlayerWasTapped()
}

class SmallPlayerController: UIViewController {
    
    static var height: CGFloat { return 60 }
    
    // MARK: - Properties
    weak var delegate: SmallPlayerControllerDelegate?
    
    var curTrack: Track!
    
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
        return label
    }()
    
    lazy var jumpBackwardButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "player_controls_backward_jump").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .iconTint
        button.addTarget { _ in
            PlayerManager.default.jump(for: -PlayerControlsView.jumpForSeconds)
        }
        return button
    }()

    lazy var playPauseBox: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tapGesture = TapGesture { _ in
            self.playPause()
        }
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "player_controls_play").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(#imageLiteral(resourceName: "player_controls_pause").withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .iconTint
        return button
    }()
    
    func playPause() {
        playPauseButton.isSelected.flip()
        PlayerManager.default.playPause()
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
        [separatorView, progressView, coverIV, trackNameLabel, playPauseButton, jumpBackwardButton, playPauseBox].forEach {
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
            Right(10).to(playPauseButton)
        )
        playPauseButton.easy.layout(
            CenterY(),
            Size(30),
            Right(20)
        )
        playPauseBox.easy.layout(
            Bottom(), Top(),
            Right(),
            Left().to(playPauseButton, .left)
        )
        
        let tapGesture = TapGesture { _ in
            self.delegate?.smallPlayerWasTapped()
        }
        view.addGestureRecognizer(tapGesture)
    }
    
    func updateProgress(with curTime: Int) {
        let progress = Float(curTime) / Float(curTrack.durationInSeconds)
        progressView.progress = progress
    }
}

// MARK: - Public API
extension SmallPlayerController {
    func update(with track: Track) {
        curTrack = track
        trackNameLabel.set(text: track.url.fileName + "  ")
        updateProgress(with: PlayerManager.default.currentTime)
        playPauseButton.isSelected = PlayerManager.default.isPlaying
        
        PlayerManager.default.timeDidChange = { [unowned self] curTime in
            self.updateProgress(with: curTime)
        }
    }
}










