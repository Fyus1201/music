//
//  FYMissAnimation.m
//  music
//
//  Created by 寿煜宇 on 16/6/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMissAnimation.h"

@implementation FYMissAnimation

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
   
    //UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    
    //拿到Presenting的最终Frame
    CGRect finalFrame = CGRectOffset(initFrame, 0, screenBounds.size.height);
    //拿到转换的容器view
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.alpha = 0.8;
        fromView.frame = finalFrame;
    } completion:^(BOOL finished) {
        
        BOOL complate = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:(!complate)];
    }];
}

-(void)animationEnded:(BOOL)transitionCompleted {
}

@end
