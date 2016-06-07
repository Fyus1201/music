//
//  FYHeaderView.h
//  music
//
//  Created by 寿煜宇 on 16/6/1.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PicView.h"
#import "IconNameView.h"
#import "DescView.h"

// 按钮协议
@protocol FYHeaderViewDelegate <NSObject>

- (void)topLeftButtonDidClick;
- (void)topRightButtonDidClick;

@end

@interface FYHeaderView : UIImageView

// 头部标题
@property (nonatomic,strong) UILabel *title;
// 头像旁边标题(与头部视图text相等)
@property (nonatomic,strong) UILabel *smallTitle;
// 背景图 和 方向图
@property (nonatomic,strong) PicView *picView;
// 自定义头像按钮
@property (nonatomic,strong) IconNameView *nameView;
// 自定义描述按钮
@property (nonatomic,strong) DescView *descView;
@property (nonatomic) CGRect visualEffectFrame;
/** 根据标签数组, 设置按钮标签 */
- (void)setupTagsBtnWithTagNames:(NSArray *)tagNames;


// 定义代理
@property (nonatomic,weak) id<FYHeaderViewDelegate> delegete;

@end
