//
//  PlayerAnimator.swift
//  ListenMe
//
//  Created by Dauren Muratov on 7/4/18.
//  Copyright © 2018 paradox. All rights reserved.
//

import UIKit
import EasyPeasy

class PlayerAnimator: NSObject {
    
    // MARK: - Constants
    var duration: TimeInterval { return 0.5 }
    
    // MARK: - Public properties
    var smallPlayerView: UIView!
    var isPresenting: Bool!
    
    // MARK: - Private properties

    
    // MARK: - UI
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
}

extension PlayerAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
//        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = toView.backgroundColor
        containerView.addSubview(backgroundView)
        containerView.addSubview(smallPlayerView)
        containerView.addSubview(toView)
        containerView.addSubview(separatorView)
        
        let initialFrame = CGRect(x: 0, y: toView.frame.height - SmallPlayerController.height, width: toView.frame.width, height: toView.frame.height)
        backgroundView.frame = initialFrame
        toView.frame = initialFrame
        smallPlayerView.frame = CGRect(x: 0, y: initialFrame.minY, width: toView.frame.width, height: SmallPlayerController.height)
        separatorView.frame = CGRect(x: 0, y: initialFrame.minY - 1, width: toView.frame.width, height: 1)
        
        toView.alpha = 0
        
        let finalFrame = CGRect(origin: .zero, size: toView.frame.size)
        let finalFrameForSmallPlayerView = CGRect(x: 0, y: 0, width: toView.frame.width, height: SmallPlayerController.height)
        let finalFrameForSeparatorView = CGRect(x: 0, y: -2, width: toView.frame.width, height: 1)
        
        UIView.animate(withDuration: duration, animations: {
            toView.alpha = 1
            toView.frame = finalFrame
            backgroundView.frame = finalFrame
            
            self.smallPlayerView.alpha = 0
            self.smallPlayerView.frame = finalFrameForSmallPlayerView
            self.separatorView.frame = finalFrameForSeparatorView
        }) { (_) in
            self.smallPlayerView.alpha = 1
            self.separatorView.removeFromSuperview()
            self.smallPlayerView.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
    }
}













