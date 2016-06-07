//
//  FYCategoryTableCell.h
//  music
//
//  Created by 寿煜宇 on 16/5/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate传值
@protocol FYCategoryTableDelegate <NSObject>

- (void)categoryViewDidClick:(NSInteger)tag;/**这里不用使用*/

@end

@interface FYCategoryTableCell : UITableViewCell


// 添加代理
@property (nonatomic,weak) id<FYCategoryTableDelegate> delegate;

/**  标题 */
@property (nonatomic,weak) NSString *title;
@property (nonatomic,weak) UILabel *titleLb;


@end
