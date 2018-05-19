//
//  PlayController.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/15/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy
import AVFoundation
import SwiftyAttributes

class PlayController: UIViewController {
    
    // MARK: - Constants
    var buttonHeight: CGFloat { return 44 }

    static var defaultFileURL: URL {
        return Bundle.main.url(forResource: "this is water", withExtension: ".mp3")!
    }

    // MARK: - Shared methods
    func prepareToPlayNewFile(url: URL) {
        guard currentFileURL != url else { return }
        
        playerManager.pause()
        currentFileURL = url
    }
    
    // MARK: - Properties
    var currentFileURL: URL
    
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
        playerManager.play(url: currentFileURL)
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

    lazy var showFilesButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle("Show Files".withTextColor(.white), for: .normal)
        button.backgroundColor = .flatOrange
        button.addTarget(self, action: #selector(showFilesList), for: .touchUpInside)
        return button
    }()
    
    @objc func showFilesList() {
        FileManager.default.changeToPlaylistsDirectory()
        let files = FileManager.default.currentDirectoryFiles!
        print("\n[")
        for file in files {
            print("  \(file)")
        }
        print("]\n")
    }
    
    lazy var clearInboxButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle("Clear Inbox".withTextColor(.white), for: .normal)
        button.backgroundColor = .flatRed
        button.addTarget(self, action: #selector(clearInbox), for: .touchUpInside)
        return button
    }()
    
    @objc func clearInbox() {
//        FileManager.default.changeToDocumentsDirectory()
//        let inboxURL = FileManager.documentsURL.appendingPathComponent("Inbox", isDirectory: true)
//        FileManager.default.changeCurrentDirectoryPath(inboxURL.path)
//        let files = FileManager.default.currentDirectoryFiles!
//        do {
//            let file = files.first!
//            let url = inboxURL.appendingPathComponent(file)
//            try FileManager.default.removeItem(at: url)
//        } catch {
//            print("Couldn't removeItem: \(error.localizedDescription)")
//        }
    }
    
    // MARK: - Lifecycle methods
    init(fileURL: URL = defaultFileURL) {
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
        
        view.addSubview(playButton)
        view.addSubview(pauseButton)
        view.addSubview(showFilesButton)
        view.addSubview(clearInboxButton)
        
        playButton.easy.layout(
            CenterY(), Right(20).to(layoutGuide),
            Height(buttonHeight), Width(100)
        )
        pauseButton.easy.layout(
            CenterY(), Left(20).to(layoutGuide),
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










