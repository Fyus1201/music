//
//  FYPercentDrivenInteractiveTransition.h
//  music
//
//  Created by 寿煜宇 on 16/6/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition


@property (nonatomic, weak) UIViewController *vc;

@property (nonatomic, assign) BOOL isInteracting;
@property (nonatomic, assign) BOOL shouldComplete;

- (instancetype)init:(UIViewController *)vc;

@end
