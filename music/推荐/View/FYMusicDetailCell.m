//
//  FYMusicDetailCell.m
//  music
//
//  Created by 寿煜宇 on 16/6/1.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMusicDetailCell.h"

@implementation FYMusicDetailCell

- (UIImageView *)coverIV {
    if(_coverIV == nil) {
        _coverIV = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverIV];
        [_coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(10);
        }];
        _coverIV.layer.cornerRadius=50/2;
        _coverIV.clipsToBounds = YES;
        //添加播放标识
        UIImageView *playIV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_album_play"]];
        [_coverIV addSubview:playIV];
        [playIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.center.mas_equalTo(0);
        }];
    }
    return _coverIV;
}

- (UILabel *)titleLb {
    if(_titleLb == nil) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.coverIV.mas_right).mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(self.updateTimeLb.mas_left).mas_equalTo(-10);
        }];
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}

- (UILabel *)updateTimeLb {
    if(_updateTimeLb == nil) {
        _updateTimeLb = [[UILabel alloc] init];
        [self.contentView addSubview:_updateTimeLb];
        _updateTimeLb.font=[UIFont systemFontOfSize:12];
        _updateTimeLb.textColor=[UIColor lightGrayColor];
        [_updateTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(40);
        }];
        _updateTimeLb.textAlignment=NSTextAlignmentRight;
    }
    return _updateTimeLb;
}

- (UILabel *)sourceLb {
    if(_sourceLb == nil) {
        _sourceLb = [[UILabel alloc] init];
        [self.contentView addSubview:_sourceLb];
        [_sourceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leftMargin.mas_equalTo(self.titleLb.mas_leftMargin);
            make.top.mas_equalTo(self.titleLb.mas_bottom).mas_equalTo(4);
            make.rightMargin.mas_equalTo(self.titleLb.mas_rightMargin);
        }];
        _sourceLb.font=[UIFont systemFontOfSize:12];
        _sourceLb.textColor=[UIColor lightGrayColor];
    }
    return _sourceLb;
}

- (UILabel *)playCountLb {
    if(_playCountLb == nil) {
        _playCountLb = [[UILabel alloc] init];
        [self.contentView addSubview:_playCountLb];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_play"]];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.leftMargin.mas_equalTo(self.sourceLb.mas_leftMargin);
            make.bottom.mas_equalTo(-10);
            make.top.mas_equalTo(self.sourceLb.mas_bottom).mas_equalTo(8);
        }];
        [_playCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageView);
            make.left.mas_equalTo(imageView.mas_right).mas_equalTo(3);
        }];
        _playCountLb.textColor=[UIColor lightGrayColor];
        _playCountLb.font=[UIFont systemFontOfSize:10];
    }
    return _playCountLb;
}

- (UILabel *)favorCountLb {
    if(_favorCountLb == nil) {
        _favorCountLb = [[UILabel alloc] init];
        [self.contentView addSubview:_favorCountLb];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_likes_n"]];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.playCountLb);
            make.left.mas_equalTo(self.playCountLb.mas_right).mas_equalTo(7);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        _favorCountLb.textColor=[UIColor lightGrayColor];
        _favorCountLb.font=[UIFont systemFontOfSize:10];
        [_favorCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).mas_equalTo(3);
            make.centerY.mas_equalTo(imageView);
        }];
    }
    return _favorCountLb;
}

- (UILabel *)commentCountLb {
    if(_commentCountLb == nil) {
        _commentCountLb = [[UILabel alloc] init];
        [self.contentView addSubview:_commentCountLb];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_comments"]];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.left.mas_equalTo(self.favorCountLb.mas_right).mas_equalTo(7);
            make.centerY.mas_equalTo(self.favorCountLb);
        }];
        [_commentCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageView);
            make.left.mas_equalTo(imageView.mas_right).mas_equalTo(3);
        }];
        _commentCountLb.textColor=[UIColor lightGrayColor];
        _commentCountLb.font=[UIFont systemFontOfSize:10];
    }
    return _commentCountLb;
}

- (UILabel *)durationLb {
    if(_durationLb == nil) {
        _durationLb = [[UILabel alloc] init];
        [self.contentView addSubview:_durationLb];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_duration"]];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.commentCountLb.mas_right).mas_equalTo(7);
            make.centerY.mas_equalTo(self.commentCountLb);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        [_durationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).mas_equalTo(3);
            make.centerY.mas_equalTo(imageView);
        }];
        _durationLb.font=[UIFont systemFontOfSize:10];
        _durationLb.textColor=[UIColor lightGrayColor];
    }
    return _durationLb;
}

- (UIButton *)downloadBtn {
    if(_downloadBtn == nil) {
        _downloadBtn = [UIButton buttonWithType:0];
        [_downloadBtn setBackgroundImage:[UIImage imageNamed:@"cell_download"] forState:0];
        [_downloadBtn bk_addEventHandler:^(id sender) {
            NSLog(@"下载按钮被点击...");
        } forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_downloadBtn];
        [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
    return _downloadBtn;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //为了触发下载按钮的懒加载
        self.downloadBtn.hidden = NO;
        
        //设置cell被选中后的背景色
        UIView *view=[UIView new];
        view.backgroundColor=s_RGBColor(243, 255, 254);
        self.selectedBackgroundView=view;
        //分割线距离左侧空间
        self.separatorInset=UIEdgeInsetsMake(0, 76, 0, 0);
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
