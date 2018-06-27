//
//  URL+helpers.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/7/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import Foundation

extension URL {
    var fileName: String {
        return deletingPathExtension().lastPathComponent
    }
}
