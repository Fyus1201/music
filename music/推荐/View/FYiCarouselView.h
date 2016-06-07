//
//  FYiCarouselView.h
//  music
//
//  Created by 寿煜宇 on 16/5/24.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreContentViewModel.h"
#import "iCarousel.h"

/** iCarousel滚动视图 */
@interface FYiCarouselView : NSObject

/** 视图  */
@property (nonatomic, strong) UIView *iView;
/** 传入model */
- (instancetype)initWithFocusImgMdoel:(MoreContentViewModel *)Mdoel;
@property (strong, nonatomic) iCarousel *carousel;

@property (nonatomic,strong) MoreContentViewModel *moreVM;

/** 点击事件 会返回点击的index  和 数据数组 */
@property (nonatomic, copy) void (^clickAction)(NSInteger index);

@end
