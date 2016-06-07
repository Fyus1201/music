//
//  UIView+FYAnimations_h.m
//  music
//
//  Created by 寿煜宇 on 16/5/31.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "UIView+FYAnimations.h"

@implementation UIView (FYAnimations)

- (void)startDuangAnimation {
    UIViewAnimationOptions op = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:0.15 delay:0 options:op animations:^{
        [self.layer setValue:@(0.80) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:op animations:^{
            [self.layer setValue:@(1.3) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0 options:op animations:^{
                [self.layer setValue:@(1) forKeyPath:@"transform.scale"];
            } completion:NULL];
        }];
    }];
}

- (void)startTransitionAnimation {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:nil];
}

@end
