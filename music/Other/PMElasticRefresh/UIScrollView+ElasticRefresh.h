//
//  UIScrollView+ElasticRefresh.h
//  PMElasticRefresh
//
//  Created by Andy on 16/4/16.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMElasticView.h"

@interface UIScrollView (ElasticRefresh)

@property (nonatomic, strong) PMElasticView *elasticView;

- (void)pm_RefreshHeaderWithBlock:(PMRefreshBlock)refreshBlock;
- (void)endRefresh;
- (void)startRefresh;

@end
