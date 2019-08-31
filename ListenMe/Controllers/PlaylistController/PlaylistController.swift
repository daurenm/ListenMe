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
    func askingToRemove(_ track: Track)
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
    
    var sortByDate: Bool = true {
        didSet {
            tracks = sort(tracks)
        }
    }
    
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
        
        let sortButton = UIButton()
        sortButton.setImage(#imageLiteral(resourceName: "playlist_sort_date").withRenderingMode(.alwaysTemplate), for: .normal)
        sortButton.setImage(#imageLiteral(resourceName: "playlist_sort_a_z").withRenderingMode(.alwaysTemplate), for: .selected)
        sortButton.tintColor = .white
        sortButton.addTarget(closure: sortPlaylist)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
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
            self.tracks = sort(tracks)
        }
    }
    
    func sort(_ tracks: [Track]) -> [Track] {
        return sortByDate ? sortByDates(tracks) : sortFromAtoZ(tracks)
    }
    
    func sortByDates(_ tracks: [Track]) -> [Track] {
        return tracks.sorted(by: { (a, b) -> Bool in
            return a.addedDate > b.addedDate
        })
    }
    
    func sortFromAtoZ(_ tracks: [Track]) -> [Track] {
        return tracks.sorted(by: { (a, b) -> Bool in
            return a.url.fileName < b.url.fileName
        })
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
    
    @objc func sortPlaylist(_ button: UIButton) {
        button.isSelected.flip()
        sortByDate = button.isSelected
    }
}

extension PlaylistController: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let track = tracks[indexPath.item]
        let cellNodeBlock = { [weak self] () -> ASCellNode in
            let cell = PlaylistCellNode(track: track)
            cell.delegate = self
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

extension PlaylistController: PlaylistCellNodeDelegate {
    func remove(_ track: Track) {
        delegate?.askingToRemove(track)
    }
}














