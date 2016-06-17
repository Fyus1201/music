//
//  NewContentViewModel.m
//  music
//
//  Created by 寿煜宇 on 16/6/14.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "NewContentViewModel.h"

#import "FYMoreNetManager.h"
#import "NewCategoryModel.h"

@interface NewContentViewModel ()
@property (nonatomic,strong) NewCategoryModel *model;
@end

@implementation NewContentViewModel

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)getDataCompletionHandle:(void (^)(NSError *))completed {
    
    self.dataTask = [FYMoreNetManager getTracksForMusic:0 completionHandle:^(NewCategoryModel *responseObject, NSError *error){
        self.model = responseObject;
        completed(error);
    }];
}

/**  返回最大显示行数 */
- (NSInteger)pageSize {
    return self.model.pageSize;
}

/**  返回总行数 */
- (NSInteger)rowNumber {
    return self.model.list.count;
}


/**  通过分组数, 获取图标*/
- (NSURL *)coverURLForRow:(NSInteger)row {
    NSString *path = self.model.list[row].coverLarge;  // albumCoverUrl290一样
    return [NSURL URLWithString:path];
}
/**  通过分组数, 获取作者(intro)*/
- (NSString *)introForRow:(NSInteger)row {
    return self.model.list[row].intro;
}
/**  通过分组数, 获取播放次数*/
- (NSString *)playsForRow:(NSInteger)row {
    NSInteger count = self.model.list[row].playsCounts;
    if (count>10000) {
        return [NSString stringWithFormat:@"%.1lf万",count/10000.0];
    } else {
        return [NSString stringWithFormat:@"%ld",(long)count];
    }
}
/**  通过分组数, 获取集数*/
- (NSString *)tracksForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%ld集",(long)self.model.list[row].tracksCounts];
}

#pragma mark - 跳转页专用
/**  通过分组数, 获取分类Id */
- (NSInteger)albumIdForRow:(NSInteger)row {
    return self.model.list[row].albumid;
}

/**  通过分组数, 获取标题(title)*/
- (NSString *)titleForRow:(NSInteger)row {
    return self.model.list[row].title;
}

/**  通过分组数, 获取(trackTitle)*/
- (NSString *)trackTitleForRow:(NSInteger)row {
    return self.model.list[row].tracktitle;
}

/**  通过分组数, 获取url*/
- (NSURL *)urlForRow:(NSInteger)row {
    NSURL *url = [[NSURL alloc] initWithString:self.model.list[row].weburl];
    return url;
}


@end
