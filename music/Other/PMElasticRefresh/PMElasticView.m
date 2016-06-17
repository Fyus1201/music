//
//  PMElasticView.m
//  PMElasticRefresh
//
//  Created by Andy on 16/4/13.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import "PMElasticView.h"

#import "PMBallLayer.h"
#import "PMLineLayer.h"

#define CONTENTOFFSET_KEYPATH @"contentOffset"
#define AnimationDISTANCE -80
#define NavigationHeight 0//起始点偏移值，64 or 0

@interface PMElasticView ()

@property (nonatomic, strong) UIScrollView *bindingScrollView;
@property (nonatomic, assign) CGFloat offSet_Y;
@property (nonatomic, assign, getter = isEndAnimation) BOOL endAniamtion;
@property (nonatomic, assign) BOOL isCan;
@property (nonatomic, strong) CAShapeLayer *elasticShaperLayer;
@property (nonatomic, strong) PMBallLayer *ballLayer;
@property (nonatomic, strong) PMLineLayer *lineLayer;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation PMElasticView

- (void)dealloc {
    
    NSLog(@"dealloc PMElasticView");
    [self.bindingScrollView removeObserver:self forKeyPath:CONTENTOFFSET_KEYPATH];
}

- (instancetype)initWithBindingScrollView:(UIScrollView *)bindingScrollView {
    
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor whiteColor];
        self.bindingScrollView = bindingScrollView;
//        self.bindingScrollView.backgroundColor = [UIColor clearColor];
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews {
    
    self.elasticShaperLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];//背景样式
    self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:0];
    self.elasticShaperLayer.fillColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0].CGColor;
    [self.layer addSublayer:self.elasticShaperLayer];
    
    [self.bindingScrollView addObserver:self forKeyPath:CONTENTOFFSET_KEYPATH options:NSKeyValueObservingOptionInitial context:nil];//KVO
    
    self.ballLayer = [[PMBallLayer alloc] initWithSize:CGSizeMake(40, 40) fillColor:[UIColor whiteColor] animationHeight:ABS(AnimationDISTANCE)];
    [self.elasticShaperLayer addSublayer:self.ballLayer];//内圆
    
    self.lineLayer = [[PMLineLayer alloc] initWithSize:CGSizeMake(40, 40) StrokeColor:[UIColor whiteColor] animationHeight:ABS(AnimationDISTANCE)];
    [self.elasticShaperLayer addSublayer:self.lineLayer];//外圈
    
    self.endAniamtion = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    
    if ([keyPath isEqualToString:CONTENTOFFSET_KEYPATH] && [object isKindOfClass:[UIScrollView class]]) {
 
        [self.timer invalidate];
        
        self.offSet_Y = self.bindingScrollView.contentOffset.y + NavigationHeight;
        
        self.frame = CGRectMake(0, self.offSet_Y >= 0 ? 0 : self.offSet_Y, self.bindingScrollView.bounds.size.width, self.offSet_Y >=0 ? 0 : ABS(self.offSet_Y));
        
        if (self.bindingScrollView.dragging || self.offSet_Y > AnimationDISTANCE) {
            self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:-self.offSet_Y];
        }
        if (self.offSet_Y == 0) {
            self.endAniamtion = NO;
        }
        [self changeScrollViewProperty];

        if (self.offSet_Y == -80) {
            _isCan = YES;
        }else{
             _isCan = NO;
        }
    }
}

- (void)changeScrollViewProperty {
    
    if (self.offSet_Y <= AnimationDISTANCE) {
        if (!self.bindingScrollView.dragging && !self.endAniamtion) {
            [self.bindingScrollView setContentOffset:CGPointMake(0, AnimationDISTANCE - NavigationHeight) animated:NO];
            if (self.refreshBlock) {
                self.refreshBlock();
            }
            [self elasticLayerAnimation];
        }
    } else {
        
        self.ballLayer.hidden = YES;
        self.lineLayer.hidden = YES;
        [self.elasticShaperLayer removeAllAnimations];
        [self.ballLayer endAnimation];
        [self.lineLayer endAnimation];
    }
}

- (void)elasticLayerAnimation {
    
    self.ballLayer.hidden = NO;
    self.lineLayer.hidden = NO;
    self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE)];
    NSArray *pathValues = @[
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(self.offSet_Y)],
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE) * 0.7],
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE) * 1.3],
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE) * 0.9],
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE) * 1.1],
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE)]
                           ];
    
    CAKeyframeAnimation *elasticAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    elasticAnimation.values = pathValues;
    elasticAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    elasticAnimation.duration = 1;
    elasticAnimation.fillMode = kCAFillModeForwards;
    elasticAnimation.removedOnCompletion = NO;
    elasticAnimation.delegate = self;
    [self.elasticShaperLayer addAnimation:elasticAnimation forKey:@"elasticAnimation"];
    
    
    [self.ballLayer startAnimation];
    [self.lineLayer startAnimation];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag) {
        self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE)];
        [self.elasticShaperLayer removeAnimationForKey:@"elasticAnimation"];
    }
}
/** 拖动位置 */
- (CGPathRef)calculateAnimaPathWithOriginY:(CGFloat)originY {
    
    CGPoint topLeftPoint = CGPointMake(0,0);
    CGPoint bottomLeftPoint = CGPointMake(0, self.offSet_Y <= AnimationDISTANCE ? 80 : originY);
    
    CGPoint controlPoint = CGPointMake(self.bindingScrollView.bounds.size.width * .5, originY);//拖动点
    
    CGPoint bottomRightPoint = CGPointMake(self.bindingScrollView.bounds.size.width, self.offSet_Y <= AnimationDISTANCE ? 80 : originY);
    CGPoint topRightPoint = CGPointMake(self.bindingScrollView.bounds.size.width, 0);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:topLeftPoint];
    [bezierPath addLineToPoint:bottomLeftPoint];
    [bezierPath addQuadCurveToPoint:bottomRightPoint controlPoint:controlPoint];
    [bezierPath addLineToPoint:topRightPoint];
    [bezierPath addLineToPoint:topLeftPoint];
    return bezierPath.CGPath;
}

- (void)endRefresh {//结束
    
    self.endAniamtion = self.offSet_Y == 0 ? NO : YES;
    [self.elasticShaperLayer removeAllAnimations];
    [self.ballLayer endAnimation];
    [self.lineLayer endAnimation];
    [self.bindingScrollView setContentOffset:CGPointMake(0, -NavigationHeight) animated:YES];
    
}
- (void)startRefresh {//开始
    
    
}

#pragma mark - timer方法
/** 添加定时器*/
-(void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextEnd) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)nextEnd{

    if (_isCan == YES) {
        [self endRefresh];
    }
}

@end