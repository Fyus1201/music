//
//  FYBarController.m
//  music
//
//  Created by 寿煜宇 on 16/5/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYBarController.h"

#import "FYMainViewController.h"
#import "FYTuiViewController.h"
#import "FYMyViewController.h"
#import "FYMainPlayController.h"

#import "FYNavigationController.h"
#import "TracksViewModel.h"
#import "FYPlayView.h"//播放图标
#import "FYPlayManager.h"//播放器

@interface FYBarController ()<PlayViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) TracksViewModel *tracksVM;

@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,assign) NSInteger rowNumber;

@property (nonatomic,strong) FYPlayView *playView;
@property (nonatomic,strong) NSString *imageName;

@end

@implementation FYBarController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTabBarController];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBarController{

    FYMainViewController *item0 = [[FYMainViewController alloc]init];
    [self controller:item0 title:@"主页" image:@"tab_icon_selection_normal" selectedimage:@"tab_icon_selection_highlight"];
    
    FYTuiViewController *item1 = [[FYTuiViewController alloc]init];
    [self controller:item1 title:@"推荐" image:@"icon_tab_shouye_normal" selectedimage:@"icon_tab_shouye_highlight"];
    
    FYTuiViewController *item2 = [[FYTuiViewController alloc]init];
    [self controller:item2 title:@"" image:@"" selectedimage:@""];
    
    //设置tabbar的颜色
    self.tabBar.barTintColor = [UIColor whiteColor];
    //设置tabbaritem被选中时的颜色
    self.tabBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
    [self setSelectedIndex:0];
    
    /*播放器*/
    self.playView = [[FYPlayView alloc] init];
    [self addNotification];
    
    self.playView.delegate = self;
    [self.view addSubview:_playView];
    
    [_playView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo([[UIScreen mainScreen] bounds].size.width/3);
        make.height.mas_equalTo(70);
        
        make.right.equalTo(self.view).with.offset(0);
    }];
    
}

//初始化一个zi控制器
-(void)controller:(UIViewController *)TS title:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage{
    
    TS.tabBarItem.title = title;
    if ([image  isEqual: @""]) {
        
    }else{
        TS.tabBarItem.image = [UIImage imageNamed:image];
        TS.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:TS];
    nav.delegate = self;
    [self addChildViewController:nav];
}

#pragma mark - PlayView的代理方法
- (void)playButtonDidClick:(NSInteger)index {
    
    if ([[FYPlayManager sharedInstance] playerStatus]) {
        FYMainPlayController *mainPlay = [[FYMainPlayController alloc]initWithNibName:@"FYMainPlayController" bundle:nil];

        [self presentViewController: mainPlay animated:YES completion:nil];
    }else{
        [self showMiddleHint:@"当前没有歌曲"];
    }

}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    
    if (viewController.hidesBottomBarWhenPushed) {
        
        if(self.tabBar.frame.origin.y == [[UIScreen mainScreen] bounds].size.height - 49){
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 CGRect tabFrame = self.tabBar.frame;
                                 tabFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
                                 self.tabBar.frame = tabFrame;
                             }];
            self.tabBar.hidden = YES;
        }
        //self.playView.hidden = YES;
        
    } else {

    }
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{

    if (viewController.hidesBottomBarWhenPushed) {

    } else {

        if(self.tabBar.frame.origin.y == [[UIScreen mainScreen] bounds].size.height ){

            [UIView animateWithDuration:0.2
                             animations:^{
                                 CGRect tabFrame = self.tabBar.frame;
                                 tabFrame.origin.y += -49;
                                 self.tabBar.frame = tabFrame;
                             }];
            
            self.tabBar.hidden = NO;

        }
        //self.playView.hidden = YES;
    }
    [super.view bringSubviewToFront:self.playView];
}

- (void)hideTabBar {
    self.playView.hidden = NO;
}

- (void)showTabBar{
    self.playView.hidden = YES;
}
/** 添加通知 */
-(void)addNotification{
    // 开启两个通知接收,控制PlayView显示
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePlayView:) name:@"hidePlayView" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPlayView:) name:@"showPlayView" object:nil];
    
    // 开启一个通知接受,开始播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingWithInfoDictionary:) name:@"BeginPlay" object:nil];
    //当前歌曲改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCoverURL:) name:@"changeCoverURL" object:nil];

}

#pragma mark - 消息中心
// 隐藏图片
- (void)hidePlayView:(NSNotification *)notification{
    self.playView.hidden = YES;
}

// 显示图片
- (void)showPlayView:(NSNotification *)notification{
    self.playView.hidden = NO;
}

/** 通过播放地址 和 播放图片 */
- (void)playingWithInfoDictionary:(NSNotification *)notification {
   
    // 设置背景图
    NSURL *coverURL = notification.userInfo[@"coverURL"];
    
    _tracksVM = notification.userInfo[@"theSong"];
    _indexPathRow = [notification.userInfo[@"indexPathRow"] integerValue];
    _rowNumber = self.tracksVM.rowNumber;
    
    
    /** 动画 */
    CGFloat y = [notification.userInfo[@"originy"] floatValue];
    CGRect rect = CGRectMake(10, y+80, 50, 50);

    CGFloat moveX = s_WindowW -68;
    CGFloat moveY = s_WindowH - rect.origin.y-60;
    
    NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970]*1000;
    NSInteger imTag = (long)nowTime%(3600000*24);
    
    UIImageView * sImgView = [[UIImageView alloc]initWithFrame:rect];
    sImgView.tag = imTag;
    [sImgView sd_setImageWithURL:coverURL];
    [self.view addSubview:sImgView];
    sImgView.layer.cornerRadius = 22;
    sImgView.clipsToBounds = YES;
    
    
    //组动画之修改透明度
    CABasicAnimation * alphaBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    alphaBaseAnimation.duration = moveX/800;
    alphaBaseAnimation.removedOnCompletion = NO;
    [alphaBaseAnimation setToValue:[NSNumber numberWithFloat:0.0]];
    alphaBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//决定动画的变化节奏
    
    //组动画之缩放动画
    CABasicAnimation * scaleBaseAnimation = [CABasicAnimation animation];
    scaleBaseAnimation.removedOnCompletion = NO;
    scaleBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    scaleBaseAnimation.duration = moveX/800;
    scaleBaseAnimation.keyPath = @"transform.scale";
    scaleBaseAnimation.toValue = @0.3;
    
    //组动画之路径变化
    CGMutablePathRef path = CGPathCreateMutable();//创建一个路径
    CGPathMoveToPoint(path, NULL, sImgView.center.x, sImgView.center.y);
    
    CGPathAddQuadCurveToPoint(path, NULL, sImgView.center.x+moveX/12, sImgView.center.y-80, sImgView.center.x+moveX/12*2, sImgView.center.y);
    
    CGPathAddLineToPoint(path,NULL,sImgView.center.x+moveX/12*4,sImgView.center.y+moveY/8);
    
    CGPathAddLineToPoint(path,NULL,sImgView.center.x+moveX/12*6,sImgView.center.y+moveY/8*3);
    
    CGPathAddLineToPoint(path,NULL,sImgView.center.x+moveX,sImgView.center.y+moveY);
    
    
    CAKeyframeAnimation * frameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];

    frameAnimation.duration = 5*moveX/800;

    frameAnimation.removedOnCompletion = NO;
    frameAnimation.fillMode = kCAFillModeForwards;
    
    [frameAnimation setPath:path];
    CFRelease(path);
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    
    animGroup.animations = @[alphaBaseAnimation,scaleBaseAnimation,frameAnimation];
    animGroup.duration = moveX/800;
    animGroup.fillMode = kCAFillModeForwards;//不恢复原态
    animGroup.removedOnCompletion = NO;
    [sImgView.layer addAnimation:animGroup forKey:[NSString stringWithFormat:@"%ld",(long)imTag]];
    
    NSDictionary * dic = @{
                           @"animationGroup":sImgView,
                           @"coverURL":coverURL,
                           };
    
    
    NSTimer * t = [NSTimer scheduledTimerWithTimeInterval:animGroup.duration target:self selector:@selector(endPlayImgView:) userInfo:dic repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:t forMode:NSRunLoopCommonModes];

}

- (void)endPlayImgView:(NSTimer *)timer{

    //NSLog(@"%@",timer.userInfo);
    
    UIImageView * imgView = (UIImageView *)[timer.userInfo objectForKey:@"animationGroup"];
    
    if (imgView) {
        [imgView removeFromSuperview];
        imgView = nil;
    }
    
    // 设置背景图
    NSURL *coverURL = timer.userInfo[@"coverURL"];
    
    [self.playView.contentIV sd_setImageWithURL:coverURL];
    self.playView.contentIV.alpha = 0.0;

    //修改透明度
    CABasicAnimation * alphaBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    alphaBaseAnimation.duration = 1.0;
    alphaBaseAnimation.removedOnCompletion = NO;
    [alphaBaseAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    alphaBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//决定动画的变化节奏

    [self.playView.contentIV.layer addAnimation:alphaBaseAnimation forKey:[NSString stringWithFormat:@"%ld",(long)self.playView.contentIV]];
    
    FYPlayManager *playmanager = [FYPlayManager sharedInstance];
    [playmanager playWithModel:_tracksVM indexPathRow:_indexPathRow];
    

    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}

- (void)changeCoverURL:(NSNotification *)notification {

    // 设置背景图
    NSURL *coverURL = notification.userInfo[@"coverURL"];
    
    [self.playView.contentIV sd_setImageWithURL:coverURL];
    self.playView.contentIV.alpha = 0.0;
    
    //修改透明度
    CABasicAnimation * alphaBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    alphaBaseAnimation.duration = 1.0;
    alphaBaseAnimation.removedOnCompletion = NO;
    [alphaBaseAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    alphaBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//决定动画的变化节奏
    
    [self.playView.contentIV.layer addAnimation:alphaBaseAnimation forKey:[NSString stringWithFormat:@"%ld",(long)self.playView.contentIV]];
    
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

- (void)dealloc {
    // 关闭消息中心
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[FYPlayManager sharedInstance] releasePlayer];
}


@end
