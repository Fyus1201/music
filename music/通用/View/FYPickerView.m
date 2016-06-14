//
//  FYPickerView.m
//  TestProject1
//
//  Created by 寿煜宇 on 16/6/14.
//
//

#import "FYPickerView.h"

@interface FYPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic ) NSInteger timeInt;

@end

@implementation FYPickerView

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
    
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        
        [self initPickerView:frame];
        [self initHeadView:frame];
    }
    return self;
}


#pragma mark - init

- (void)initHeadView:(CGRect)frame{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    UIView *bheadView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 20)];
    
    headView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    bheadView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    headView.layer.cornerRadius = 10;
    bheadView.layer.borderWidth = 1;
    bheadView.layer.borderColor = [[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0] CGColor];
    
    UIButton *del = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 40, 36)];
    del.tag = 101;
    del.titleLabel.font = [UIFont systemFontOfSize:13];
    [del setTitle:@"取消" forState:UIControlStateNormal];
    [del setTitle:@"取消" forState:UIControlStateHighlighted];
    [del setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [del setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [del addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *ent = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 45, 2, 40, 36)];
    ent.tag = 102;
    ent.titleLabel.font = [UIFont systemFontOfSize:13];
    [ent setTitle:@"确定" forState:UIControlStateNormal];
    [ent setTitle:@"确定" forState:UIControlStateHighlighted];
    [ent setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [ent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [ent addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:del];
    [headView addSubview:ent];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 - 35, 2, 70, 36)];
    title.text = @"定时器";
    title.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:title];
    
    [self addSubview:bheadView];
    [self addSubview:headView];
}

- (void)initPickerView:(CGRect)frame{
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height-40)];
    
    self.pickerView.backgroundColor = [UIColor clearColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self addSubview:self.pickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return 6;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    
    if (row == 0) {
        return @"取消";
    }else if(row == 1){
        return @"10 分钟";
    }else if(row == 2){
        return @"20 分钟";
    }else if(row == 3){
        return @"30 分钟";
    }else if(row == 4){
        return @"40 分钟";
    }else if(row == 5){
        return @"50 分钟";
    }else{
        return @"返回";
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    if (row == 0) {
        _timeInt = 0;
    }else if(row == 1){
        _timeInt = 10;
    }else if(row == 2){
        _timeInt = 20;
    }else if(row == 3){
        _timeInt = 30;
    }else if(row == 4){
        _timeInt = 40;
    }else if(row == 5){
        _timeInt = 50;
    }
}

-(void)buttonClick:(UIButton *)btn{
    
    NSInteger tag = btn.tag;
    [self.delegate didSelectedFYPickerView:tag time:_timeInt];
}


@end
