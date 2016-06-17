//
//  NewContentViewModel.h
//  music
//
//  Created by 寿煜宇 on 16/6/14.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "BaseViewModel.h"

@interface NewContentViewModel : BaseViewModel

/**  VM初始化,通过获取外界数据,进行网络加载 */

- (instancetype)init;

// 最大显示行数
@property (nonatomic,assign) NSInteger pageSize;
// 显示总行数
@property (nonatomic,assign) NSInteger rowNumber;

/**  通过分组数, 获取图标*/
- (NSURL *)coverURLForRow:(NSInteger)row;
/**  通过分组数, 获取作者(intro)*/
- (NSString *)introForRow:(NSInteger)row;
/**  通过分组数, 获取播放次数*/
- (NSString *)playsForRow:(NSInteger)row;
/**  通过分组数, 获取集数*/
- (NSString *)tracksForRow:(NSInteger)row;

/**  通过分组数, 获取(trackTitle)*/
- (NSString *)trackTitleForRow:(NSInteger)row;
/**  通过分组数, 获取标题(title)*/
- (NSString *)titleForRow:(NSInteger)row;
/**  通过分组数, 获取分类Id */
- (NSInteger)albumIdForRow:(NSInteger)row;

/**  通过分组数, 获取url*/
- (NSURL *)urlForRow:(NSInteger)row;

@end
