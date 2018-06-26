//
//  PlayerControlsView.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/2/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy

class PlayerControlsView: UIView {
    
    // MARK: - Constants
    static var defaultHeight: CGFloat { return 80 }
    typealias ButtonClosure = () -> ()
    static let jumpForSeconds = 30

    // MARK: - Public API
    func prepareToPlay() {
        playPauseButton.isSelected = false
    }
    
    func play() {
        playPauseAction(playPauseButton)
    }
    
    func updatePlayingStatus() {
        playPauseButton.isSelected = PlayerManager.default.isPlaying
    }
    
    // MARK: - Properties
    var onPlayPause: ButtonClosure!
    var onBackwardJump: ButtonClosure!
    var onForwardJump: ButtonClosure!
    var onPrevTrack: ButtonClosure?
    var onNextTrack: ButtonClosure?
    
    // MARK: - Views
    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.setImage(#imageLiteral(resourceName: "player_controls_play").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(#imageLiteral(resourceName: "player_controls_pause").withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .iconTint
        button.addTarget(closure: playPauseAction)
        return button
    }()
    
    func playPauseAction(_ button: UIButton) {
        button.isSelected.flip()
        onPlayPause()
    }
    
    lazy var backwardJumpButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "player_controls_backward_jump").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .iconTint
        button.addTarget { _ in self.onBackwardJump() }
        return button
    }()
    
    lazy var forwardJumpButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "player_controls_forward_jump").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .iconTint
        button.addTarget { _ in self.onForwardJump() }
        return button
    }()
    
    lazy var prevTrackButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "player_controls_prev_track").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .iconTint
        button.addTarget { _ in self.onPrevTrack?() }
        return button
    }()
    
    lazy var nextTrackButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "player_controls_next_track").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .iconTint
        button.addTarget { _ in self.onNextTrack?() }
        return button
    }()
    
    // MARK: - Lifecycle methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [playPauseButton, backwardJumpButton, forwardJumpButton, prevTrackButton, nextTrackButton].forEach { addSubview($0) }

        playPauseButton.easy.layout(
            Center(),
            Size(80)
        )
        backwardJumpButton.easy.layout(
            CenterY(),
            Right(30).to(playPauseButton),
            Size(30)
        )
        forwardJumpButton.easy.layout(
            CenterY(),
            Left(30).to(playPauseButton),
            Size(30)
        )
        prevTrackButton.easy.layout(
            CenterY(),
            Right(30).to(backwardJumpButton),
            Size(30)
        )
        nextTrackButton.easy.layout(
            CenterY(),
            Left(30).to(forwardJumpButton),
            Size(30)
        )
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}



