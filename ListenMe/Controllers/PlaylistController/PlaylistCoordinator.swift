//
//  PlaylistCoordinator.swift
//  ListenMe
//
//  Created by Dauren Muratov on 6/6/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy
import MediaPlayer

class PlaylistCoordinator: Coordinator, ShowsAlerts {
    
    // MARK: - Properties
    lazy var playlistController: PlaylistController = {
        let vc = PlaylistController()
        vc.errorDelegate = self
        vc.delegate = self
        return vc
    }()
    
    var smallPlayerController: SmallPlayerController? {
        didSet {
            presentInteractiveAnimator.view = smallPlayerController?.view
        }
    }
    
    var playerController: PlayerController? {
        didSet {
            guard let playerController = playerController else { return }
            
            presentInteractiveAnimator.onBegin = { [weak self] in
                guard let `self` = self else { return }
                self.router.present(playerController, animated: true)
            }
            dismissInteractiveAnimator.view = playerController.view
            dismissInteractiveAnimator.onBegin = { 
                playerController.dismiss(animated: true)
            }
        }
    }

    let animator = PlayerAnimator()
    let presentInteractiveAnimator = PlayerInteractiveAnimator(isPresenting: true)
    let dismissInteractiveAnimator = PlayerInteractiveAnimator(isPresenting: false)

    // MARK: - Lifecycle methods
    override init(router: RouterType = Router()) {
        super.init(router: router)
        
        setupNowPlayingInfoCenter()
    }
    
    private func setupNowPlayingInfoCenter() {
        let rcc = MPRemoteCommandCenter.shared()
        rcc.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            PlayerManager.default.controlsPlayPause()
            self.updateNowPlayingInfoCenter(isPlaying: true)
            return .success
        }
        rcc.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            PlayerManager.default.controlsPlayPause()
            self.updateNowPlayingInfoCenter(isPlaying: false)
            return .success
        }
    }
    
    func updateNowPlayingInfoCenter(isPlaying: Bool = PlayerManager.default.isPlaying) {
        guard let smallPlayerController = smallPlayerController, let track = smallPlayerController.curTrack else {
            print(#function, "no track")
            return
        }
        
        print(PlayerManager.default.currentTime, PlayerManager.default.currentTime, isPlaying)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: track.url.fileName,
            MPMediaItemPropertyPlaybackDuration: track.durationInSeconds,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: PlayerManager.default.currentTime,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? UserDefaults.getSavedRate()?.rawValue ?? 1 : 0
        ]
    }
    
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
        
        if smallPlayerController == nil {
            smallPlayerController = SmallPlayerController()
            smallPlayerController!.delegate = self
            let height = SmallPlayerController.height
            playlistController.add(
                smallPlayerController!,
                attributes: [
                    Bottom().to(playlistController.view.safeAreaLayoutGuide, .bottom), Height(height),
                    Left(), Right()
                ]
            )
            playlistController.bottomBarWasAdded(with: height)
        }
        smallPlayerController!.update(with: track)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.playerController == nil {
                self.playerController = PlayerController(track: track)
                self.playerController!.delegate = self
                self.playerController!.transitioningDelegate = self
                self.router.present(self.playerController!, animated: true)
            } else if case PlayerManager.Status.newTrack = status {
                self.playerController!.prepareToPlayNewTrack(track)
                self.smallPlayerController!.playPause()
            }
        }
    }
}

extension PlaylistCoordinator: PlayerControllerDelegate {
    func wasDismissed(_ controller: UIViewController) {
//        controller.dismiss(animated: true)
        
        guard controller == playerController else { return }
        smallPlayerController!.update(with: playerController!.curTrack)
    }
    
    func askingToRemove(_ track: Track) {
        let vc = UIAlertController(title: "Remove track?", message: "", preferredStyle: .actionSheet)
        vc.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] (action) in
            FilesManager.default.remove(track)
            self?.playlistController.updatePlaylist()
        }))
        vc.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        router.present(vc, animated: true)
    }
}

extension PlaylistCoordinator: SmallPlayerControllerDelegate {
    func smallPlayerWasTapped() {
        router.present(playerController!, animated: true)
    }    
}

extension PlaylistCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let smallPlayerView = smallPlayerController?.smallPlayerView else { return nil }
        animator.smallPlayerView = UIImageView(image: smallPlayerView.takeScreenshot())
        animator.isPresenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = false
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentInteractiveAnimator.inProgress ? presentInteractiveAnimator : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissInteractiveAnimator.inProgress ? dismissInteractiveAnimator : nil
    }
}









