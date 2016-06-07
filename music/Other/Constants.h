//
//  Constants.h
//  music
//
//  Created by 寿煜宇 on 16/5/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
// NavigationBar高度
#define s_NavigationBar_HEIGHT 44

// 自定义Cell高,
#define s_BigCellHight 120

// 自定义方形按钮宽
#define s_Rect (kWindowW - 40)/3

// 自建分类


#pragma mark - 设备信息
#define s_IOS_VERSION    [[[UIDevice currentDevice] systemVersion] floatValue]
#define s_DEVICE_MODEL   [[UIDevice currentDevice] model]
#define s_IS_IPAD        ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define s_APP_NAME            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define s_APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define s_APP_SUB_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define s_UDeviceIdentifier   [[UIDevice currentDevice] uniqueDeviceIdentifier]
/** 当前系统语言*/
#define s_CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#pragma mark - ios版本判断
#define s_IOS5_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define s_IOS6_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define s_IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define s_IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

#pragma mark - 设备类型
#define s_isPhone4     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_isPhone5     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_isPhone6     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_isPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#pragma mark - 颜色
//#define s_COLOR_RGB(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
//#define s_COLOR_RGBA(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define s_RGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define s_RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define s_COLOR_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - 定义字体大小
#define s_FONT_TITLE(X)     [UIFont systemFontSize:X]
#define s_FONT_CONTENT(X)   [UIFont systemFontSize:X]

#pragma mark - 屏幕相关
#define s_WindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define s_WindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度

// AppDelegate
#define s_AppDelegate ((AppDelegate*)([UIApplication sharedApplication].delegate))

// Storyboard通过名字获取
#define s_Storyboard(StoryboardName)     [UIStoryboard storyboardWithName:StoryboardName bundle:nil]

#pragma mark - GCD
#define s_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define s_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

// 移除iOS7之后，cell默认左侧的分割线边距
#define s_RemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}\

// Docment文件夹目录
#pragma mark - Docment文件夹目录
#define s_DocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#endif /* Constants_h */
