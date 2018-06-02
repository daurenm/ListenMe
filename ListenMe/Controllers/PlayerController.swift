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

class PlayerController: UIViewController {
    
    // MARK: - Constants
    var buttonHeight: CGFloat { return 44 }

    static var defaultFileURL: URL {
        return Bundle.main.url(forResource: "this is water", withExtension: ".mp3")!
    }
    
    static var sampleWithImage: URL {
        return Bundle.main.url(forResource: "sampleWithImage", withExtension: ".mp3")!
    }
    
    // MARK: - Properties
    var currentFileURL: URL {
        didSet {
            imageView.image = UIImage.extractPreviewImage(from: currentFileURL)
        }
    }
    
    var playerManager: PlayerManager { return PlayerManager.default }
    
    // MARK: - Views
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .flatBlue
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage.extractPreviewImage(from: currentFileURL)
        return iv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.flatGreen.cgColor
        button.layer.cornerRadius = buttonHeight / 2
        let title = "Play".withTextColor(.white)
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(playTap), for: .touchUpInside)
        return button
    }()
    
    lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.flatGreen.cgColor
        button.layer.cornerRadius = buttonHeight / 2
        let title = "Pause".withTextColor(.white)
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(pauseTap), for: .touchUpInside)
        return button
    }()
    
    lazy var showFilesButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle("Show Files".withTextColor(.white), for: .normal)
        button.backgroundColor = .flatOrange
        button.addTarget(self, action: #selector(showFilesList), for: .touchUpInside)
        return button
    }()
    
    lazy var clearInboxButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle("Clear Inbox".withTextColor(.white), for: .normal)
        button.backgroundColor = .flatRed
        button.addTarget(self, action: #selector(clearInbox), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle methods
    init(fileURL: URL = sampleWithImage) {
        currentFileURL = fileURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        layoutGuide.easy.layout(Center())
        
        view.addSubview(imageView)
        view.addSubview(playButton)
        view.addSubview(pauseButton)
        view.addSubview(showFilesButton)
        view.addSubview(clearInboxButton)
        
        let width = Device.SCREEN_WIDTH - 20 * 2
        imageView.easy.layout(
            Top(20),
            Left(20), Right(20),
            Height(width)
        )
        playButton.easy.layout(
            Bottom(20).to(clearInboxButton), Right(20).to(layoutGuide),
            Height(buttonHeight), Width(100)
        )
        pauseButton.easy.layout(
            Bottom().to(playButton, .bottom), Left(20).to(layoutGuide),
            Height(buttonHeight), Width(100)
        )
        showFilesButton.easy.layout(
            Bottom(), Height(44),
            Left(), Right()
        )
        clearInboxButton.easy.layout(
            Bottom().to(showFilesButton), Height(44),
            Left(), Right()
        )
    }
}

// MARK: - Action methods
extension PlayerController {
    @objc func playTap() {
        playerManager.play(url: currentFileURL)
    }

    @objc func pauseTap() {
        playerManager.pause()
    }

    @objc func showFilesList() {
        FileManager.default.changeToPlaylistsDirectory()
        let files = FileManager.default.currentDirectoryFiles!
        print("\n[")
        for file in files {
            print("  \(file)")
        }
        print("]\n")
    }
    
    @objc func clearInbox() {
        let inboxURL = FileManager.documentsURL.appendingPathComponent("Inbox", isDirectory: true)
        FileManager.default.changeCurrentDirectoryPath(inboxURL.path)
        let files = FileManager.default.currentDirectoryFiles!
        print("removing \(files)")
        do {
            for file in files {
                let url = inboxURL.appendingPathComponent(file)
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            print("Couldn't removeItem: \(error.localizedDescription)")
        }
    }
}

// MARK: - Shared methods
extension PlayerController {
    func prepareToPlayNewFile(url: URL) {
        guard currentFileURL != url else { return }
        
        playerManager.pause()
        currentFileURL = url
    }
}








