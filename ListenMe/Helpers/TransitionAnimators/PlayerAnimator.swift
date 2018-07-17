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
    var duration: TimeInterval { return 0.45 }
    
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
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        let actionView = isPresenting ? toView : fromView
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = actionView.backgroundColor
        
        let initialFrame: CGRect
        let finalFrame: CGRect
        let finalFrameForSmallPlayerView: CGRect
        let finalFrameForSeparatorView: CGRect
        let finalAlpha: CGFloat
        let finalAlphaForSmallPlayerView: CGFloat
        let completionAlphaForSmallPlayerView: CGFloat
        
        if isPresenting {
            containerView.addSubview(backgroundView)
            containerView.addSubview(smallPlayerView)
            containerView.addSubview(toView)
            containerView.addSubview(separatorView)
            
            initialFrame = CGRect(x: 0, y: toView.frame.height - SmallPlayerController.height, width: toView.frame.width, height: toView.frame.height)

            toView.alpha = 0
        } else {
            containerView.insertSubview(smallPlayerView, belowSubview: fromView)
            containerView.insertSubview(backgroundView, belowSubview: smallPlayerView)
            containerView.insertSubview(toView, belowSubview: backgroundView)
            containerView.addSubview(separatorView)
            
            initialFrame = fromView.frame
        }

        backgroundView.frame = initialFrame
        toView.frame = initialFrame
        smallPlayerView.frame = CGRect(x: 0, y: initialFrame.minY, width: toView.frame.width, height: SmallPlayerController.height)
        separatorView.frame = CGRect(x: 0, y: initialFrame.minY - 1, width: toView.frame.width, height: 1)
        
        if isPresenting {
            finalFrame = CGRect(origin: .zero, size: toView.frame.size)
            finalFrameForSmallPlayerView = CGRect(x: 0, y: 0, width: toView.frame.width, height: SmallPlayerController.height)
            finalFrameForSeparatorView = CGRect(x: 0, y: -2, width: toView.frame.width, height: 1)

            finalAlpha = 1
            finalAlphaForSmallPlayerView = 0
            completionAlphaForSmallPlayerView = 1
        } else {
            finalFrame = CGRect(x: 0, y: toView.frame.height - SmallPlayerController.height, width: toView.frame.width, height: toView.frame.height)
            finalFrameForSmallPlayerView = CGRect(x: 0, y: finalFrame.minY, width: toView.frame.width, height: SmallPlayerController.height)
            finalFrameForSeparatorView = CGRect(x: 0, y: finalFrame.minY - 1, width: toView.frame.width, height: 1)

            finalAlpha = 0
            finalAlphaForSmallPlayerView = 1
            completionAlphaForSmallPlayerView = 0
        }
        
        UIView.animate(withDuration: duration, animations: {
            actionView.alpha = finalAlpha
            actionView.frame = finalFrame
            backgroundView.frame = finalFrame

            self.smallPlayerView.alpha = finalAlphaForSmallPlayerView
            self.smallPlayerView.frame = finalFrameForSmallPlayerView
            self.separatorView.frame = finalFrameForSeparatorView
        }) { (_) in
            self.smallPlayerView.alpha = completionAlphaForSmallPlayerView

            self.separatorView.removeFromSuperview()
            self.smallPlayerView.removeFromSuperview()
            backgroundView.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
    }
}













