//
//  FYiCarouselView.m
//  music
//
//  Created by 寿煜宇 on 16/5/24.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYiCarouselView.h"
#import "MoreContentViewModel.h"

@interface FYiCarouselView () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;/*不用时最好关闭*/

@end

@implementation FYiCarouselView

- (instancetype)initWithFocusImgMdoel:(MoreContentViewModel *)Mdoel {
    if (self = [super init]) {
        _moreVM = Mdoel;

        // 先关闭自己已存在定时器
        [_timer invalidate];
        // 当前没有头部滚动视图, 返回空对象nil
        if (!self.moreVM.focusImgNumber) {
            return nil;
        }
        
        _iView = [[UIView alloc] init];
        //头部视图origin无效,宽度无效,肯定是与table同宽
        _iView.frame = CGRectMake(0, 0, 0, s_WindowW/660*310);
        
        // 添加滚动栏
        _carousel = [iCarousel new];
        [self.iView addSubview:_carousel];
        [_carousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        // 如果只有一张图,则不可以滚动
        _carousel.scrollEnabled = self.moreVM.focusImgNumber != 1;
        //    _ic.scrollSpeed = 1;
        // 让图片一张一张滚, 默认NO  滚一次到尾
        _carousel.pagingEnabled = YES;
        
        _pageControl = [UIPageControl new];
        _pageControl.numberOfPages = self.moreVM.focusImgNumber;
        [_carousel addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-6);
            make.height.mas_equalTo(10);
        }];
        // 如果只有一张图,则不显示圆点
        _pageControl.hidesForSinglePage = YES;
        // 圆点不与用户交互
        _pageControl.userInteractionEnabled = NO;

        _pageControl.pageIndicatorTintColor = [UIColor lightTextColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        // 计时器产生,开启滚动
        if (self.moreVM.focusImgNumber > 1) {
            
            [self addTimer];
        }
    }
    return self;
}

#pragma mark - iCarousel代理方法
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    
    return self.moreVM.focusImgNumber;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    
    UIImageView *imgView = nil;
    
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowW/660*310)];
        imgView = [UIImageView new];
        [view addSubview:imgView];
        imgView.tag = 110;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    
    imgView = (UIImageView *)[view viewWithTag:110];
    [imgView sd_setImageWithURL:[self.moreVM focusImgURLForIndex:index] placeholderImage:[UIImage imageNamed:@"cell_bg_noData_2"]];
    return view;
}

/** 允许循环滚动 */
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}

/**  监控滚到第几个 */
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    
    _pageControl.currentPage = carousel.currentItemIndex;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    if (self.clickAction) {
        self.clickAction(index);
    }
}

-(void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                                  target:self
                                                selector:@selector(nextImage)
                                                userInfo:nil
                                                 repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:self.timer
                             forMode:NSRunLoopCommonModes];
}

- (void)removeTimer{
    
    [self.timer invalidate];
}


- (void)nextImage{
    
    NSInteger index = self.carousel.currentItemIndex + 1;
    if (index == self.moreVM.focusImgNumber ) {
        index = 0;
    }
    
    [self.carousel scrollToItemAtIndex:index
                              animated:YES];
    
    
}
/**滑动时停止*/
- (void)carouselWillBeginDragging:(iCarousel *)carousel{
    
    [self removeTimer];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel
                willDecelerate:(BOOL)decelerate{
    //    开启定时器
    [self addTimer];
}


@end
