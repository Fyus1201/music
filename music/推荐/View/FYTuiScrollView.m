//
//  FYTuiScrollView.m
//  music
//
//  Created by 寿煜宇 on 16/4/21.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYTuiScrollView.h"
#import "LeftView.h"

#define showLeftViewMaxWidth 10 //拖拽出来的View宽
#define maxWidth 240 //可拖动最大距离


@interface FYTuiScrollView ()<UIGestureRecognizerDelegate,leftDelegate>
{
    CGPoint initialPosition;     //初始位置
}
@property(nonatomic,strong)LeftView *leftView;
@property(nonatomic,strong)UIView *backView;//蒙版
@property(nonatomic)UIScreenEdgePanGestureRecognizer *pan;


@end

@implementation FYTuiScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];

    }
    return self;
}
-(void)initUI
{
    [self addGestureRecognizer];
}

#pragma mark - 手势
-(void)addGestureRecognizer{
    
    self.pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    self.pan.delegate = self;
    self.pan.edges = UIRectEdgeLeft;//左侧
    [self addGestureRecognizer:self.pan];
    [self.panGestureRecognizer requireGestureRecognizerToFail:self.pan];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
       return NO;
}
#pragma mark - 解决手势冲突
- (BOOL)panShowLeftView:(UIGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer == self.panGestureRecognizer){
        
        UIPanGestureRecognizer *panGes = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [panGes translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state){
            
            CGPoint location = [gestureRecognizer locationInView:self];
            if (point.x < 0 && location.x < self.frame.size.width && self.contentOffset.x <= 0){
                return YES;
            }
            
        }
        
    }
    return NO;
    
}

-(UIView *)leftView{
    
    if (!_leftView) {
        _leftView = [[LeftView alloc]initWithFrame:CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height)];
        _leftView.delegate = self;//设置代理
    }
    return _leftView;
}

- (void)jumpWebVC:(NSURL *)url{
    
    [self.sdelegate scrollWebVC:url];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        self.pan.enabled = YES;
        [_backView removeFromSuperview];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
}

-(UIView *)backView{
    
    if (!_backView){
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        UIPanGestureRecognizer *backPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(backPanGes:)];
        [_backView addGestureRecognizer:backPan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapGes:)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

-(void)panGesture:(UIScreenEdgePanGestureRecognizer *)ges{
    
    [self dragLeftView:ges];
}

-(void)dragLeftView:(UIPanGestureRecognizer *)panGes{
    
    [_leftView removeFromSuperview];
    [_backView removeFromSuperview];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backView];
    [window addSubview:self.leftView];
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        
        initialPosition.x = self.leftView.center.x;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    CGPoint point = [panGes translationInView:self];
    
    if (point.x >= 0 && point.x <= maxWidth) {
        
        _leftView.center = CGPointMake(initialPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (maxWidth + point.x) / (2* maxWidth) - 0.5);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (panGes.state == UIGestureRecognizerStateEnded){
        
        if (point.x <= showLeftViewMaxWidth) {
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];
            
        }else if (point.x > showLeftViewMaxWidth && point.x <= maxWidth){
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

-(void)backPanGes:(UIPanGestureRecognizer *)ges{
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        initialPosition.x = self.leftView.center.x;
    }
    
    CGPoint point = [ges translationInView:self];
    
    if (point.x <= 0 && point.x <= maxWidth) {
        _leftView.center = CGPointMake(initialPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (maxWidth + point.x) / (2* maxWidth));
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded){

        if (  -point.x <= 50) {
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            } completion:^(BOOL finished) {

            }];
            
        }else{
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

            }];
        }
    }
    
}
-(void)backViewTapGes:(UITapGestureRecognizer *)ges{
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        self.pan.enabled = YES;
        [_backView removeFromSuperview];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
    
}

@end
