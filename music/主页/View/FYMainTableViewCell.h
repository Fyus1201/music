//
//  FYMainTableViewCell.h
//  
//
//  Created by 寿煜宇 on 16/5/19.
//
//

#import <UIKit/UIKit.h>


// Delegate传值
@protocol FYMainTableViewDelegate <NSObject>

- (void)mainTableViewDidClick:(NSInteger)tag;

@end

@interface FYMainTableViewCell : UITableViewCell


// 添加代理
@property (nonatomic,assign) id<FYMainTableViewDelegate> delegate;

@property(nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic) NSInteger tagInt;

@property (nonatomic) BOOL isPlay;

@end
