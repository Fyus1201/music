//
//  PMBallLayer.h
//  PMElasticRefresh
//
//  Created by Andy on 16/4/13.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface PMBallLayer : CAShapeLayer

- (instancetype)initWithSize:(CGSize)ballSize fillColor:(UIColor *)fillColor animationHeight:(CGFloat)animationHeight;
- (void)startAnimation;
- (void)endAnimation;

@end
