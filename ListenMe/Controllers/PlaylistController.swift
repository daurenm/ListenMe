//
//  PlaylistController.swift
//  ListenMe
//
//  Created by Dauren Muratov on 5/12/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy
import ChameleonFramework

class PlaylistController: UIViewController {

    // MARK: - Views
    lazy var playlistCV: PlaylistCV = {
        let cv = PlaylistCV(width: view.frame.width)
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationBar()
        setupViews()
    }
    
    private func setupNavigationBar() {
        title = "Playlist"
    }
    
    private func setupViews() {
        view.addSubview(playlistCV)
        playlistCV.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(), Right(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
    }
}

extension PlaylistController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as PlaylistCell
        return cell
    }
}
















