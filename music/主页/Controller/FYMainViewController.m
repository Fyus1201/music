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

#import "FYMyViewController.h"

#define showLeftViewMaxWidth 10 //拖拽距离
#define maxWidth 240 //宽

@interface FYMainViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    CGPoint initialPosition;     //初始位置
    BOOL led;
}
@property(nonatomic,strong)LeftView *leftView;
@property(nonatomic,strong)UIView *backView;//蒙版
@property (nonatomic, strong) UITableView *mainTableView;

@property(nonatomic)UIScreenEdgePanGestureRecognizer *pan;

@end

@implementation FYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    

    [self initNav];
    [self initMainTableView];
    [self addGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}


- (void)initNav{
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2-22, 0, 80, 44)];

    navTitle.text = @"音乐";
    navTitle.font = [UIFont fontWithName:@".SFUIText-Semibold" size:18];
    
    [view addSubview:navTitle];
    self.navigationItem.titleView = view;
    
    //self.navigationItem.title = @"音乐";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    self.navigationController.navigationBar.translucent = NO;//是否为半透明
    
}
#pragma mark - 表格+下拉动画
- (void)initMainTableView{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowH) style:UITableViewStylePlain];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    led = NO;

    [self.mainTableView pm_RefreshHeaderWithBlock:^{
        
    }];
    [self.view addSubview:self.mainTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"你好啊";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FYMyViewController *web0 = [[FYMyViewController alloc]init];

    [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
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
    }
    return _leftView;
}
-(UIView *)backView{
    
    if (!_backView)
    {
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
    
    if (panGes.state == UIGestureRecognizerStateEnded)
    {
        if (point.x <= showLeftViewMaxWidth) {
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];
            
        }else if (point.x > showLeftViewMaxWidth && point.x <= maxWidth)
        {
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
        
        if ( - point.x <= showLeftViewMaxWidth) {
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, maxWidth, [[UIScreen mainScreen] bounds].size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            } completion:^(BOOL finished) {
                
            }];
            
        }else if ( - point.x > showLeftViewMaxWidth &&  - point.x <= maxWidth)
        {
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


@end
