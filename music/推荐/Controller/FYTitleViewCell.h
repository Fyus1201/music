//
//  FYTitleViewCell.h
//  music
//
//  Created by 寿煜宇 on 16/5/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate传值
@protocol FYTitleViewDelegate <NSObject>

- (void)titleViewDidClick:(NSInteger)tag;

@end

@interface FYTitleViewCell : UIView

// 添加代理
@property (nonatomic,weak) id<FYTitleViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title hasMore:(BOOL)more titleTag:(NSInteger) titleTag;

/**  标题 */
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,assign) NSInteger titleTag;

@end
