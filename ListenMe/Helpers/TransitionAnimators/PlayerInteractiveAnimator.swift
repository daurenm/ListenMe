//
//  PlayerInteractiveAnimator.swift
//  ListenMe
//
//  Created by Dauren Muratov on 7/17/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy

class PlayerInteractiveAnimator: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Public properties
    var inProgress = false

    var viewController: UIViewController! {
        didSet {
            prepareGestureRecognizer(in: viewController.view)
        }
    }
    
    // MARK: - Private properties
    
    // MARK: - Private methods
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let view = gesture.view!
        let y = gesture.translation(in: view).y
        var progress = (y) / (view.frame.height - SmallPlayerController.height)
        progress = min(progress, 1)
        progress = max(progress, 0)
        
        switch gesture.state {
        case .began:
            inProgress = true
            viewController.dismiss(animated: true)
            
        case .changed:
            update(progress)
            
        case .cancelled:
            inProgress = false
            cancel()
            
        case .ended:
            inProgress = false
            let velocity = gesture.velocity(in: view)
            if velocity.y >= 0 {
                finish()
            } else {
                cancel()
            }
        default: ()
        }
    }
}










