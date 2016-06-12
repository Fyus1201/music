//
//  FYPlayManager.h
//  music
//
//  Created by 寿煜宇 on 16/6/3.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "TracksViewModel.h"

@interface FYPlayManager : NSObject

//播放状态
typedef NS_ENUM(NSInteger, FYPlayerCycle) {
    theSong = 1,
    nextSong = 2,
    isRandom = 3
};
//播放状态
typedef NS_ENUM(NSInteger, itemModel) {
    historyItem = 0,
    favoritelItem = 1
};

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL isPlay;

/** 初始化 */
+ (instancetype)sharedInstance;
/** 清空属性 */
- (void)releasePlayer;

/** 装载专辑 */
- (void)playWithModel:(TracksViewModel *)tracks indexPathRow:(NSInteger ) indexPathRow;

- (void)pauseMusic;
- (void)previousMusic;
- (void)nextMusic;
- (void)nextCycle;

- (void)setFavoriteMusic;
- (void)setHistoryMusic;

- (void)delFavoriteMusic;
- (void)delMyFavoriteMusic:(NSInteger )indexPathRow;
- (void)delMyFavoriteMusicDictionary:(NSDictionary *)track;
- (void)delMyHistoryMusic:(NSDictionary *)track;
- (void)delAllHistoryMusic;
- (void)delAllFavoriteMusic;
- (void)stopMusic;

/** 状态查询 */
- (NSInteger )playerStatus;
- (NSInteger )FYPlayerCycle;

- (NSString *)playMusicName;
- (NSString *)playSinger;
- (NSString *)playMusicTitle;
- (NSURL *)playCoverLarge;
- (UIImage *)playCoverImage;

- (BOOL)hasBeenFavoriteMusic;

- (NSArray *)favoriteMusicItems;
- (NSArray *)historyMusicItems;

/** 保存 */
- (BOOL)saveChanges;

//播放音效
- (void)playSound:(NSString *)filename;
- (void)disposeSound:(NSString *)filename;

@end
