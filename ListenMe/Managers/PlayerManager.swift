//
//  PlayerManager.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/17/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerManager: NSObject {
    static let `default` = PlayerManager()

    typealias IsPlayingAlready = Bool

    // MARK: - Shared properties
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    // MARK: - Public API
    func prepareToPlay(url: URL) -> IsPlayingAlready {
        pause()
        guard player?.url != url else { return true }

        player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        duration = Int(player?.duration ?? 0)
        return false
    }
    
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        AVAudioSession.activateIfNeeded()
        player?.play()

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] (_) in
            let currentTime = Int(self?.player?.currentTime.rounded() ?? 0)
            self?.timeDidChange?(currentTime)
        })
    }
    
    func pause() {
        player?.pause()
        timer?.invalidate()
    }
    
    func seek(to time: Int) {
        player?.currentTime = TimeInterval(time)
    }
    
    var duration: Int!

    // MARK: - Properties
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    var timeDidChange: ((Int) -> ())?
    var didFinishPlaying: (() -> ())?
    
    // MARK: - Lifecycle methods
    private override init() {
        
    }
}

extension PlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didFinishPlaying?()
    }
}










