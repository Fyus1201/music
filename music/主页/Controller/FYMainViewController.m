//
//  FYMainViewController.m
//  music
//
//  Created by 寿煜宇 on 16/4/21.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMainViewController.h"

#import "PMElasticRefresh.h"
#import "LeftView.h"

#import "NewContentViewModel.h"
#import "TracksViewModel.h"
#import "FYWebViewController.h"
#import "FYMainTableViewCell.h"

#import "FYPlayManager.h"

#define showLeftViewMaxWidth 10 //拖拽距离
#define maxWidth 240 //宽

@interface FYMainViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,FYMainTableViewDelegate,leftDelegate>
{
    CGPoint initialPosition;     //初始位置
}
@property(nonatomic,strong)LeftView *leftView;
@property(nonatomic,strong)UIView *backView;//蒙版
@property (nonatomic, strong) UITableView *mainTableView;

@property(nonatomic)UIScreenEdgePanGestureRecognizer *pan;
@property (nonatomic,strong) NewContentViewModel *contentVM;

@property (nonatomic) NSInteger tableInteger;
@property (nonatomic) NSInteger playInteger;

@end

@implementation FYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];

    [self initNav];
    [self initMainTableView];
    [self addGestureRecognizer];
    
    [self.contentVM getDataCompletionHandle:^(NSError *error) {
        [self.mainTableView reloadData];
    }];
    [self.mainTableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}


- (void)initNav{
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2-40, 0, 80, 44)];

    navTitle.text = @"竹影音乐";
    navTitle.font = [UIFont fontWithName:@".SFUIText-Semibold" size:18];
    
    [view addSubview:navTitle];
    self.navigationItem.titleView = view;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    self.navigationController.navigationBar.translucent = NO;//是否为半透明
    
}
#pragma mark - 表格+下拉动画
- (void)initMainTableView{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowH - 29) style:UITableViewStyleGrouped];
    
    [self.mainTableView pm_RefreshHeaderWithBlock:^{
        [self.contentVM getDataCompletionHandle:^(NSError *error) {
            [self.mainTableView reloadData];
            [self.mainTableView endRefresh];
        }];
    }];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.mainTableView registerClass:[FYMainTableViewCell class] forCellReuseIdentifier:@"MCell000"];

    [self.view addSubview:self.mainTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delTableInteger:) name:@"dejTableInteger" object:nil];
}

- (void)delTableInteger:(NSNotification *)notification {
    
    _tableInteger = 0;
    
    if (_playInteger > 0) {
        NSIndexSet *tableIndexSet=[[NSIndexSet alloc]initWithIndex:_playInteger - 1];
        [self.mainTableView reloadSections:tableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];//局部刷新
    }
    _playInteger = 0;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.contentVM rowNumber];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return s_WindowW * 1.2;
    
}

// 组头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.0001;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FYMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCell000"];
    
    [cell.coverIV sd_setImageWithURL:[self.contentVM coverURLForRow:indexPath.section] placeholderImage:[UIImage imageNamed:@"album_cover_bg"]];
    cell.titleLb.text = [self.contentVM trackTitleForRow:indexPath.section];
    cell.tagInt = indexPath.section;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == _tableInteger-1) {
        cell.isPlay = YES;
    }else{
        cell.isPlay = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)mainTableViewDidClick:(NSInteger)tag{
    
    if (tag >= 2000) {
        NSInteger tableTag = tag - 2000;
        NSInteger oldtableTag = _tableInteger;
        
        if (_tableInteger == tableTag + 1) {
            _tableInteger = 0;
            [[FYPlayManager sharedInstance] pauseMusic];
        }else{
            _tableInteger = tableTag + 1;
            
            if (_playInteger == tableTag + 1) {
                
                [[FYPlayManager sharedInstance] pauseMusic];
            }else{
                
                TracksViewModel *tracksVM = [[TracksViewModel alloc] initWithAlbumId:[self.contentVM albumIdForRow:tableTag] title:[self.contentVM titleForRow:tableTag] isAsc:YES];
                
                [tracksVM getDataCompletionHandle:^(NSError *error){
                    // 当前播放信息
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[@"coverURL"] = [tracksVM coverURLForRow:tableTag];
                    userInfo[@"musicURL"] = [tracksVM playURLForRow:tableTag];
                    
                    NSInteger indexPathRow = tableTag;
                    NSNumber *indexPathRown = [[NSNumber alloc]initWithInteger:indexPathRow];
                    userInfo[@"indexPathRow"] = indexPathRown;
                    //专辑
                    userInfo[@"theSong"] = tracksVM;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartPlay" object:nil userInfo:[userInfo copy]];
                }];
            }
            
            _playInteger = tableTag + 1;

        }

        NSIndexSet *tableIndexSet=[[NSIndexSet alloc]initWithIndex:tableTag];
        [self.mainTableView reloadSections:tableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];//局部刷新
        if (oldtableTag > 0) {
            NSIndexSet *tableIndexSet=[[NSIndexSet alloc]initWithIndex:oldtableTag - 1];
            [self.mainTableView reloadSections:tableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];//局部刷新
        }
        
    }else{
        NSInteger tableTag = tag - 1000;

        FYWebViewController *web0 = [[FYWebViewController alloc]init];
        NSURL *weburl = [self.contentVM urlForRow:tableTag];
        web0.URL = weburl;
        [self.navigationController pushViewController:web0 animated:YES];

    }
}


- (void)jumpWebVC:(NSURL *)url{
    
    FYWebViewController *web0 = [[FYWebViewController alloc]init];
    web0.URL = url;
    [self.navigationController pushViewController:web0 animated:YES];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        self.pan.enabled = YES;
        [_backView removeFromSuperview];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
}

#pragma mark - 手势

-(void)addGestureRecognizer{
    
    self.pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    self.pan.delegate = self;
    self.pan.edges = UIRectEdgeLeft;//左侧
    [self.view addGestureRecognizer:self.pan];
}

-(UIView *)leftView{
    
    if (!_leftView) {
        _leftView = [[LeftView alloc]initWithFrame:CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height)];
        _leftView.delegate = self;//设置代理
    }
    return _leftView;
}


-(UIView *)backView{
    
    if (!_backView){
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        UIPanGestureRecognizer *backPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(backPanGes:)];
        [_backView addGestureRecognizer:backPan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapGes:)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

-(void)panGesture:(UIScreenEdgePanGestureRecognizer *)ges{
    
    [self dragLeftView:ges];
}

-(void)dragLeftView:(UIPanGestureRecognizer *)panGes{
    
    [_leftView removeFromSuperview];
    [_backView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backView];
    [window addSubview:self.leftView];
    
    if (panGes.state == UIGestureRecognizerStateBegan) {

        initialPosition.x = self.leftView.center.x;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }
    
    CGPoint point = [panGes translationInView:self.view];
    
    if (point.x >= 0 && point.x <= maxWidth) {
        _leftView.center = CGPointMake(initialPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (maxWidth + point.x) / (2* maxWidth) - 0.5);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (panGes.state == UIGestureRecognizerStateEnded){
        if (point.x <= showLeftViewMaxWidth) {
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];
            
        }else if (point.x > showLeftViewMaxWidth && point.x <= maxWidth){
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

-(void)backPanGes:(UIPanGestureRecognizer *)ges{
    
    if (ges.state == UIGestureRecognizerStateBegan) {

        initialPosition.x = self.leftView.center.x;
    }
    
    CGPoint point = [ges translationInView:self.view];
    
    if (point.x <= 0 && point.x <= maxWidth) {
        _leftView.center = CGPointMake(initialPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (maxWidth + point.x) / (2* maxWidth));
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded){
        
        if ( -point.x <= 50) {
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            } completion:^(BOOL finished) {
                
            }];
            
        }else {
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];
        }
    }
    
}
-(void)backViewTapGes:(UITapGestureRecognizer *)ges{
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        self.pan.enabled = YES;
        [_backView removeFromSuperview];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
    
}



#pragma mark - VM,tableView懒加载
- (NewContentViewModel *)contentVM {
    if (!_contentVM) {
        
        _contentVM = [[NewContentViewModel alloc] init];
    }
    return _contentVM;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"delloc");
}

@end
