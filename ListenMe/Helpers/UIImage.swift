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
    static func extractPreviewImage(from url: URL) -> UIImage? {
        let playerItem = AVPlayerItem(url: url)
        let metadataList = playerItem.asset.metadata
        
        var image: UIImage? = nil
        
        for item in metadataList {
            if let itemValue = item.value {
                print(item.commonKey ?? "nil")
                if item.commonKey == .commonKeyTitle {
                    print("title = \(itemValue as! String)")
                } else if item.commonKey == .commonKeyArtist {
                    print("artist = \(itemValue as! String)")
                } else if item.commonKey == .commonKeyArtwork, let audioImage = UIImage(data: itemValue as! Data) {
                    image = audioImage
                }
            }
        }
        
        return image
    }
}
