//
//  PMLineLayer.h
//  PMElasticRefresh
//
//  Created by Andy on 16/4/16.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface PMLineLayer : CAShapeLayer
- (instancetype)initWithSize:(CGSize)ballSize StrokeColor:(UIColor *)strokeColor animationHeight:(CGFloat)animationHeigt;
- (void)startAnimation;
- (void)endAnimation;
@end
