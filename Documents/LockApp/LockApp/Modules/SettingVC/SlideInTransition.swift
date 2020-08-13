//
//  SlideInTransition.swift
//  SlideInTransition
//
//  Created by Gary Tokman on 1/13/19.
//  Copyright © 2019 Gary Tokman. All rights reserved.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting = false
    let dimmingView = UIView()
    

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        let containerView = transitionContext.containerView

        let finalWidth = DEVICE_WIDTH * 0.7
          let finalHeight = DEVICE_HEIGHT

        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
//            dimmingView.frame = CGRect.init(x: 0, y: 0,width: toViewController.view.bounds.width * 0.2 , height: toViewController.view.bounds.height)
            // Add menu view controller to container
            containerView.addSubview(toViewController.view)

            // Init frame off the screen
            toViewController.view.frame = CGRect(x: finalWidth, y: 0, width: finalWidth, height: finalHeight)
    }

        // Move on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: -finalWidth*3/7, y: 0)
        }


        // Move back off screen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }

        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }

}
