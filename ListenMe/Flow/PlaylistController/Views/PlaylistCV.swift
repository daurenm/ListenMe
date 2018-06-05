//
//  PlaylistCV.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/15/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

class PlaylistCV: UICollectionView {
    
    init(width: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: 60)
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = UIColor.flatGrayDark
        registerReusableCell(PlaylistCell.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
