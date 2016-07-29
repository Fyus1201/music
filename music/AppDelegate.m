//
//  AppDelegate.m
//  music
//
//  Created by 寿煜宇 on 16/4/21.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "AppDelegate.h"
#import "FYBarController.h"
#import "FYPlayManager.h"
#import <UMMobClick/MobClick.h>//友盟统计

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch. 5723010ee0f55a07a2000cf7
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
     [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    UMAnalyticsConfig *configure = [[UMAnalyticsConfig alloc]init];
    configure.appKey = @"5723010ee0f55a07a2000cf7";
    [MobClick startWithConfigure:configure];
    
    //self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[FYBarController alloc] init];
    [self.window makeKeyAndVisible];
    //[self.window makeKeyWindow];//作为主窗口
    
    return YES;

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    

    BOOL success = [[FYPlayManager sharedInstance] saveChanges];
    if (success){
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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



@end
