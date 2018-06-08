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
    
    lazy var playlistController = PlaylistController()
    
    // MARK: - Lifecycle methods
    init(rootViewController: UINavigationController) {
        navigationController = rootViewController
    }
    
    // MARK: - Public API
    override func start() {
        navigationController.setViewControllers([playlistController], animated: false)
    }
    
    func showError(with errorText: String) {
        presentAlert(in: navigationController, alert: Alert.error(errorText))
    }
    
    func startTrack(_ track: Track) {
        playlistController.updatePlaylist()
        let playerController = PlayerController(track: track)
        navigationController.pushViewController(playerController, animated: true)
    }
}

// MARK: - Private API
extension PlaylistCoordinator {
    
}
