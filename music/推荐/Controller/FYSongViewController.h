//
//  FYSongViewController.h
//  music
//
//  Created by 寿煜宇 on 16/5/25.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYSongViewController : UIViewController

// 选择接受外界title, 以及albumId 初始化
- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)oTitle;

@property (nonatomic,assign) NSInteger albumId;
@property (nonatomic,strong) NSString *oTitle;

@end
