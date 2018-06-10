//
//  PlaylistCV.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/15/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PlaylistCV: ASCollectionNode {
    
    init(width: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: 60)
        layout.minimumLineSpacing = 0
        super.init(collectionViewLayout: layout)
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
