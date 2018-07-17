//
//  Int+helpers.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/7/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import Foundation

extension Int {
    var asTrackDurationFormat: String {
        let minutes = self / 60
        let seconds = abs(self) % 60
        return String.init(format: "%02d:%02d", minutes, seconds)
    }
}
