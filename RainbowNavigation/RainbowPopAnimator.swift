//
//  LLRainbowPopAnimator.swift
//  Pods
//
//  Created by Danis on 15/11/25.
//
//

class RainbowPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var animating = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let fromColorSource = fromVC as? RainbowColorSource
        let toColorSource = toVC as? RainbowColorSource
        
        var nextColor:UIColor?
        nextColor = fromColorSource?.navigationBarOutColor?()
        nextColor = toColorSource?.navigationBarInColor?()
        
        let containerView = transitionContext.containerView()!
        let shadowMask = UIView(frame: containerView.bounds)
        shadowMask.backgroundColor = UIColor.blackColor()
        shadowMask.alpha = 0.3
        
        let finalToFrame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.frame = CGRectOffset(finalToFrame, -finalToFrame.width/2, 0)
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        containerView.insertSubview(shadowMask, aboveSubview: toVC.view)
        
        let duration = self.transitionDuration(transitionContext)
        
        animating = true
        UIView.animateWithDuration(duration, delay: 0, options: .CurveLinear, animations: { () -> Void in
            fromVC.view.frame = CGRectOffset(fromVC.view.frame, fromVC.view.frame.width, 0)
            toVC.view.frame = finalToFrame
            shadowMask.alpha = 0
            if let navigationColor = nextColor {
                fromVC.navigationController?.navigationBar.df_setBackgroundColor(navigationColor)
            }
            
            }) { (finished) -> Void in
                self.animating = false
                shadowMask.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
