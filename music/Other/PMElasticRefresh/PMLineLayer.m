//
//  PMLineLayer.m
//  PMElasticRefresh
//
//  Created by Andy on 16/4/16.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import "PMLineLayer.h"

@interface PMLineLayer ()

@property (nonatomic, strong) UIColor *arcStrokeColor;
@property (nonatomic, assign) CGFloat animationHeight;

@end

@implementation PMLineLayer

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithSize:(CGSize)ballSize StrokeColor:(UIColor *)strokeColor animationHeight:(CGFloat)animationHeigt{
    
    if (self = [super init]) {
        self.animationHeight = animationHeigt;
        self.arcStrokeColor = strokeColor;
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - ballSize.width) * .5, (self.animationHeight - ballSize.height) * .5 , ballSize.width, ballSize.height);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endAnimation) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [self configShape];

    }
    return self;
}

- (void)configShape {
    
    CGPoint arcCenterPoint = CGPointMake(self.frame.size.width * .5, self.frame.size.height * .5);
    CGFloat arcRadius = self.frame.size.width * .5 * 1.15;
    CGFloat arcStartAngle = -M_PI_2;
    CGFloat arcEndAngle = M_PI * 2 - M_PI_2 + M_PI / 8.0;
//    CGFloat arcStartAngle = 0;
//    CGFloat arcEndAngle =  M_PI;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:arcCenterPoint radius:arcRadius startAngle:arcStartAngle endAngle:arcEndAngle clockwise:YES];
    self.path = bezierPath.CGPath;
    self.fillColor = nil;
    self.strokeColor = self.arcStrokeColor.CGColor;
    self.lineWidth = 3.0;
    self.lineCap = kCALineCapRound;
    self.strokeStart = 0;
    self.strokeEnd = 0;
    self.hidden = YES;
}

- (void)startAnimation {
    
    self.hidden = NO;
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = @(0);
    rotateAnimation.toValue = @(2 * M_PI);
    rotateAnimation.duration = 1;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotateAnimation.repeatCount = HUGE;
    [self addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    [self strokeEndAnimation];
}

- (void)endAnimation {
    
    self.hidden = YES;
    [self removeAllAnimations];
}

- (void)strokeEndAnimation {
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0);
    strokeEndAnimation.toValue = @(.95);
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeEndAnimation.duration = 2;
    strokeEndAnimation.repeatCount = 1;
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    strokeEndAnimation.delegate = self;
    [self addAnimation:strokeEndAnimation forKey:@"strokeEndAnimation"];
}

- (void)strokeStartAnimation {
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(0);
    strokeStartAnimation.toValue = @(.95);
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeStartAnimation.duration = 2;
    strokeStartAnimation.repeatCount = 1;
    strokeStartAnimation.fillMode = kCAFillModeForwards;
    strokeStartAnimation.removedOnCompletion = NO;
    strokeStartAnimation.delegate = self;
    [self addAnimation:strokeStartAnimation forKey:@"strokeStartAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag) {
        CABasicAnimation *basicAnimation = (CABasicAnimation *)anim;
        if ([basicAnimation.keyPath isEqualToString:@"strokeEnd"]) {
            [self strokeStartAnimation];
        } else if ([basicAnimation.keyPath isEqualToString:@"strokeStart"]){
            [self removeAnimationForKey:@"strokeStartAnimation"];
            [self removeAnimationForKey:@"strokeEndAnimation"];
//            self.strokeEnd = 0;
//            self.strokeStart = 0;
            [self strokeEndAnimation];
        }
    }
}

@end
