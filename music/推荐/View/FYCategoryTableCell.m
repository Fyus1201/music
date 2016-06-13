//
//  FYCategoryTableCell.m
//  music
//
//  Created by 寿煜宇 on 16/5/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYCategoryTableCell.h"

@interface FYCategoryTableCell ()

@property (nonatomic,strong) UIImageView *arrow;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer;

@end

@implementation FYCategoryTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        //titleLabel.font = [UIFont systemFontOfSize:30];
        titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:30];
        titleLabel.text = _title;
        [self.arrow addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.arrow).with.offset(20);
            make.bottom.equalTo(self.arrow).with.offset(-10);
            make.width.mas_equalTo(180);
        }];
        _titleLb = titleLabel;
        
        // 分割线缩短
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    }
    return self;
}

#pragma mark - 加载

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        [self addSubview:_arrow];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0);
            make.left.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
        }];
        
        //下背景图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"album_album_mask"];
        [_arrow addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0);
            make.left.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
        }];
        
        /* 长按手势来形成按钮效果 */
        self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        self.pressRecognizer.minimumPressDuration = 0.2;
        
        self.pressRecognizer.delegate = self;
        self.pressRecognizer.cancelsTouchesInView = NO;
        
        [self addGestureRecognizer:self.pressRecognizer];
    }
    return _arrow;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

-(void)longPress:(UITapGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan){

        if(![_visualEffectView isDescendantOfView:self]) {
            UIVisualEffect *blurEffect;
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            _visualEffectView.frame = CGRectMake(0, 0, s_WindowW, s_WindowW*0.4);
            
            [self addSubview:_visualEffectView];
            
            //标题
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:50];
            titleLabel.text = _title;
            titleLabel.textColor = [UIColor whiteColor];
            [_visualEffectView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.arrow).with.offset(20);
                make.bottom.equalTo(self.arrow).with.offset(-10);
                make.width.mas_equalTo(180);
            }];

        }
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [_visualEffectView removeFromSuperview];
    }
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"categoryData" ofType:@"plist"];
    NSMutableArray *categoryArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    
    for (int i=0; i < categoryArray.count; i++) {
        
        if ([_title isEqualToString:categoryArray[i][@"title"]]) {
            
            self.arrow.image = [UIImage imageNamed:categoryArray[i][@"image"]];
            break;
        }else{
            self.arrow.image = [UIImage imageNamed:@"music_dan"];
        }
    }
    self.titleLb.text = _title;
    [self.titleLb setTextColor:[UIColor whiteColor]];
    
    self.backgroundColor = [UIColor whiteColor];

}

@end
