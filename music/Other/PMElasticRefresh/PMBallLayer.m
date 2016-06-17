//
//  PMBallLayer.m
//  PMElasticRefresh
//
//  Created by Andy on 16/4/13.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import "PMBallLayer.h"

@interface PMBallLayer ()

@property (nonatomic, assign) CGFloat animationHeight;
@property (nonatomic, strong) UIColor *ballColor;

@end

@implementation PMBallLayer

- (instancetype)initWithSize:(CGSize)ballSize fillColor:(UIColor *)fillColor animationHeight:(CGFloat)animationHeight {
    
    if (self = [super init]) {
        self.animationHeight = animationHeight;
        self.ballColor = fillColor;
        
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - ballSize.width) * .5, (self.animationHeight - ballSize.height) * .5 , ballSize.width, ballSize.height);
        
        [self configShape];
    }
    return self;
}

- (void)configShape {
    
    self.hidden = YES;
    CGPoint arcCenterPoint = CGPointMake(self.frame.size.width * .5, self.bounds.size.height * 0.5);
    CGFloat arcRadius = self.frame.size.width * .5;
    
    CGFloat arcStartAngle = 0;
    CGFloat arcEndAngle =  M_PI * 2;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:arcCenterPoint radius:arcRadius startAngle:arcStartAngle endAngle:arcEndAngle clockwise:YES];
    self.path = bezierPath.CGPath;
    self.fillColor = self.ballColor.CGColor;
    self.strokeEnd = 1;
}

- (void)startAnimation {
    
    self.hidden = NO;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.2, 0.2, 0.5);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1.5);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.8],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.duration = .25;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;//不恢复原态
    [self addAnimation:animation forKey:@"DSPopUpAnimation"];

}

- (void)endAnimation {
    
    
    CABasicAnimation * pulldownAnimation = [CABasicAnimation animation];
    pulldownAnimation.removedOnCompletion = NO;
    pulldownAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    pulldownAnimation.duration = 0.1;
    pulldownAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pulldownAnimation.keyPath = @"transform.scale";
    pulldownAnimation.fromValue = @1.0;
    pulldownAnimation.toValue = @0.0;
    
    [self addAnimation:pulldownAnimation forKey:@"transform.scale"];
}


@end
