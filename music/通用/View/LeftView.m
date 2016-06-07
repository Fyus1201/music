//
//  LeftView.m
//  music
//
//  Created by 寿煜宇 on 16/5/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "LeftView.h"

@interface LeftView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation LeftView


-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:0.97];
        [self initTableView:frame];
    }
    return self;
}

#pragma mark - 表格+下拉动画
- (void)initTableView:(CGRect)frame{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

// 制作表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    
    headerView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:0.0];
    
    return headerView;
}

// 组头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return 150;
        case 1:
            return 30;
        case 4:
            return 30;
        default:
            return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"每日打卡";
            break;
        case 1:
            cell.textLabel.text = @"我的主页";
            break;
        case 2:
            cell.textLabel.text = @"我的收藏";
            break;
        case 3:
            cell.textLabel.text = @"我的缓存";
            break;
        case 4:
            cell.textLabel.text = @"定时关机";
            break;
        case 5:
            cell.textLabel.text = @"意见反馈";
            break;
        case 6:
            cell.textLabel.text = @"加入我们";
            break;
        default:
            cell.textLabel.text = @"加载错误";
            break;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
