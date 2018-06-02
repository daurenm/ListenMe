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
            coverIV.image = extractPreviewImage(from: currentFileURL)
        }
    }
    
    var playerManager: PlayerManager { return PlayerManager.default }
    
    // MARK: - Views
    lazy var coverIV: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .flatBlue
        iv.contentMode = .scaleAspectFit
        iv.image = extractPreviewImage(from: currentFileURL)
        return iv
    }()
    
    func extractPreviewImage(from url: URL) -> UIImage? {
        return UIImage.extractCoverImage(from: currentFileURL)
    }
    
//    lazy var playButton: UIButton = {
//        let button = UIButton()
//        button.layer.backgroundColor = UIColor.flatGreen.cgColor
//        button.layer.cornerRadius = buttonHeight / 2
//        let title = "Play".withTextColor(.white)
//        button.setAttributedTitle(title, for: .normal)
//        button.addTarget(self, action: #selector(playTap), for: .touchUpInside)
//        return button
//    }()
//
//    lazy var pauseButton: UIButton = {
//        let button = UIButton()
//        button.layer.backgroundColor = UIColor.flatGreen.cgColor
//        button.layer.cornerRadius = buttonHeight / 2
//        let title = "Pause".withTextColor(.white)
//        button.setAttributedTitle(title, for: .normal)
//        button.addTarget(self, action: #selector(pauseTap), for: .touchUpInside)
//        return button
//    }()
    
    lazy var controlsView: PlayerControlsView = {
        let view = PlayerControlsView()
        return view
    }()
    
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
        
        setupNavigationBar()
        setupViews()
    }
    
    private func setupNavigationBar() {
//        let clearBarButtonItem = UIBarButtonItem(title: "Clear Inbox", style: .plain, target: self, action: #selector(clearInbox))
        let printFilesBarButtonItem = UIBarButtonItem(title: "Print", style: .plain, target: self, action: #selector(showFilesList))
        navigationItem.rightBarButtonItems = [printFilesBarButtonItem]
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(r: 31, g: 31, b: 31)
        
        view.addSubview(coverIV)
        view.addSubview(controlsView)
        coverIV.easy.layout(
            Top(20),
            Left(20), Right(20),
            Height(300)
        )
        controlsView.easy.layout(
            Bottom(20),
            Left(20), Right(20),
            Height(PlayerControlsView.defaultHeight)
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
    
//    @objc func clearInbox() {
//        let inboxURL = FileManager.documentsURL.appendingPathComponent("Inbox", isDirectory: true)
//        FileManager.default.changeCurrentDirectoryPath(inboxURL.path)
//        let files = FileManager.default.currentDirectoryFiles!
//        print("removing \(files)")
//        do {
//            for file in files {
//                let url = inboxURL.appendingPathComponent(file)
//                try FileManager.default.removeItem(at: url)
//            }
//        } catch {
//            print("Couldn't removeItem: \(error.localizedDescription)")
//        }
//    }
}

// MARK: - Shared methods
extension PlayerController {
    func prepareToPlayNewFile(url: URL) {
        guard currentFileURL != url else { return }
        
        playerManager.pause()
        currentFileURL = url
    }
}








