//
//  FYMainTableViewCell.m
//  
//
//  Created by 寿煜宇 on 16/5/19.
//
//

#import "FYMainTableViewCell.h"

@interface FYMainTableViewCell ()

@property (nonatomic , strong) UIButton *playButton;

@end

@implementation FYMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.tag = 1000;
        self.playButton.tag = 2000;
        [self.playButton addTarget:self action:@selector(clickButtontap:) forControlEvents:UIControlEventTouchUpInside];
        [super bringSubviewToFront:self.playButton];
        
    }
    return self;
}

- (UIImageView *)coverIV {
    
    if(_coverIV == nil) {
        _coverIV = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverIV];
        [_coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
  
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-s_WindowW *0.2);
        }];
        
        UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowW)];
        
        backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickViewtap:)];
        [self addGestureRecognizer:tap];
        
        [_coverIV addSubview:backView];
    }
    return _coverIV;
}

- (UILabel *)titleLb {
    if(_titleLb == nil) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(s_WindowW);
            make.height.mas_equalTo(s_WindowW*0.2);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}

- (UIButton *)playButton {
    
    if (!_playButton) {
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setHighlighted:NO];// 去掉长按高亮
        [self addSubview:_playButton];
        
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset((s_WindowW - 65)/2);
            make.top.equalTo(self.contentView).with.offset((s_WindowW - 70)/2);
            //make.centerX.mas_equalTo(0);
            //make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(70);
        }];
    }
    
    return _playButton;
}

-(void)clickViewtap:(UITapGestureRecognizer *)sender{

    
    NSInteger tag = (NSInteger)sender.view.tag + _tagInt;
    [self.delegate mainTableViewDidClick:tag];
    
}

-(void)clickButtontap:(UIButton *)sender{
    
    self.isPlay = YES;
    NSInteger tag = (NSInteger)sender.tag + _tagInt;
    [self.delegate mainTableViewDidClick:tag];
}

- (void)setIsPlay:(BOOL)isPlay{

    _isPlay = isPlay;
    if (isPlay == YES) {
        [self.playButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
    }else{
        [self.playButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
    }
}

@end
