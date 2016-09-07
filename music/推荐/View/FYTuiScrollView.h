//
//  FYTuiScrollView.h
//  music
//
//  Created by 寿煜宇 on 16/4/21.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol scrollDelegate <NSObject>
- (void)scrollWebVC:(NSURL *)url;
@end

@interface FYTuiScrollView : UIScrollView
@property (nonatomic, weak) id<scrollDelegate> sdelegate;
@end
