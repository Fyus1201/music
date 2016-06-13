//
//  FYPercentDrivenInteractiveTransition.m
//  music
//
//  Created by 寿煜宇 on 16/6/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYPercentDrivenInteractiveTransition.h"

@implementation FYPercentDrivenInteractiveTransition

- (instancetype)init:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        _vc = vc;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureHandler:)];
        [vc.view addGestureRecognizer:pan];
    }
    return self;
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)gesture {
    
    CGPoint translation = [gesture translationInView:gesture.view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            _isInteracting = YES;
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat fraction = (translation.y / 400);
            fraction = fmin(fmaxf(fraction, 0.0), 1.0);
            _shouldComplete = fraction > 0.5;
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            _isInteracting = NO;
            if (!_shouldComplete || gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else {
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

@end
