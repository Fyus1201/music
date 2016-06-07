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
@property (nonatomic, strong) AVPlayer *player;

/** 初始化 */
+ (instancetype)sharedInstance;
/** 清空属性 */
- (void)releasePlayer;

/** 装载专辑 */
- (void)playWithModel:(TracksViewModel *)tracks indexPathRow:(NSInteger ) indexPathRow;

- (void)pauseMusic;
- (void)stopMusic;

/** 状态查询 */
- (NSInteger )playerStatus;
- (NSInteger )FYPlayerCycle;

- (NSString *)playMusicName;
- (NSString *)playSinger;
- (NSString *)playMusicTitle;
- (NSURL *)playCoverLarge;

//播放音效
- (void)playSound:(NSString *)filename;
- (void)disposeSound:(NSString *)filename;

@end
