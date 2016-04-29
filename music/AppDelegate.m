//
//  AppDelegate.m
//  music
//
//  Created by 寿煜宇 on 16/4/21.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "AppDelegate.h"

#import "FYMainViewController.h"
#import "FYTuiViewController.h"
#import "FYMyViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self initTabBarController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //[self.window makeKeyWindow];//作为主窗口
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initTabBarController
{
    self.tabBarController  = [[UITabBarController alloc] init];
    
    FYMainViewController *item0 = [[FYMainViewController alloc]init];
    [self controller:item0 title:@"精选" image:@"tab_icon_selection_normal" selectedimage:@"tab_icon_selection_highlight"];
    
    FYTuiViewController *item1 = [[FYTuiViewController alloc]init];
    [self controller:item1 title:@"社区" image:@"icon_tab_shouye_normal" selectedimage:@"icon_tab_shouye_highlight"];
    
    FYMyViewController *item2 = [[FYMyViewController alloc]init];
    [self controller:item2 title:@"活动" image:@"icon_tab_fujin_normal" selectedimage:@"icon_tab_fujin_normal_light"];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9],UITextAttributeTextColor, nil] forState:UIControlStateSelected];//颜色
    
    [self.tabBarController setSelectedIndex:0];
    self.window.rootViewController = self.tabBarController;
    
}

//初始化一个zi控制器
-(void)controller:(UIViewController *)TS title:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage
{
    TS.tabBarItem.title = title;
    TS.tabBarItem.image = [UIImage imageNamed:image];
    TS.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:TS];
    [self.tabBarController addChildViewController:nav];
}

@end
