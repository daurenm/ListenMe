//
//  AppCoordinator.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/4/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    lazy var playlistCoordinator = PlaylistCoordinator(router: router)
    
    // MARK: - Public methods
    override func start() {
        runPlaylistFlow()
    }
    
    func openNewTrack(with url: URL) {
        guard let track = saveNewTrack(url) else { return }
        playlistCoordinator.startTrack(track)
    }
    
    func updateNowPlayingInfoCenter() {
        playlistCoordinator.updateNowPlayingInfoCenter()
    }
}

// MARK: - Flows
private extension AppCoordinator {
    func runPlaylistFlow() {
        addChildCoordinator(playlistCoordinator)
        router.push(playlistCoordinator, animated: false) { [weak self, weak playlistCoordinator] in
            self?.removeChildCoordinator(playlistCoordinator)
        }
    }
}

// MARK: - Private API
private extension AppCoordinator {
    func saveNewTrack(_ url: URL) -> Track? {
        let response = FilesManager.default.tryToSaveFile(given: url)
        switch response {
        case .error(let errorText):
            playlistCoordinator.showError(with: errorText)
            return nil
        case .success(let url):
            return Track(url: url)
        }
    }
}


















