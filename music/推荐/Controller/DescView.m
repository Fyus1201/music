//
//  DescView.m
//  music
//
//  Created by 寿煜宇 on 16/6/1.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "DescView.h"

@implementation DescView

- (instancetype)init {
    if (self = [super init]) {
        self.jianTou.hidden = NO;
    }
    return self;
}

- (UILabel *)descLb {
    if (!_descLb) {
        _descLb = [UILabel new];
        [self addSubview:_descLb];
        [_descLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.mas_equalTo(0);
            // 适配最大宽度, 不然4S适配会超出屏幕
            make.width.mas_lessThanOrEqualTo(s_WindowW/2);
        }];
        _descLb.textColor = [UIColor lightGrayColor];
        _descLb.font = [UIFont systemFontOfSize:13];
    }
    return _descLb;
}

- (UIImageView *)jianTou {
    if (!_jianTou) {
        _jianTou = [UIImageView new];
        [self addSubview:_jianTou];
        [_jianTou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLb.mas_right);
            make.centerY.mas_equalTo(self.descLb);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
        _jianTou.image = [UIImage imageNamed:@"findcell_arrow"];
    }
    return _jianTou;
}

@end
