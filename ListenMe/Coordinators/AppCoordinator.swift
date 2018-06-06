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
    
    // MARK: - Lifecycle methods
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
    }
    
    override func start() {
        runPlaylistFlow()
    }
}

// MARK: - Flows
extension AppCoordinator {
    func runPlaylistFlow() {
        let playlistCoordinator = PlaylistCoordinator(rootViewController: navigationController)
        playlistCoordinator.finishFlow = { [weak self, weak playlistCoordinator] in
            self?.removeDependency(playlistCoordinator)
        }
        addDependency(playlistCoordinator)
        playlistCoordinator.start()
    }
}



















