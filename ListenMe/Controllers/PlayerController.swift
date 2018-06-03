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
    
    // MARK: - Public API
    func prepareToPlayNewTrack(url: URL) {
        let sameTrack = playerManager.prepareToPlay(url: url)
        
        guard !sameTrack else { return }
        
        coverIV.image = UIImage.extractCoverImage(from: url)
        controlsView.prepareToPlay()
        sliderView.prepareToPlay(maximumValue: playerManager.duration)
    }

    // MARK: - Properties
    var playerManager: PlayerManager { return PlayerManager.default }
    
    // MARK: - Views
    lazy var coverIV: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .flatBlue
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var controlsView: PlayerControlsView = {
        let view = PlayerControlsView()
        view.onPlayPause = { [weak self] in
            guard let `self` = self else { return }
            self.playerManager.playPause()
        }
        playerManager.didFinishPlaying = view.prepareToPlay
        return view
    }()
    
    lazy var sliderView: PlayerSliderView = {
        let view = PlayerSliderView()
        playerManager.timeDidChange = { [unowned self] (curTime) in
            view.timeDidChange(curTime)
        }
        view.didSeek = { [unowned self] (newTime) in
            self.playerManager.seek(to: newTime)
        }
        return view
    }()
    
    // MARK: - Lifecycle methods
    init(fileURL: URL = defaultFileURL) {
        super.init(nibName: nil, bundle: nil)
        prepareToPlayNewTrack(url: fileURL)
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
        let printFilesBarButtonItem = UIBarButtonItem(title: "Print", style: .plain, target: self, action: #selector(showFilesList))
        navigationItem.rightBarButtonItems = [printFilesBarButtonItem]
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(r: 31, g: 31, b: 31)
        
        view.addSubview(coverIV)
        view.addSubview(controlsView)
        view.addSubview(sliderView)
        coverIV.easy.layout(
            Top(20),
            Left(20), Right(20),
            Height(300)
        )
        controlsView.easy.layout(
            Bottom(80),
            Left(20), Right(20),
            Height(PlayerControlsView.defaultHeight)
        )
        sliderView.easy.layout(
            Bottom(20).to(controlsView),
            Left(20), Right(20),
            Height(50)
        )
    }
}

// MARK: - Action methods
extension PlayerController {
    @objc func showFilesList() {
        FileManager.default.changeToPlaylistsDirectory()
        let files = FileManager.default.currentDirectoryFiles!
        print("\n[")
        for file in files {
            print("  \(file)")
        }
        print("]\n")
    }
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



