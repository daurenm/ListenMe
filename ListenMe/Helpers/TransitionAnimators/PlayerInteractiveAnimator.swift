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

    var onBegin: (() -> ())!
    
    var view: UIView! {
        didSet {
            prepareGestureRecognizer(in: view)
        }
    }
    
    // MARK: - Private properties
    let isPresenting: Bool
    
    // MARK: - Lifecycle methods
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    // MARK: - Private methods
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let view = gesture.view!
        var y = gesture.translation(in: view).y
        let height: CGFloat
        if !isPresenting {
            height = view.frame.height - SmallPlayerController.height
        } else {
            y = -y
            height = view.superview!.frame.height
        }
        var progress = y / height
        progress = min(progress, 1)
        progress = max(progress, 0)
        
        switch gesture.state {
        case .began:
            inProgress = true
            onBegin()
            
        case .changed:
            update(progress)
            
        case .cancelled:
            inProgress = false
            cancel()
            
        case .ended:
            inProgress = false
            let velocity = gesture.velocity(in: view)
            let completeTransition = (!isPresenting && velocity.y > 0) || (isPresenting && velocity.y < 0)
            if completeTransition {
                finish()
            } else {
                cancel()
            }
        default: ()
        }
    }
}










