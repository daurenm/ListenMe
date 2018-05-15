//
//  RootViewController.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/12/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy
import ChameleonFramework

class RootViewController: UIViewController {

    // MARK: - Views
    lazy var playlistCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.flatGrayDark
        return cv
    }()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(playlistCV)
        playlistCV.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(), Right(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
    }

}

