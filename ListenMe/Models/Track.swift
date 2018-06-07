//
//  Track.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/6/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import AVFoundation
import Foundation

struct Track {
    var url: URL
    var durationInSeconds: Int
}

extension Track {
    init(url: URL) {
        let asset = AVURLAsset(url: url)
        let duration = asset.duration
        let durationInSeconds = Int(CMTimeGetSeconds(duration))
        
        self.url = url
        self.durationInSeconds = durationInSeconds
    }
}
