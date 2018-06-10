//
//  PlaylistCoordinator.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/6/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit

class PlaylistCoordinator: Coordinator, ShowsAlerts {
    
    // MARK: - Properties
    lazy var playlistController: PlaylistController = {
        let vc = PlaylistController()
        vc.errorDelegate = self
        vc.delegate = self
        return vc
    }()
    
    // MARK: - Lifecycle methods
    override func toPresent() -> UIViewController {
        return playlistController
    }
    
    // MARK: - Public API
    func showError(with errorText: String) {
        router.presentAlert(Alert.error(errorText))
    }
    
    func startTrack(_ track: Track) {
        playlistController.updatePlaylist()
        didSelect(track)
    }
}

extension PlaylistCoordinator: ErrorDelegate {
    func didEncounterError(errorText: String) {
        showError(with: errorText)
    }
}

extension PlaylistCoordinator: PlaylistControllerDelegate {
    func didSelect(_ track: Track) {
        let status = PlayerManager.default.prepareToPlay(url: track.url)
        if case PlayerManager.Status.error(let errorText) = status {
            showError(with: errorText)
            return
        }

        router.popToRootModule(animated: true)
        let playerController = PlayerController(track: track)
        router.push(playerController, animated: true) {
            print("should deinit playerController")
        }
    }
}










