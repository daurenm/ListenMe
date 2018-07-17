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
import AsyncDisplayKit

protocol PlaylistControllerDelegate: class {
    func didSelect(_ track: Track)
}

protocol ErrorDelegate: class {
    func didEncounterError(errorText: String)
}

class PlaylistController: UIViewController {

    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var tracks: [Track] = [] {
        didSet {
            playlistCV.reloadSections(IndexSet(integer: 0))
        }
    }
    
    weak var errorDelegate: ErrorDelegate?
    weak var delegate: PlaylistControllerDelegate?
    
    // MARK: - Views
    lazy var playlistCV: PlaylistCV = {
        let cv = PlaylistCV(width: view.frame.width)
        cv.dataSource = self
        cv.delegate = self
        cv.view.refreshControl = refresher
        cv.backgroundColor = UIColor.background
        return cv
    }()
    
    lazy var refresher: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshTracks), for: .valueChanged)
        return rc
    }()
        
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationBar()
        setupViews()
        loadTracks()
    }
    
    // MARK: - Public API
    func updatePlaylist() {
        loadTracks()
    }
    
    func bottomBarWasAdded(with height: CGFloat) {
        playlistCV.view.easy.layout(Bottom(height).to(view.safeAreaLayoutGuide, .bottom))
    }
}

// MARK: - Private methods
private extension PlaylistController {
    func setupNavigationBar() {
        title = "Playlist"
    }
    
    func setupViews() {
        view.addSubview(playlistCV.view)
        playlistCV.view.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(), Right(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )        
    }
    
    func loadTracks() {
        let response = FilesManager.default.getListOfFilesWithDuration()
        switch response {
        case .error(let errorText):
            errorDelegate?.didEncounterError(errorText: errorText)
        case .success(let tracks):
            self.tracks = tracks
        }
    }
}

// MARK: - Action methods
extension PlaylistController {
    @objc func refreshTracks() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadTracks()
            self.refresher.endRefreshing()
        }
    }
}

extension PlaylistController: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let track = tracks[indexPath.item]
        let cellNodeBlock = { () -> ASCellNode in
            let cell = PlaylistCellNode(track: track)
            return cell
        }
        return cellNodeBlock
    }
}

extension PlaylistController: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let track = tracks[indexPath.item]
        delegate?.didSelect(track)
    }
}















