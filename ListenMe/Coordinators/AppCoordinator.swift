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
    var childCoordinators: [Coordinator] = []

    let window: UIWindow
    lazy var navigationController: UINavigationController = {
        let navController = UINavigationController()
        navController.navigationBar.isTranslucent = false
        return navController
    }()
    
    // MARK: - Lifecycle methods
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
    }
    
    func start() {
//        // Here you should start PlaylistCoordinator.
//        // But for now, just start PlayerCoordinator
//        let playerCoordinator = PlayerCoordinator()
//        playerCoordinator.start()
        navigationController.setViewControllers([PlayerController()], animated: false)
    }
}
