//
//  FYPlayManager.m
//  music
//
//  Created by 寿煜宇 on 16/6/3.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYPlayManager.h"
#import "TracksViewModel.h"
#import <MediaPlayer/MediaPlayer.h>

#import "FYfavoriteItem.h"
#import "FYhistoryItem.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@interface FYPlayManager ()

@property (nonatomic) FYPlayerCycle  cycle;

@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;
@property (nonatomic, strong) NSMutableArray *favoriteMusic;
@property (nonatomic, strong) NSMutableArray *historyMusic;

@property (nonatomic) BOOL isLocalVideo; //是否播放本地文件
@property (nonatomic) BOOL isFinishLoad; //是否下载完毕

@property (nonatomic, strong) NSMutableDictionary *soundIDs;//音效

@property (nonatomic,strong) TracksViewModel *tracksVM;
@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,assign) NSInteger rowNumber;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

static FYPlayManager *_instance = nil;

NSString *itemArchivePath(){
    
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [pathList[0] stringByAppendingPathComponent:@"guluMusic.sqlite"];//
}

@implementation FYPlayManager


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {

        _soundIDs = [NSMutableDictionary dictionary];
        
        NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        
        if (defaults[@"cycle"]){
            
            NSInteger cycleDefaults = [defaults[@"cycle"] integerValue];
            _cycle = cycleDefaults;
            
        }else{
            _cycle = theSong;
        }
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // 支持后台播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        // 激活
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        // 开始监控
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        
        //设置路径
        NSURL *storeURL = [NSURL fileURLWithPath:itemArchivePath()];
        NSError *error = nil;
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:nil
                                                               error:&error]){
            
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        //创建NSManagedObjectContext对象
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
        
        [self loadAllItems];
        
    }
    
    return self;
}

#pragma mark - core Data

- (void)loadAllItems{
    
    if (!self.favoriteMusic){
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"FYfavoriteItem" inManagedObjectContext:_managedObjectContext];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [_managedObjectContext executeFetchRequest:request error:&error];
        
        if (!result){
            
            [NSException raise:@"Fetch failed" format:@"Reason:%@",[error localizedDescription]];
        }
        self.favoriteMusic = [[NSMutableArray alloc] initWithArray:result];
    }
    
    if (!self.historyMusic){
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"FYhistoryItem" inManagedObjectContext:_managedObjectContext];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:NO];
        request.sortDescriptors = @[sd];
        
        NSError *error;
       
        NSArray *result = [_managedObjectContext executeFetchRequest:request error:&error];
        
        if (!result){
            
            [NSException raise:@"Fetch failed" format:@"Reason:%@",[error localizedDescription]];
        }
        self.historyMusic = [[NSMutableArray alloc] initWithArray:result];
        
    }
}

- (void)addTrack:(NSDictionary *)track itemModel:(itemModel )itemModel{
    
    if (itemModel == historyItem) {
        double order;
        if ([self.historyMusic count] == 0){
            order = 1.0;
        }else{
            FYhistoryItem *item = self.historyMusic[0];
            order = item.orderingValue + 1.0;
        }
        
        FYhistoryItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"FYhistoryItem" inManagedObjectContext:self.managedObjectContext];

        if (s_isPhone4 || s_isPhone5) {
            NSLog(@"默认保存64bit");
        }else{
            item.albumId = [track[@"albumId"] integerValue];
            item.albumImage = track[@"albumImage"];
            item.albumTitle = [self.tracksVM.albumTitle copy];
            item.comments = [track[@"comments"] integerValue];
            item.coverLarge = track[@"coverLarge"];
            item.coverMiddle = track[@"coverMiddle"];
            item.coverSmall = track[@"coverSmall"];
            item.createdAt = [track[@"createdAt"] integerValue];
            item.downloadAacSize = [track[@"downloadAacSize"] integerValue];
            item.downloadAacUrl = track[@"downloadAacUrl"];
            item.downloadSize = [track[@"downloadSize"] integerValue];
            item.downloadUrl = track[@"downloadUrl"];
            item.duration = [track[@"duration"] floatValue];
            item.isPublic = [track[@"isPublic"] boolValue];
            item.likes = [track[@"likes"] integerValue];
            item.nickname = track[@"nickname"];
            item.opType = [track[@"opType"] integerValue];
            item.orderNum = [track[@"orderNum"] integerValue];
            item.playPathAacv164 = track[@"playPathAacv164"];
            item.playPathAacv224 = track[@"playPathAacv224"];
            item.playUrl32 = track[@"playUrl32"];
            item.playUrl64 = track[@"playUrl64"];
            item.playtimes = [track[@"playtimes"] integerValue];
            item.processState = [track[@"processState"] integerValue];
            item.shares = [track[@"shares"] integerValue];
            item.smallLogo = track[@"smallLogo"];
            item.status = [track[@"status"] integerValue];
            item.title = track[@"title"];
            item.trackId = [track[@"trackId"] integerValue];
            item.uid = [track[@"uid"] integerValue];
            item.userSource = [track[@"userSource"] integerValue];
            item.musicRow = _indexPathRow;
            
            item.orderingValue = order;
        }

        [self.historyMusic addObject:item];
        
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"trackId == %li",[track[@"trackId"] integerValue]];
        
        NSArray *items = [self.historyMusic filteredArrayUsingPredicate:thePredicate];
        if (items.count > 1) {
            [self.managedObjectContext deleteObject:items[0]];
            [self.historyMusic removeObjectIdenticalTo:items[0]];
        }else{
            NSLog(@"historyMusic one");
        }
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:NO];
        [self.historyMusic sortUsingDescriptors:[NSArray arrayWithObject:sd]];


    }
    if (itemModel == favoritelItem) {
        
        double order;
        if ([self.favoriteMusic count] == 0){
            order = 1.0;
        }else{
            FYfavoriteItem *item = [self.favoriteMusic lastObject];
            order = item.orderingValue +1.0;
        }
        
        FYfavoriteItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"FYfavoriteItem" inManagedObjectContext:self.managedObjectContext];
        
        if (s_isPhone5 || s_isPhone4) {
            NSLog(@"默认保存64bit");
        }else{
            item.albumId = [track[@"albumId"] integerValue];
            item.albumImage = track[@"albumImage"];
            item.albumTitle = track[@"albumTitle"];
            item.comments = [track[@"comments"] integerValue];
            item.coverLarge = track[@"coverLarge"];
            item.coverMiddle = track[@"coverMiddle"];
            item.coverSmall = track[@"coverSmall"];
            item.createdAt = [track[@"createdAt"] integerValue];
            item.downloadAacSize = [track[@"downloadAacSize"] integerValue];
            item.downloadAacUrl = track[@"downloadAacUrl"];
            item.downloadSize = [track[@"downloadSize"] integerValue];
            item.downloadUrl = track[@"downloadUrl"];
            item.duration = [track[@"duration"] floatValue];
            item.isPublic = [track[@"isPublic"] boolValue];
            item.likes = [track[@"likes"] integerValue];
            item.nickname = track[@"nickname"];
            item.opType = [track[@"opType"] integerValue];
            item.orderNum = [track[@"orderNum"] integerValue];
            item.playPathAacv164 = track[@"playPathAacv164"];
            item.playPathAacv224 = track[@"playPathAacv224"];
            item.playUrl32 = track[@"playUrl32"];
            item.playUrl64 = track[@"playUrl64"];
            item.playtimes = [track[@"playtimes"] integerValue];
            item.processState = [track[@"processState"] integerValue];
            item.shares = [track[@"shares"] integerValue];
            item.smallLogo = track[@"smallLogo"];
            item.status = [track[@"status"] integerValue];
            item.title = track[@"title"];
            item.trackId = [track[@"trackId"] integerValue];
            item.uid = [track[@"uid"] integerValue];
            item.userSource = [track[@"userSource"] integerValue];
            
            item.orderingValue = order;
        }

        [self.favoriteMusic addObject:item];

    }

    
}

- (void)removeTrack:(NSDictionary *)track itemModel:(itemModel )itemModel{

    if (itemModel == historyItem) {
        
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"trackId == %li",[track[@"trackId"] integerValue]];
        
        NSArray *items = [self.historyMusic filteredArrayUsingPredicate:thePredicate];
        if (items.count == 1) {
            [self.managedObjectContext deleteObject:items[0]];
            [self.historyMusic removeObjectIdenticalTo:items[0]];
        }else{
            NSLog(@"historyMusic error");
        }
        
    }
    if (itemModel == favoritelItem) {
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"trackId == %li",[track[@"trackId"] integerValue]];
       
        NSArray *items = [self.favoriteMusic filteredArrayUsingPredicate:thePredicate];
        if (items.count == 1) {
            [self.managedObjectContext deleteObject:items[0]];
            [self.favoriteMusic removeObjectIdenticalTo:items[0]];
        }else{
            NSLog(@"favoriteMusic error");
        }

    }
    
}

- (BOOL)saveChanges{
    
    NSError *error;
    BOOL successful = [_managedObjectContext save:&error];//向NSManagedObjectContext发送save消息
    if (!successful){
        
        NSLog(@"Error saving:%@",[error localizedDescription]);
    }
    return successful;
    
}

-(void)moveItemAtIndex:(NSUInteger)fromIndex
               toIndex:(NSUInteger)toIndex tableID:(NSInteger )tableID{
    
}

#pragma mark - play

- (void)playWithModel:(TracksViewModel *)tracks indexPathRow:(NSInteger ) indexPathRow{
    
    _tracksVM = tracks;
    _rowNumber = self.tracksVM.rowNumber;
    _indexPathRow = indexPathRow;
    
    NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
    _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];

    if (_player.currentItem) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        });

    }else{
        
        _player = [AVPlayer playerWithPlayerItem:_currentPlayerItem];
    }

    __weak FYPlayManager *weakSelf = self;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        FYPlayManager *innerSelf = weakSelf;
        //控制中心
        [innerSelf updateLockedScreenMusic];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicTimeInterval" object:nil userInfo:nil];
        
    }];
    
    _isPlay = YES;
    [_player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentPlayerItem];
    [self setHistoryMusic];
    
}

#pragma mark - KVO

-(void)addNotification{
    
    //给AVPlayerItem添加播放完成通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];

}

//清空播放器监听属性
- (void)releasePlayer
{
    if (!self.currentPlayerItem) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeObserver:self forKeyPath:@"status"];
    
    self.currentPlayerItem = nil;
}

/** 监控播放状态 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayer *player = (AVPlayer *)object;
    
    if ([keyPath isEqualToString:@"status"]) {

        NSLog(@"当前状态——%ld",(long)[player status]);
        
    }
}


#pragma mark - 接收动作

- (void)pauseMusic{
    if (!self.currentPlayerItem) {
        return;
    }
    if (_player.rate) {
        _isPlay = NO;
        [_player pause];
        
    } else {
        _isPlay = YES;
        [_player play];
        
    }
    
}

- (void)previousMusic{
    
    if (_cycle == theSong) {
        [self playPreviousMusic];
    }else if(_cycle == nextSong){
        [self playPreviousMusic];
    }else if(_cycle == isRandom){
        [self randomMusic];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCoverURL" object:nil userInfo:userInfo];
}

- (void)nextMusic{
    
    if (_cycle == theSong) {
        [self playNextMusic];
    }else if(_cycle == nextSong){
        [self playNextMusic];
    }else if(_cycle == isRandom){
        [self randomMusic];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCoverURL" object:nil userInfo:userInfo];
}

- (void)nextCycle{
    
    NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
    if (defaults[@"cycle"]) {
        
        NSInteger cycleDefaults = [defaults[@"cycle"] integerValue];
        _cycle = cycleDefaults;
        
    }else{
        _cycle = theSong;
    }
}

- (void)setFavoriteMusic{
    
    NSDictionary *track = [self.tracksVM trackForRow:_indexPathRow];
    [self addTrack:track itemModel:favoritelItem];
}

- (void)delFavoriteMusic{
    
    NSDictionary *track = [self.tracksVM trackForRow:_indexPathRow];
    [self removeTrack:track itemModel:favoritelItem];
}

- (void)delMyFavoriteMusicDictionary:(NSDictionary *)track{
    
    [self removeTrack:track itemModel:favoritelItem];
}

- (void)delMyFavoriteMusic:(NSInteger )indexPathRow{
    
    NSDictionary *track = [self.tracksVM trackForRow:indexPathRow];
    [self removeTrack:track itemModel:favoritelItem];
}

- (void)setHistoryMusic{
    
    NSDictionary *track = [self.tracksVM trackForRow:_indexPathRow];
    [self addTrack:track itemModel:historyItem];
}

- (void)delMyHistoryMusic:(NSDictionary *)track{
    
    [self removeTrack:track itemModel:historyItem];
}

- (void)delAllHistoryMusic{
    
    for (FYhistoryItem *user in self.historyMusic) {
        
        [self.managedObjectContext deleteObject:user];
        
    }
    [self.historyMusic removeAllObjects];
}

- (void)delAllFavoriteMusic{
    
    for (FYfavoriteItem *user in self.favoriteMusic) {
        
        [self.managedObjectContext deleteObject:user];
        
    }
    [self.favoriteMusic removeAllObjects];
}


#pragma mark - 播放动作

-(void)playbackFinished:(NSNotification *)notification{
    
    if (_cycle == theSong) {
        [self playAgain];
    }else if(_cycle == nextSong){
        [self playNextMusic];
    }else if(_cycle == isRandom){
        [self randomMusic];
    }
    NSLog(@"开始下一首");
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCoverURL" object:nil userInfo:userInfo];
    
    _isPlay = YES;
    [_player play];
}

- (void)playPreviousMusic{
    
    if (_currentPlayerItem){
        
        if (_indexPathRow > 0) {
            _indexPathRow--;
        }else{
            _indexPathRow = _rowNumber-1;
        }

        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        [_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];


}

- (void)playNextMusic{
    
    if (_currentPlayerItem) {
        
        if (_indexPathRow < _rowNumber-1) {
            _indexPathRow++;
        }else{
            _indexPathRow = 0;
        }
        
        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        [_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];


}

- (void)randomMusic{
    
    if (_currentPlayerItem) {
        
        _indexPathRow = random()%_rowNumber;
        
        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        [_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];

}

-(void)playAgain{
    
    [_player seekToTime:CMTimeMake(0, 1)];
}

- (void)stopMusic{
    
}

#pragma mark - 返回

- (NSInteger )playerStatus{
    if (_currentPlayerItem.status == AVPlayerItemStatusReadyToPlay) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger )FYPlayerCycle{

    return _cycle;
}

- (NSString *)playMusicName{
    return [[self.tracksVM titleForRow: _indexPathRow] copy];

}

- (NSString *)playSinger{

    return [[self.tracksVM nickNameForRow: _indexPathRow] copy];

}

- (NSString *)playMusicTitle{

    return [[self.tracksVM albumTitle] copy];

}

- (NSURL *)playCoverLarge{

    return [[self.tracksVM coverLargeURLForRow: _indexPathRow] copy];
}

- (UIImage *)playCoverImage{
    
    UIImageView *imageCoverView = [[UIImageView alloc] init];
    [imageCoverView sd_setImageWithURL:[self playCoverLarge] placeholderImage:[UIImage imageNamed:@"music_placeholder"]];

    return [imageCoverView.image copy];
}

- (BOOL)hasBeenFavoriteMusic{
    
    for (FYfavoriteItem *item in self.favoriteMusic) {
        if (item.trackId == [self.tracksVM trackIdForRow:_indexPathRow]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)favoriteMusicItems{
    
    NSArray *items = [NSArray arrayWithArray:self.favoriteMusic];
    return [items copy];
}

- (NSArray *)historyMusicItems{
    
    NSArray *items = [NSArray arrayWithArray:self.historyMusic];
    return [items copy];
}

- (BOOL)havePlay{
    
    return _isPlay;
}

#pragma mark - 锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic{
    
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = [self playMusicName];
    // 歌手
    info[MPMediaItemPropertyArtist] = [self playSinger];
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = [self playMusicTitle];
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[self playCoverImage]];
    // 设置持续时间（歌曲的总时间）
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem duration])] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    // 切换播放信息
    center.nowPlayingInfo = info;
    
}

#pragma mark - 音效
//播放音效
- (void)playSound:(NSString *)filename{
    
    if (!filename){
        return;
    }
    
    //取出对应的音效ID
    SystemSoundID soundID = (int)[self.soundIDs[filename] unsignedLongValue];
    
    if (!soundID) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url){
            return;
        }
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);

        self.soundIDs[filename] = @(soundID);
    }
    
    // 播放
    AudioServicesPlaySystemSound(soundID);
}

//摧毁音效
- (void)disposeSound:(NSString *)filename{
    
    if (!filename){
        return;
    }
    
    SystemSoundID soundID = (int)[self.soundIDs[filename] unsignedLongValue];
    
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        
        [self.soundIDs removeObjectForKey:filename];    //音效被摧毁，那么对应的对象应该从缓存中移除
    }
}

/** 型号检测 */
-(void)iPhoneSysctlbyname {
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    NSLog(@"iPhone Device%@",[self platformType:platform]);
    
    free(machine);
}


- (NSString *) platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

@end
