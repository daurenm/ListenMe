//
//  PlaylistCoordinator.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/6/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy

class PlaylistCoordinator: Coordinator, ShowsAlerts {
    
    // MARK: - Properties
    lazy var playlistController: PlaylistController = {
        let vc = PlaylistController()
        vc.errorDelegate = self
        vc.delegate = self
        return vc
    }()
    
    var smallPlayerController: SmallPlayerController?
    var playerController: PlayerController?
    
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
        if playerController == nil {
            playerController = PlayerController(track: track)
            playerController?.delegate = self
        } else if case PlayerManager.Status.newTrack = status {
            playerController!.prepareToPlayNewTrack(track)
        }
        router.present(playerController!, animated: true)
    }
}

extension PlaylistCoordinator: PlayerControllerDelegate {
    func dismiss(_ controller: UIViewController) {
        controller.dismiss(animated: true)
        
        guard controller == playerController else { return }
        
        if smallPlayerController == nil {
            smallPlayerController = SmallPlayerController()
            smallPlayerController!.delegate = self
            playlistController.add(
                smallPlayerController!,
                attributes: [
                    Bottom().to(playlistController.view.safeAreaLayoutGuide, .bottom), Height(SmallPlayerController.height),
                    Left(), Right()
                ]
            )
        }
        
        smallPlayerController!.update(with: playerController!.curTrack)
    }
}

extension PlaylistCoordinator: SmallPlayerControllerDelegate {
    func smallPlayerWasTapped() {
        router.present(playerController!, animated: true)
    }    
}







