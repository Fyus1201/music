//
//  BaseViewModel.h
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/10.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewModelDelegate <NSObject>

@optional
/** 获取更多 */
- (void)getMoreDataCompletionHandle:(void(^)(NSError *error))completed;
/** 刷新 */
- (void)refreshDataCompletionHandle:(void(^)(NSError *error))completed;
/** 获取数据 */
- (void)getDataCompletionHandle:(void(^)(NSError *error))completed;
/** 通过indexPath返回cell高*/
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath;

@end

@interface BaseViewModel : NSObject<BaseViewModelDelegate>

@property (nonatomic,strong) NSURLSessionDataTask *dataTask;
/**  取消任务 */
- (void)cancelTask;
/**  暂停任务 */
- (void)suspendTask;
/**  继续任务 */
- (void)resumeTask;

@end
