//
//  FYPlayView.h
//  music
//
//  Created by 寿煜宇 on 16/5/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PlayViewDelegate <NSObject>

- (void)playButtonDidClick:(NSInteger)index;

@end

@interface FYPlayView : UIView

@property (nonatomic,weak) id<PlayViewDelegate> delegate;

@property (nonatomic,strong) UIImageView *circleIV;
@property (nonatomic,strong) UIImageView *contentIV;

@end
