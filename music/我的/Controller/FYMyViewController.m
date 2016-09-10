//
//  FYMyViewController.m
//  music
//
//  Created by 寿煜宇 on 16/4/21.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMyViewController.h"
#import "FYMusicDetailCell.h"

#import "FYPlayManager.h"
#import "TracksViewModel.h"

#import "FYfavoriteItem.h"
#import "FYhistoryItem.h"

@interface FYMyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic,strong) TracksViewModel *tracksVM;
@property (nonatomic,strong) NSArray *historyItems;

@end

@implementation FYMyViewController{
    CGFloat _viewY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    [self initNav];
    [self initMainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (_itemModel == 0) {
        _historyItems = [[FYPlayManager sharedInstance] historyMusicItems];
    }
    
    [self.tracksVM getItemModelData:^(NSError *error) {
        [self.mainTableView reloadData];
    }];
    [self.mainTableView reloadData];
}



- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];

    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}


- (void)initNav{
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    if (_itemModel == 0) {
         self.navigationItem.title = @"历史音乐";
    }else if(_itemModel == 1){
         self.navigationItem.title = @"我的收藏";
    }else{
         self.navigationItem.title = @"音乐";
    }
   
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];
    rightButton.title = @"清空";
    self.navigationItem.rightBarButtonItem = rightButton;
    rightButton.target = self;
    rightButton.action = @selector(delAll);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    
}

#pragma mark - 表格+下拉动画
- (void)initMainTableView{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowH) style:UITableViewStylePlain];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [_mainTableView registerClass:[FYMusicDetailCell class] forCellReuseIdentifier:@"MusicDetailCell"];
    _mainTableView.rowHeight = 80;
    [self.view addSubview:self.mainTableView];

}

- (TracksViewModel *)tracksVM {
    if (!_tracksVM) {
        _tracksVM = [[TracksViewModel alloc] initWithitemModel:self.itemModel];
        
    }
    return _tracksVM;
}

// 连带滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _viewY = scrollView.contentOffset.y;
}

- (void)delAll{
    if (_itemModel == historyItem) {
        
        [[FYPlayManager sharedInstance] delAllHistoryMusic];
        [self.tracksVM getItemModelData:^(NSError *error) {
            [self.mainTableView reloadData];
        }];
        [self.mainTableView reloadData];
        
    }else if(_itemModel == favoritelItem){
        [[FYPlayManager sharedInstance] delAllFavoriteMusic];
        [self.tracksVM getItemModelData:^(NSError *error) {
            [self.mainTableView reloadData];
        }];
        [self.mainTableView reloadData];
    }
}

#pragma mark - UITableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracksVM.rowNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FYMusicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicDetailCell"];
    
    
    [cell.coverIV sd_setImageWithURL:[self.tracksVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"album_cover_bg"]];
    
    cell.titleLb.text = [self.tracksVM titleForRow:indexPath.row];
    cell.sourceLb.text = [self.tracksVM nickNameForRow:indexPath.row];
    cell.updateTimeLb.text = [self.tracksVM updateTimeForRow:indexPath.row];
    cell.playCountLb.text = [self.tracksVM playsCountForRow:indexPath.row];
    cell.durationLb.text = [self.tracksVM playTimeForRow:indexPath.row];
    cell.favorCountLb.text = [self.tracksVM favorCountForRow:indexPath.row];
    cell.commentCountLb.text = [self.tracksVM commentCountForRow:indexPath.row];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果申请删除操作
    
    if (editingStyle == UITableViewCellEditingStyleDelete){

        if (_itemModel == historyItem) {

            NSDictionary *track = [self.tracksVM trackForRow:indexPath.row];
            [[FYPlayManager sharedInstance] delMyHistoryMusic:track];
            _historyItems = [[FYPlayManager sharedInstance] historyMusicItems];
            [self.mainTableView reloadData];

        }else if(_itemModel == favoritelItem){
            NSDictionary *track = [self.tracksVM trackForRow:indexPath.row];
            [[FYPlayManager sharedInstance] delMyFavoriteMusicDictionary:track];
        }
        
        [self.tracksVM getItemModelData:^(NSError *error) {
        }];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//删除提示文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
    if(_itemModel == favoritelItem){
        NSString *deltext = @"清除";
        return deltext;
    }
    NSString *deltext = @"删除";
    return deltext;
}

//设置禁止删除,每次设置时候调用
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //
    return YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 当前播放信息
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:indexPath.row];
    userInfo[@"musicURL"] = [self.tracksVM playURLForRow:indexPath.row];
    
    //位置
    CGFloat origin = indexPath.row*80 -_viewY-80;
    NSNumber *originy = [[NSNumber alloc]initWithFloat:origin];
    userInfo[@"originy"] = originy;

    //专辑
    if (_itemModel == historyItem) {
        
        FYhistoryItem *historyItem = _historyItems[indexPath.row];
        TracksViewModel *tracks = [[TracksViewModel alloc] initWithAlbumId:[_tracksVM albumIdForRow:indexPath.row] title:historyItem.albumTitle isAsc:YES];
        [tracks getDataCompletionHandle:^(NSError *error)  {
            userInfo[@"theSong"] = tracks;
            
            NSNumber *musicRow = [[NSNumber alloc]initWithInteger:historyItem.musicRow];
            userInfo[@"indexPathRow"] = musicRow;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginPlay" object:nil userInfo:[userInfo copy]];
        }];

    }
    if (_itemModel == favoritelItem) {

        TracksViewModel *tracks = [[TracksViewModel alloc] initWithitemModel:favoritelItem];
        [tracks getItemModelData:^(NSError *error) {}];
        userInfo[@"theSong"] = tracks;
        
        NSInteger indexPathRow = indexPath.row;
        NSNumber *indexPathRown = [[NSNumber alloc]initWithInteger:indexPathRow];
        userInfo[@"indexPathRow"] = indexPathRown;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginPlay" object:nil userInfo:[userInfo copy]];
    }
}

@end
