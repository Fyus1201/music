//
//  FYCategoryViewController.h
//  music
//
//  Created by 寿煜宇 on 16/5/25.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYCategoryViewController : UIViewController

// 作一个键, 让MV可以绑定    接收外部传参，决定当前控制器显示哪种类型的信息
@property (nonatomic,strong) NSString *keyName;

@end
