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
    var playerController: PlayerController? {
        didSet {
            interactiveAnimator.viewController = playerController
        }
    }

    let animator = PlayerAnimator()
    let interactiveAnimator = PlayerInteractiveAnimator()

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
    func dismiss(_ controller: UIViewController) {
        controller.dismiss(animated: true)
        
        guard controller == playerController else { return }
        smallPlayerController!.update(with: playerController!.curTrack)
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
        print(#function)
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveAnimator.inProgress ? interactiveAnimator : nil
    }
}

//extension PlaylistCoordinator: UIViewControllerTransitioningDelegate {
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let animator = MiniToLargeViewAnimator()
//        animator.initialY = SmallPlayerController.height
//        animator.transitionType = .present
//        return animator
//    }
//
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let animator = MiniToLargeViewAnimator()
//        animator.initialY = SmallPlayerController.height
//        animator.transitionType = .dismiss
//        return animator
//    }
//
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return nil
////        guard !disableInteractivePlayerTransitioning else { return nil }
////        return presentInteractor
//    }
//
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return nil
////        guard !disableInteractivePlayerTransitioning else { return nil }
////        return dismissInteractor
//    }
//}





