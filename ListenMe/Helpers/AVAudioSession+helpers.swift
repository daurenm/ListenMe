//
//  AVAudioSession+helpers.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/17/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import AVFoundation

extension AVAudioSession {
    
    static var isActive: Bool = false
    
    static func activateIfNeeded() {
        guard !isActive else { return }
        
        isActive = true
        let session = sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch {
            assert(false, error.localizedDescription)
        }
    }
    
    static func deactivateIfNeeded() {
        guard !PlayerManager.default.isPlaying && isActive else { return }
        
        let session = sharedInstance()
        do {
            try session.setActive(false)
        } catch {
            assert(false, error.localizedDescription)
        }
    }
}
