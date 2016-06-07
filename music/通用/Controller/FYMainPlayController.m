//
//  FYMainPlayController.m
//  music
//
//  Created by 寿煜宇 on 16/5/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMainPlayController.h"
#import "MusicSlider.h"
#import <AVFoundation/AVFoundation.h>

#import "NSString+FYString.h"
#import "UIView+FYAnimations.h"

#import "FYPlayManager.h"

@import AVFoundation;
@interface FYMainPlayController ()

/*背景*/
@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroudView;

/*最上行*/
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

/*中心图片*/
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumImageLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumImageRightConstraint;

/*收藏行*/
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;

/*进度条*/
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet MusicSlider *musicSlider;

/*最下行按钮*/
@property (weak, nonatomic) IBOutlet UIButton *musicCycleButton;
@property (weak, nonatomic) IBOutlet UIButton *previousMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *musicToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *nextMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
//@property (nonatomic) NSTimer *musicDurationTimer;
@property (nonatomic) BOOL musicIsPlaying;
@property (nonatomic) BOOL musicIsChange;
@property (nonatomic) BOOL musicIsCan;
@property (nonatomic) BOOL newItem;

@property (nonatomic) FYPlayerCycle  cycle;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSTimeInterval total;

@property (nonatomic,strong) AVPlayer *player;

@end

@implementation FYMainPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self adapterIphone4];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //初始化UI
    FYPlayManager *playmanager = [FYPlayManager sharedInstance];
    _player = playmanager.player;
    
    _cycle = [playmanager FYPlayerCycle];
    switch (_cycle) {
        case theSong:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            break;
        case nextSong:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            break;
        case isRandom:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    //判断
    _musicNameLabel.text = [playmanager playMusicName];
    _musicTitleLabel.text = [playmanager playMusicTitle];
    _singerLabel.text = [playmanager playSinger];
    [self setupBackgroudImage:[playmanager playCoverLarge]];
    
    CMTime time = self.player.currentTime;
    [self updateProgressLabelCurrentTime:CMTimeGetSeconds(time) duration:CMTimeGetSeconds([_player.currentItem duration])];
    [self addObserverToPlayer:_player];
    
    if (_player.rate) {
        self.musicIsPlaying = YES;
    } else {
        self.musicIsPlaying = NO;
    }
    
    AVPlayerItem *theItem=_player.currentItem;
    _total = CMTimeGetSeconds([theItem duration]);
    
    __weak FYMainPlayController *weakSelf = self;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        FYMainPlayController *innerSelf = weakSelf;
        NSTimeInterval current=CMTimeGetSeconds(time);
        
        if (_newItem == YES) {
            AVPlayerItem *newItem=innerSelf.player.currentItem;
            if (!isnan(CMTimeGetSeconds([newItem duration]) )) {
                
                innerSelf.total = CMTimeGetSeconds([newItem duration]);
                _newItem = NO;
            }
        }

        [innerSelf updateProgressLabelCurrentTime:current duration:innerSelf.total];
    }];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

#pragma mark - KVO
/** 给AVPlayer添加监控 */
-(void)addObserverToPlayer:(AVPlayer *)player{

    [player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [player addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserverFromPlayer:(AVPlayer *)player{
    [player removeObserver:self forKeyPath:@"rate"];
    [player removeObserver:self forKeyPath:@"currentItem"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"rate"]) {
        AVPlayerStatus rate= [[change objectForKey:@"new"] intValue];
        //判断暂停/播放
        if (rate) {
            self.musicIsPlaying = YES;
        } else {
            self.musicIsPlaying = NO;
        }
    }else if ([keyPath isEqualToString:@"currentItem"]) {
        
        FYPlayManager *playmanager = [FYPlayManager sharedInstance];

        _musicNameLabel.text = [playmanager playMusicName];
        _musicTitleLabel.text = [playmanager playMusicTitle];
        _singerLabel.text = [playmanager playSinger];
        [self setupBackgroudImage:[playmanager playCoverLarge]];
        
        _newItem = YES;
    }
}

#pragma mark - 初始化
/** 调整大小 */
- (void)adapterIphone4 {
    if (s_isPhone4) {
        CGFloat margin = 65;
        _albumImageLeftConstraint.constant = margin;
        _albumImageRightConstraint.constant = margin;
    }
}

- (void)setupBackgroudImage:(NSURL *)imageUrl {
    _albumImageView.layer.cornerRadius = 7;
    _albumImageView.layer.masksToBounds = YES;
    
    [_backgroudImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    [_albumImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    
    if(![_visualEffectView isDescendantOfView:_backgroudView]) {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _visualEffectView.frame = CGRectMake(0, 0, s_WindowW, s_WindowH);
        [_backgroudView addSubview:_visualEffectView];
    }
    
    [_backgroudImageView startTransitionAnimation];
    [_albumImageView startTransitionAnimation];
}

- (void)setMusicIsPlaying:(BOOL)musicIsPlaying {
    _musicIsPlaying = musicIsPlaying;
    if (_musicIsPlaying) {
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
        
    } else {
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
    }
}

- (void)updateProgressLabelCurrentTime:(NSTimeInterval )currentTime duration:(NSTimeInterval )duration {
    _beginTimeLabel.text = [NSString timeIntervalToMMSSFormat:currentTime];
    _endTimeLabel.text = [NSString timeIntervalToMMSSFormat:duration];
    
    if (_musicIsCan == YES) {
        
        CGFloat currentTimef = currentTime;
        int currentTimei = currentTime;
        if (currentTimef == currentTimei) {
            _musicIsCan = NO;
        }

    }
    
    if (_musicIsChange == NO && _musicIsCan == NO) {
        
        [_musicSlider setValue:currentTime / duration animated:YES];
    }
}

/** 播放按钮 */
- (IBAction)didTouchMusicToggleButton:(id)sender {

    if (_player.status) {
        if (_player.rate) {
            [_player pause];
        } else {
            [_player play];
        }
    }else{
        [self showMiddleHint:@"当前没有音乐"];
    }

}
- (IBAction)didTouchCycle:(id)sender {
    
    if (_cycle < 3) {
        _cycle++;
    }else{
        _cycle = 1;
    }
    NSNumber *userCycle = [NSNumber numberWithInt:_cycle];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userCycle forKey:@"cycle"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"nextCycle" object:nil userInfo:nil];
    
    switch (_cycle) {
        case theSong:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            [self showMiddleHint:@"单曲循环"];
            break;
        case nextSong:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            [self showMiddleHint:@"顺序循环"];
            break;
        case isRandom:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            [self showMiddleHint:@"随机循环"];
            break;
            
        default:
            break;
    }
    
}
/** 更多按钮 */
- (IBAction)didTouchMoreButton:(id)sender {
    
    NSLog(@"%f",_player.rate);
    AVPlayerItem *theItem=_player.currentItem;
    _total = CMTimeGetSeconds([theItem duration]);
    NSLog(@"%f",_total);
    
    NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSLog(@"Defaults: %@", defaults[@"cycle"]);
}

- (IBAction)playPreviousMusic:(id)sender {

    if (_player.status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"previousMusic" object:nil userInfo:nil];
    }else{
        [self showMiddleHint:@"当前没有音乐"];
    }

}

- (IBAction)playNextMusic:(id)sender {
    
    if (_player.status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextMusic" object:nil userInfo:nil];
    }else{
        [self showMiddleHint:@"当前没有音乐"];
    }

}

- (IBAction)closePlay:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//拖动条
- (IBAction)changeMusicTime:(id)sender {
    _musicIsChange = YES;
    
}
- (IBAction)setMusicTime:(id)sender {
    
    CGFloat endTime = CMTimeGetSeconds([_player.currentItem duration]);
    NSInteger dragedSeconds = floorf(self.musicSlider.value * endTime);

    //转换成CMTime才能给player来控制播放进度
    [[self player] seekToTime:CMTimeMakeWithSeconds(dragedSeconds, 1)];
    
    _musicIsChange = NO;
    _musicIsCan = YES;
}
- (IBAction)noChangeMusic:(id)sender {
    _musicIsChange = NO;
}

# pragma mark - HUD

- (void)showMiddleHint:(NSString *)hint {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)dealloc{

    [self removeObserverFromPlayer:_player];
    NSLog(@"dealloc");
}

@end
