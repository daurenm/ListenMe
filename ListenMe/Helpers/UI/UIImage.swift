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
            if let itemValue = item.value, let commonKey = item.commonKey, commonKey == .commonKeyArtwork, let coverImage = UIImage(data: itemValue as! Data) {
                image = coverImage
            }
        }
        
        return image
    }

    func withTintColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
