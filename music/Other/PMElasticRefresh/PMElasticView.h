//
//  PMElasticView.h
//  PMElasticRefresh
//
//  Created by Andy on 16/4/13.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PMRefreshBlock)(void);

@interface PMElasticView : UIView
- (instancetype)initWithBindingScrollView:(UIScrollView *)bindingScrollView;

- (void)endRefresh;
- (void)startRefresh;

-(void)addTimer;

@property (nonatomic, copy) PMRefreshBlock refreshBlock;

@end
