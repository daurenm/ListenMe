//
//  PlayerManager.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/17/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerManager {
    static let `default` = PlayerManager()

    // MARK: - Shared properties
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    // MARK: - Shared methods
    func play(url: URL) {
        if player?.url != url {
            player = try? AVAudioPlayer(contentsOf: url)
        }
        
        AVAudioSession.activateIfNeeded()
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    // MARK: - Properties
    private var player: AVAudioPlayer?
    
    // MARK: - Lifecycle methods
    private init() {
        
    }
}












