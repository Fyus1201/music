//
//  TracksViewModel.m
//  music
//
//  Created by 寿煜宇 on 16/5/18.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "BaseViewModel.h"

/**
 *  选集VM
 */
@interface TracksViewModel : BaseViewModel

// 以albumId ,title初始化 VM
- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)title isAsc:(BOOL)asc;
- (instancetype)initWithitemModel:(NSInteger )itemMel;
- (void)getItemModelData:(void (^)(NSError *))completed;

@property (nonatomic,assign) NSInteger albumId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign,getter=isAsc) BOOL asc;

// 返回行数
@property (nonatomic,assign) NSInteger rowNumber;
/** 通过行数, 返回标题 */
- (NSString *)titleForRow:(NSInteger)row;
/** 通过行数, 返回创作人(来源) */
- (NSString *)nickNameForRow:(NSInteger)row;
/** 通过行数, 返回更新时间 */
- (NSString *)updateTimeForRow:(NSInteger)row;
/** 通过行数, 返回收藏喜欢数 */
- (NSString *)favorCountForRow:(NSInteger)row;
/** 通过行数, 返回播放次数 */
- (NSString *)playsCountForRow:(NSInteger)row;
/** 通过行数, 返回播放时长 */
- (NSString *)playTimeForRow:(NSInteger)row;
/** 通过行数, 返回评论数 */
- (NSString *)commentCountForRow:(NSInteger)row;
/** 通过行数, 返回播放地址 */
- (NSURL *)playURLForRow:(NSInteger)row;
/** 通过行数, 返回集数图片地址 */
- (NSURL *)coverURLForRow:(NSInteger)row;
- (NSURL *)coverLargeURLForRow:(NSInteger)row;
/** 通过行数，返回字典 */
- (NSDictionary *)trackForRow:(NSInteger)row;
/** 通过行数, 返回播放ID */
- (NSInteger )trackIdForRow:(NSInteger)row;
/** 通过行数, 返回专辑ID */
- (NSInteger )albumIdForRow:(NSInteger)row;
/** 返回总歌曲数 */
- (NSInteger )trackRow;

/** 返回专辑标题 */
@property (nonatomic,strong) NSString *albumTitle;
/** 返回专辑播放次数 */
@property (nonatomic,strong) NSString *albumPlays;
/** 返回专辑图片链接地址 */
@property (nonatomic,strong) NSURL *albumCoverURL;
@property (nonatomic,strong) NSURL *albumCoverLargeURL;
/** 返回专辑头像地址 */
@property (nonatomic,strong) NSURL *albumIconURL;
/** 返回专辑昵称 */
@property (nonatomic,strong) NSString *albumNickName;
/** 返回专辑说明 */
@property (nonatomic,strong) NSString *albumDesc;
/** 返回专辑标签数组 */
@property (nonatomic,strong) NSArray *tagsName;


@end
