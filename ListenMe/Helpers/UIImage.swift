//
//  UIImage.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/2/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
    static func extractCoverImage(from url: URL) -> UIImage? {
        let playerItem = AVPlayerItem(url: url)
        let metadataList = playerItem.asset.metadata
        
        var image: UIImage? = nil
        
        for item in metadataList {
            if let itemValue = item.value, let commonKey = item.commonKey {
                if commonKey == .commonKeyTitle {
                    print("title = \(itemValue as! String)")
                } else if commonKey == .commonKeyArtist {
                    print("artist = \(itemValue as! String)")
                } else if commonKey == .commonKeyArtwork, let coverImage = UIImage(data: itemValue as! Data) {
                    image = coverImage
                }
            }
        }
        
        return image
    }
}
