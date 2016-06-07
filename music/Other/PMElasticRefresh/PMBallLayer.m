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
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - ballSize.width) * .5, 0, ballSize.width, ballSize.height);
        [self configShape];
    }
    return self;
}

- (void)configShape {
    
    self.hidden = YES;
    CGPoint arcCenterPoint = CGPointMake(self.frame.size.width * .5, self.animationHeight + self.bounds.size.height * .5);
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
    CABasicAnimation *moveupAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveupAnimation.fromValue = [NSValue valueWithCGPoint:self.position];
    moveupAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.position.x, self.position.y - (self.animationHeight + self.bounds.size.height) * .5)];
    moveupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    moveupAnimation.fillMode = kCAFillModeForwards;
    moveupAnimation.removedOnCompletion = NO;
    [self addAnimation:moveupAnimation forKey:@"moveupAnimation"];
}

- (void)endAnimation {
    
    CABasicAnimation *pulldownAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    pulldownAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.position.x, self.position.y - (self.animationHeight + self.bounds.size.height) * .5)];
    pulldownAnimation.toValue = [NSValue valueWithCGPoint:self.position];
    pulldownAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pulldownAnimation.fillMode = kCAFillModeForwards;
    pulldownAnimation.removedOnCompletion = NO;
    [self addAnimation:pulldownAnimation forKey:@"pulldownAnimation"];
}

@end
