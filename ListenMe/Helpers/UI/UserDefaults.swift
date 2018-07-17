//
//  UserDefaults.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/10/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import Foundation

struct UserDefaultsKeys {
    static let rate = "rate"
}

extension UserDefaults {
    
    static func updateRate(_ rate: PlayerRate) {
        standard.set(rate.rawValue, forKey: UserDefaultsKeys.rate)
        standard.synchronize()
    }
    
    static func getSavedRate() -> PlayerRate? {
        guard let rawValue = standard.object(forKey: UserDefaultsKeys.rate) as? Float else { return nil }
        return PlayerRate(rawValue: rawValue)
    }
}
