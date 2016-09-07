//
//  LeftView.h
//  music
//
//  Created by 寿煜宇 on 16/5/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol leftDelegate <NSObject>
- (void)jumpWebVC:(NSURL *)url;
@end

@interface LeftView : UIView
@property (nonatomic, weak) id<leftDelegate> delegate;
@end
