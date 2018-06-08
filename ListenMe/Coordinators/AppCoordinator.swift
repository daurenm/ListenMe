//
//  AppCoordinator.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/4/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    let window: UIWindow
    let navigationController: UINavigationController = {
        let navController = UINavigationController()
        navController.navigationBar.isTranslucent = false
        return navController
    }()
    
    lazy var playlistCoordinator: PlaylistCoordinator = {
        let coordinator = PlaylistCoordinator(rootViewController: navigationController)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        return coordinator
    }()
    
    // MARK: - Lifecycle methods
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
    }

    // MARK: - Public API
    override func start() {
        runPlaylistFlow()
    }
    
    func openNewTrack(with url: URL) {
        guard let track = saveNewTrack(url) else { return }
        playlistCoordinator.startTrack(track)
    }
}

// MARK: - Flows
private extension AppCoordinator {
    func runPlaylistFlow() {
        playlistCoordinator.start()
    }
}

// MARK: - Private API
extension AppCoordinator {
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


















