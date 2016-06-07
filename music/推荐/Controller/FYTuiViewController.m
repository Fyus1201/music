//
//  FYTuiViewController.m
//  music
//
//  Created by 寿煜宇 on 16/4/21.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYTuiViewController.h"
#import "FYTuiScrollView.h"

#import "PMElasticRefresh.h"

/*推荐页*/
#import "MoreContentViewModel.h"

#import "FYiCarouselView.h"
#import "FYTitleViewCell.h"
#import "FYMoreCategoryCell.h"
/**分类页*/
#import "FYCategoryTableCell.h"
#import "FYCategoryViewController.h"
/**详情页*/
#import "FYSongViewController.h"

#import "FYMyViewController.h"


@interface FYTuiViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)FYTuiScrollView *scroll;

@property(nonatomic,strong)UIButton *button0;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;

@property(nonatomic,strong)UIView *leftView;

/** 页面 */
@property (nonatomic,strong) UITableView *tableView0;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;

@property (nonatomic,strong) MoreContentViewModel *moreVM;
@property (nonatomic,strong) FYiCarouselView *scrollView;
@property (nonatomic,strong) NSMutableArray *KNamel;

@end

@implementation FYTuiViewController
{
    UIPageControl *_pageControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];

    [self initUI];
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (_tableView0.frame.size.height == self.view.frame.size.height-64) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             _tableView0.frame = CGRectMake(self.view.frame.size.width * 0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49);
                             _tableView1.frame = CGRectMake(self.view.frame.size.width * 1, 0, self.view.frame.size.width, self.view.frame.size.height-64-49);
                             _tableView2.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.view.frame.size.height-64-49);
                         }];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    

    if (_tableView0.frame.size.height == self.view.frame.size.height-64-49) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             _tableView0.frame = CGRectMake(self.view.frame.size.width * 0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
                             _tableView1.frame = CGRectMake(self.view.frame.size.width * 1, 0, self.view.frame.size.width, self.view.frame.size.height-64);
                             _tableView2.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.view.frame.size.height-64);
                         }];
    }
    

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
#pragma mark - 初始设置
-(void)initUI
{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, 40)];

    [view addSubview:self.button0];
    [view addSubview:self.button1];
    [view addSubview:self.button2];
    
    self.navigationItem.titleView = view;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scroll];
    [self initTableView];
    
    [self.moreVM getDataCompletionHandle:^(NSError *error) {
        
        // 封装好的头部滚动视图
        _scrollView = [[FYiCarouselView alloc] initWithFocusImgMdoel:self.moreVM];
        _tableView1.tableHeaderView = self.scrollView.iView;
        
        __weak FYTuiViewController *weakSelf = self;
        _scrollView.clickAction = ^(NSInteger index){

            FYTuiViewController *innerSelf = weakSelf;
            if ([innerSelf.moreVM focusForIndex:index] == 2) {
                [innerSelf didSelectFocusImages2:index];
            }else {
                [innerSelf didSelectFocusImages3:index];
            }
            
            
        };
        _KNamel = [[NSMutableArray alloc] initWithArray:[self.moreVM tagsArrayForSection]];
        
        [_tableView1 reloadData];
        [_tableView2 reloadData];
    }];

}
-(UIScrollView *)scroll{
    
    if (!_scroll){
        _scroll = [[FYTuiScrollView alloc]initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scroll.contentSize = CGSizeMake(self.view.frame.size.width * 3, 0);
        
        _scroll.pagingEnabled = YES;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.delegate = self;
        _scroll.bounces = NO;
        self.scroll.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        _scroll.alwaysBounceVertical = NO;
    }
    return _scroll;
}
-(void)initTableView{
    
    for (int i = 0; i < 3; i ++ ){
        if(i == 0){
            
            _tableView0 = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStyleGrouped];
            
            _tableView0.tag = 100 + i;
            _tableView0.delegate = self;
            _tableView0.dataSource = self;
            
            _tableView0.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
            
            [self.scroll addSubview:_tableView0];
            
        }else if (i == 1) {
            
            _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStyleGrouped];
            
            _tableView1.tag = 100 + i;
            _tableView1.delegate = self;
            _tableView1.dataSource = self;

            [_tableView1 registerClass:[FYMoreCategoryCell class] forCellReuseIdentifier:@"MCell101"];
            
            _tableView1.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
            
            [_tableView1 pm_RefreshHeaderWithBlock:^{
                
                [self.moreVM getDataCompletionHandle:^(NSError *error) {

                    [_tableView1 reloadData];
                    [_scrollView.carousel reloadData];
                    [_tableView1 endRefresh];
 
               }];
    
            }];
            

            [self.scroll addSubview:_tableView1];
        }else{
            _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStyleGrouped];
            
            _tableView2.tag = 100 + i;
            _tableView2.delegate = self;
            _tableView2.dataSource = self;
            
            [_tableView2 registerClass:[FYCategoryTableCell class] forCellReuseIdentifier:@"MCell201"];
            
            _tableView2.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
            
            [self.scroll addSubview:_tableView2];
        }

    }
    
}
-(UIButton *)button0{
    
    if (!_button0){
        
        _button0 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button0.frame = CGRectMake(self.view.frame.size.width/2-150, 0, 80, 44);

        [_button0 setTitle:@"我的" forState:UIControlStateNormal];
        _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        [_button0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_button0 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _button0.tag = 1000;
    }
    return _button0;
}
-(UIButton *)button1{
    
    if (!_button1){
        
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame = CGRectMake(self.view.frame.size.width/2-50 , 0, 80, 44);
        [_button1 setTitle:@"推荐" forState:UIControlStateNormal];
        _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
        [_button1 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _button1.tag = 1001;
    }
    return _button1;
}
-(UIButton *)button2{
    
    if (!_button2){
        
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(self.view.frame.size.width/2+50, 0, 80, 44);
        [_button2 setTitle:@"乐库" forState:UIControlStateNormal];
        _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        [_button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _button2.tag = 1002;
    }
    return _button2;
}

/** 滑动 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@",[scrollView class]];
    if ([str isEqualToString:@"FYTuiScrollView"]){
        if (scrollView.contentOffset.x == 0){
            
            [_tableView0 reloadData];

            [self.button0 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
            [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
            _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            
        }else if (scrollView.contentOffset.x == self.view.frame.size.width){
            
            [_tableView1 reloadData];
            [_scrollView.carousel reloadData];
            
            [self.button0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.button1 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
            _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            
        }else {
            
            [_tableView2 reloadData];

            [self.button0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
            
            _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
            
        }
    }
    
    
}
-(void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == 1000){
        
        [_tableView0 reloadData];

        [self.scroll setContentOffset:CGPointMake(0, -64) animated:YES];
        
        [self.button0 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
        [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
        _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        
    }else if (btn.tag == 1001){
        
        [_tableView1 reloadData];
        [_scrollView.carousel reloadData];
        
        [self.scroll setContentOffset:CGPointMake(self.view.frame.size.width, -64) animated:YES];
        
        [self.button0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.button1 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
        _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        
    }else{
        
        [_tableView2 reloadData];

        [self.scroll setContentOffset:CGPointMake(self.view.frame.size.width*2, -64) animated:YES];
        
        [self.button0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
        
        _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 表格

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (tableView.tag == 100) {
        return 6;
    }else if(tableView.tag == 101){
        return self.moreVM.sectionNumber;
    }else{
        return _KNamel.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 100) {
        return 1;
    }else if(tableView.tag == 101){
        return [self.moreVM rowForSection:section];
    }else{
        return 1;
    }

}

// 制作表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView.tag == 100) {
        return nil;
    }else if(tableView.tag == 101){
        return !section ? nil : [[FYTitleViewCell alloc] initWithTitle:[self.moreVM mainTitleForSection:section] hasMore:[self.moreVM hasMoreForSection:section] titleTag:section];
    }else{
        return nil;
    }
    
    
}

// 组头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView.tag == 100) {
        return 10;
    }else if(tableView.tag == 101){
         return !section ? 0: 35;
    }else{
        return 10;
    }
}

// 组尾高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (tableView.tag == 100) {
        return 10;
    }else if(tableView.tag == 101){
        return 10;
    }else{
        return 10;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        return 200;
    }else if(tableView.tag == 101){
        return 70;
    }else{
        return self.view.frame.size.width*0.4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 100) {
        
        static NSString *cellID = @"cell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = @"好啊";
        return cell;

        
    }else if(tableView.tag == 101){
        
        if (indexPath.section == 0) {
            
            static NSString *cellID = @"TCell101";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            
            
            [cell.imageView sd_setImageWithURL:[self.moreVM coverURLForIndexPath:indexPath] placeholderImage:[UIImage imageNamed:@"find_albumcell_cover_bg"]];
            
            cell.textLabel.text = [self.moreVM titleForIndexPath:indexPath];
            cell.detailTextLabel.text = [self.moreVM subTitleForIndexPath:indexPath];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;

        } else {
            
            
            FYMoreCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCell101"];
            [cell.coverBtn setImageForState:UIControlStateNormal withURL:[self.moreVM coverURLForIndexPath:indexPath] placeholderImage:[UIImage imageNamed:@"find_albumcell_cover_bg"]];
            cell.titleLb.text = [self.moreVM titleForIndexPath:indexPath];
            cell.introLb.text = [self.moreVM subTitleForIndexPath:indexPath];
            cell.playsLb.text = [self.moreVM playsForIndexPath:indexPath];
            cell.tracksLb.text = [self.moreVM tracksForIndexPath:indexPath];
            return cell;

        }


    }else if(tableView.tag == 102){

        FYCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCell201"];
        [cell setTitle:_KNamel[indexPath.section]];
        
        return cell;
        
    }else{
        static NSString *cellID = @"cell111";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = @"无法显示";
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 100) {
        FYMyViewController *web0 = [[FYMyViewController alloc]init];
        
        [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
    }else if(tableView.tag == 101){

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        // 从本控制器VM获取头标题, 以及分类ID回初始化
        FYSongViewController *vc = [[FYSongViewController alloc] initWithAlbumId:[self.moreVM albumIdForIndexPath:indexPath] title:[self.moreVM titleForIndexPath:indexPath]];

        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(tableView.tag == 102){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        FYCategoryViewController *vc = [[FYCategoryViewController alloc] init];
        vc.keyName = _KNamel[indexPath.section];
        
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}

/** 跳转 */
- (void)didSelectFocusImages2:(NSInteger )index{
    
    FYSongViewController *vc = [[FYSongViewController alloc] initWithAlbumId:[self.moreVM albumIdForIndex:index] title:[self.moreVM titleForIndex:index]];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didSelectFocusImages3:(NSInteger )index{
    
    FYCategoryViewController *vc = [[FYCategoryViewController alloc] init];
    vc.keyName = @"榜单";
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (MoreContentViewModel *)moreVM {
    if (!_moreVM) {
        _moreVM = [[MoreContentViewModel alloc] initWithCategoryId:2 contentType:@"album"];
    }
    return _moreVM;
}


@end
