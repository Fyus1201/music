//
//  BaseViewModel.m
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/10.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

/**  取消任务 */
- (void)cancelTask {
    [self.dataTask cancel];
}
/**  暂停任务 */
- (void)suspendTask {
    [self.dataTask suspend];
}
/**  继续任务 */
- (void)resumeTask {
    [self.dataTask resume];
}

@end
