//
//  FYPlayManager.m
//  music
//
//  Created by 寿煜宇 on 16/6/3.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYPlayManager.h"
#import "TracksViewModel.h"

@interface FYPlayManager ()

@property (nonatomic) FYPlayerCycle  cycle;

@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;
@property (nonatomic, strong) NSMutableDictionary *favoriteMusic;
@property (nonatomic, strong) NSMutableDictionary *historyMusic;

@property (nonatomic) BOOL isLocalVideo; //是否播放本地文件
@property (nonatomic) BOOL isFinishLoad; //是否下载完毕

@property (nonatomic, strong) NSMutableDictionary *soundIDs;

@property (nonatomic,strong) TracksViewModel *tracksVM;
@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,assign) NSInteger rowNumber;

@end

static FYPlayManager *_instance = nil;

@implementation FYPlayManager


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    __block FYPlayManager *temp = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((temp = [super init]) != nil) {
            _favoriteMusic = [NSMutableDictionary dictionary];
            _historyMusic = [NSMutableDictionary dictionary];
            
            _soundIDs = [NSMutableDictionary dictionary];
            
            NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
            
            if (defaults[@"cycle"]){
                
                NSInteger cycleDefaults = [defaults[@"cycle"] integerValue];
                _cycle = cycleDefaults;

            }else{
                _cycle = theSong;
            }

            // 支持后台播放
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            // 激活
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        }
    });
    self = temp;
    return self;
}

-(void)addNotification{
    
    // 开启两个个通知接受,上一首与下一首
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(previousMusic:) name:@"previousMusic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextMusic:) name:@"nextMusic" object:nil];
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    //模式切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextCycle:) name:@"nextCycle" object:nil];

}

//清空播放器监听属性
- (void)releasePlayer
{
    if (!self.currentPlayerItem) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.currentPlayerItem = nil;
}

- (void)playWithModel:(TracksViewModel *)tracks indexPathRow:(NSInteger ) indexPathRow{
    
    _tracksVM = tracks;
    _rowNumber = self.tracksVM.rowNumber;
    _indexPathRow = indexPathRow;
    
    NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
    _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
    if (_player.currentItem) {
        
        [_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        
    }else{
        
        _player = [AVPlayer playerWithPlayerItem:_currentPlayerItem];
    }

    [self addNotification];
    [_player play];
    
}

- (void)pauseMusic{
    if (!self.currentPlayerItem) {
        return;
    }
    if (_player.rate) {
        [_player pause];
    } else {
        [_player play];
    }
}

#pragma mark - 通知

- (void)previousMusic:(NSNotification *)notification{
    
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

- (void)nextMusic:(NSNotification *)notification{
    
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

-(void)playbackFinished:(NSNotification *)notification{
    
    if (_cycle == theSong) {
        [self playAgain];
    }else if(_cycle == nextSong){
        [self playNextMusic];
    }else if(_cycle == isRandom){
        [self randomMusic];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCoverURL" object:nil userInfo:userInfo];
    
}

- (void)nextCycle:(NSNotification *)notification{
    
    NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
    if (defaults[@"cycle"]) {
        
        NSInteger cycleDefaults = [defaults[@"cycle"] integerValue];
        _cycle = cycleDefaults;
        
    }else{
        _cycle = theSong;
    }

}

#pragma mark - 播放动作

- (void)playPreviousMusic{
    
    if (_player.currentItem){
        
        if (_indexPathRow > 0) {
            _indexPathRow--;
        }else{
            _indexPathRow = _rowNumber-1;
        }

        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        [_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        
    }
    if (!_player.rate) {
        [_player play];
    }

}

- (void)playNextMusic{
    
    if (_player.currentItem) {
        
        if (_indexPathRow < _rowNumber-1) {
            _indexPathRow++;
        }else{
            _indexPathRow = 0;
        }
        
        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        [_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        
    }
    if (!_player.rate) {
        [_player play];
    }

}

- (void)randomMusic{
    
    if (_player.currentItem) {
        
        _indexPathRow = random()%_rowNumber;
        
        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        [_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        
    }
    if (!_player.rate) {
        [_player play];
    }
}

-(void)playAgain{
    
    [_player seekToTime:CMTimeMake(0, 1)];
    if (!_player.rate) {
        [_player play];
    }
    
}

- (void)stopMusic{
    
}

#pragma mark - 返回

- (NSInteger )playerStatus{
    if (!self.currentPlayerItem) {
        return 0;
    }else{
        return 1;
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

@end
