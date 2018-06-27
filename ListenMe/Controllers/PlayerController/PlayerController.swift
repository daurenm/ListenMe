//
//  PlayerController.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/15/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy
import AVFoundation
import SwiftyAttributes
import MarqueeLabel
import Hero

protocol PlayerControllerDelegate: class {
    func dismiss(_ controller: UIViewController)
}

class PlayerController: UIViewController {
    
    // MARK: - Constants
    var buttonHeight: CGFloat { return 44 }

    static var defaultFileURL: URL {
        return Bundle.main.url(forResource: "this is water", withExtension: ".mp3")!
    }
    
    static var sampleWithImage: URL {
        return Bundle.main.url(forResource: "sampleWithImage", withExtension: ".mp3")!
    }
    
    // MARK: - Public API
    func prepareToPlayNewTrack(_ track: Track) {
        curTrack = track
        
        if let image = UIImage.extractCoverImage(from: track.url) {
            coverIV.image = image
            defaultCoverView.isHidden = true
        } else {
            coverIV.image = nil
            defaultCoverView.isHidden = false
        }
        
        let trackNameText = track.url.fileName + "  "
        trackNameLabel.set(text: trackNameText)
        controlsView.prepareToPlay()
        sliderView.prepareToPlay(maximumValue: track.durationInSeconds)

        shouldAutoStart = true
    }

    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    weak var delegate: PlayerControllerDelegate?
    
    var playerManager: PlayerManager { return PlayerManager.default }
    var shouldAutoStart: Bool!
    
    var curTrack: Track!
    
    var hideButtonSize: CGFloat {
        return 40
    }
    
    // MARK: - Views
    lazy var defaultCoverView: UIView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "player_default_cover").withRenderingMode(.alwaysTemplate))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor.background
        
        let view = UIView()
        view.addSubview(iv)
        iv.easy.layout(Center(), Size(75))
        view.layer.backgroundColor = UIColor.iconTint.cgColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var coverIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var trackNameLabel: MarqueeLabel = {
        let label = MarqueeLabel(font: UIFont.systemFont(ofSize: 20, weight: .bold), textColor: .iconTint)
        label.textAlignment = .center
        label.animationDelay = 1
        return label
    }()
    
    lazy var sliderView: PlayerSliderView = {
        let view = PlayerSliderView()
        view.didSeek = { [unowned self] (newTime) in
            self.playerManager.seek(to: newTime)
        }
        return view
    }()
    
    lazy var controlsView: PlayerControlsView = {
        let view = PlayerControlsView()
        view.onPlayPause = { [weak self] in
            self?.playerManager.playPause()
        }
        view.onBackwardJump = { [weak self] in
            self?.playerManager.jump(for: -PlayerControlsView.jumpForSeconds)
        }
        view.onForwardJump = { [weak self] in
            self?.playerManager.jump(for: PlayerControlsView.jumpForSeconds)
        }
        playerManager.didFinishPlaying = view.prepareToPlay
        return view
    }()
    
    lazy var extrasView: PlayerExtrasView = {
        let view = PlayerExtrasView(savedRate: UserDefaults.getSavedRate())
        view.rateDidChange = { [weak self] (rate) in
            self?.playerManager.changeRate(rate)
            UserDefaults.updateRate(rate)
        }
        return view
    }()
    
    lazy var hideButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "player_controls_collapse").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = hideButtonSize / 2
        button.layer.backgroundColor = UIColor.iconTint.cgColor
        button.addTarget(self, action: #selector(didSwipeDown), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle methods
    init(track: Track) {
        super.init(nibName: nil, bundle: nil)
        
        title = "Playing"
        prepareToPlayNewTrack(track)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        controlsView.updatePlayingStatus()

        playerManager.timeDidChange = { [unowned self] (curTime) in
            self.sliderView.timeDidChange(curTime)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldAutoStart {
            controlsView.play()
            shouldAutoStart = false
        }
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.background
        view.addSubview(hideButton)
        view.addSubview(coverIV)
        view.addSubview(defaultCoverView)
        view.addSubview(trackNameLabel)
        view.addSubview(sliderView)
        view.addSubview(controlsView)
        view.addSubview(extrasView)
        hideButton.easy.layout(
            Top(30),
            Left(20),
            Size(hideButtonSize)
        )
        coverIV.easy.layout(
            Top(20).to(hideButton),
            Left(20), Right(20),
            Bottom(20).to(trackNameLabel)
        )
        defaultCoverView.easy.layout(
            Top().to(coverIV, .top),
            Left(20), Right(20),
            Bottom().to(coverIV, .bottom)
        )
        trackNameLabel.easy.layout(
            Bottom(20).to(sliderView),
            Left(20), Right(20)
        )
        sliderView.easy.layout(
            Bottom(20).to(controlsView),
            Left(20), Right(20),
            Height(50)
        )
        controlsView.easy.layout(
            Bottom(20).to(extrasView),
            Left(20), Right(20),
            Height(PlayerControlsView.defaultHeight)
        )
        extrasView.easy.layout(
            Bottom(20),
            Left(20), Right(20),
            Height(60)
        )
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        view.isUserInteractionEnabled = true
    }
    
    @objc func didSwipeDown() {
        delegate?.dismiss(self)
    }
}











