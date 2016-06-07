//
//  FYMoreCategoryCell.h
//  music
//
//  Created by 寿煜宇 on 16/5/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMoreCategoryCell.h"

#define kSpicWidth 60

@interface FYMoreCategoryCell ()
@property (nonatomic,strong) UIImageView *IV;
@property (nonatomic,strong) UIImageView *UIV;
@end

@implementation FYMoreCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 右箭头风格
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // 分割线缩短
        self.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
    }
    return self;
}

@synthesize tracksLb = _tracksLb;
@synthesize playsLb = _playsLb;

#pragma mark - Cell属性懒加载


- (UIButton *)coverBtn {
    if (!_coverBtn) {
        // 框框背景图
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"findradio_bg"]];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(kSpicWidth);
        }];
        
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageView addSubview:_coverBtn];
        [_coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(2);
            make.bottom.right.mas_equalTo(-2);
        }];
    }
    return _coverBtn;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(self.coverBtn.mas_right).mas_equalTo(12);
            make.right.mas_equalTo(-10);
        }];
        _titleLb.font = [UIFont systemFontOfSize:14];
        
    }
    return _titleLb;
}
- (UILabel *)introLb {
    if (!_introLb) {
        _introLb = [UILabel new];
        [self.contentView addSubview:_introLb];
        [_introLb mas_makeConstraints:^(MASConstraintMaker *make) {
            // 照片中间
            make.centerY.mas_equalTo(self.coverBtn);
            make.leadingMargin.mas_equalTo(self.titleLb);
            make.right.bottom.mas_equalTo(-10);
        }];
        _introLb.textColor = [UIColor lightGrayColor];
        _introLb.font = [UIFont systemFontOfSize:12];
    }
    return _introLb;
}
// 播放数
- (UILabel *)playsLb {
    if (!_playsLb) {
        _playsLb = [UILabel new];
        [self.contentView addSubview:_playsLb];
        self.IV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_albumcell_play"]];
        [self.contentView addSubview:self.IV];
        [self.IV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.leadingMargin.mas_equalTo(self.titleLb);
            make.bottom.mas_equalTo(-10);
        }];
        
        [self.contentView addSubview:_playsLb];
        [_playsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.IV);
            make.left.mas_equalTo(self.IV.mas_right).mas_equalTo(2);
            make.width.mas_lessThanOrEqualTo(100);
        }];
        _playsLb.textColor = [UIColor lightGrayColor];
        _playsLb.font = [UIFont systemFontOfSize:11];
    }
    return _playsLb;
}

// 集数
- (UILabel *)tracksLb {
    if (!_tracksLb) {
        _tracksLb = [UILabel new];
        [self.contentView addSubview:_tracksLb];
        self.UIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_hotUser_sounds"]];
        [self.contentView addSubview:self.UIV];
        [self.UIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.left.mas_equalTo(self.playsLb.mas_right).mas_equalTo(20);
            make.bottom.mas_equalTo(-10);
        }];
        
        [self.contentView addSubview:_tracksLb];
        [_tracksLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.UIV);
            make.left.mas_equalTo(self.UIV.mas_right).mas_equalTo(2);
            make.width.mas_lessThanOrEqualTo(100);
        }];
        _tracksLb.textColor = [UIColor lightGrayColor];
        _tracksLb.font = [UIFont systemFontOfSize:11];
   
    }
    return _tracksLb;
}


@end
