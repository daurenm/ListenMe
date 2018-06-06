//
//  PlaylistCoordinator.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/6/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

protocol PlaylistCoordinatorOutput: class {
    var finishFlow: (() -> ())? { get set }
}

class PlaylistCoordinator: BaseCoordinator, PlaylistCoordinatorOutput {
    
    // MARK: - Properties
    var finishFlow: (() -> ())?

    let navigationController: UINavigationController
    
    // MARK: - Lifecycle methods
    init(rootViewController: UINavigationController) {
        navigationController = rootViewController
    }
    
    override func start() {
        let playlistController = PlaylistController()
        navigationController.setViewControllers([playlistController], animated: false)
    }
}
