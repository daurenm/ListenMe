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

    enum Status {
        case isPlayingAlready
        case newTrack
        case error(errorText: String)
    }

    // MARK: - Shared properties
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    // MARK: - Public API
    func prepareToPlay(url: URL) -> Status {
        pause()
        guard player?.url != url else { return .isPlayingAlready }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.enableRate = true
            player?.delegate = self
            duration = Int(player?.duration ?? 0)
        } catch {
            print("Couldn't create player.", error.localizedDescription)
            return .error(errorText: error.localizedDescription)
        }
        
        return .newTrack
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
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [unowned self] (_) in
            self.timeDidChange?(self.currentTime)
        })
    }
    
    func pause() {
        player?.pause()
        timer?.invalidate()
    }
    
    func seek(to time: Int) {
        player?.currentTime = TimeInterval(time)
    }
    
    func jump(for kseconds: Int) {
        let savedVolume = player!.volume
        player?.volume = 0
        var newTime = player!.currentTime + TimeInterval(kseconds)
        newTime = max(newTime, 0)
        newTime = min(newTime, player!.duration)
        seek(to: Int(newTime))
        timeDidChange?(currentTime)
        player?.volume = savedVolume
    }
    
    func changeRate(_ rate: PlayerRate) {
        let wasPlaying = isPlaying
        if isPlaying { player?.pause() }
        player?.rate = rate.rawValue
        if wasPlaying { player?.play() }
    }
    
    var duration: Int!

    // MARK: - Properties
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    var timeDidChange: ((Int) -> ())?
    var didFinishPlaying: (() -> ())?
    var currentTime: Int { return Int(player?.currentTime.rounded() ?? 0) }
    
    // MARK: - Lifecycle methods
    private override init() {
        
    }
}

extension PlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didFinishPlaying?()
    }
}










