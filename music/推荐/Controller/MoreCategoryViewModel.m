//
//  MoreCategoryViewModel.m
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/19.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "MoreCategoryViewModel.h"
#import "FYMoreNetManager.h"
#import "ContentCategoryModel.h"

@interface MoreCategoryViewModel ()
@property (nonatomic,strong) ContentCategoryModel *model;
@end

@implementation MoreCategoryViewModel

- (instancetype)initWithCategoryId:(NSInteger)categoryId tagName:(NSString *)name {
    if (self = [super init]) {
        _categoryId = categoryId;
        _name = name;
    }
    return self;
}

- (void)getDataCompletionHandle:(void (^)(NSError *))completed {
    
    self.dataTask = [FYMoreNetManager getCategoryForCategoryId:_categoryId tagName:_name pageSize:_pageSize completionHandle:^(ContentCategoryModel* responseObject, NSError *error) {
        self.model = responseObject;
        completed(error);
    }];
}

- (void)refreshDataCompletionHandle:(void (^)(NSError *))completed {
    // 默认第一次显示20行
    _pageSize = 20;
    [self getDataCompletionHandle:completed];
}

- (void)getMoreDataCompletionHandle:(void (^)(NSError *))completed {
    // 一次下拉获得10行数据
    _pageSize += 10;
    [self getDataCompletionHandle:completed];
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
    NSString *path = self.model.list[row].coverMiddle;  // albumCoverUrl290一样
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
    return self.model.list[row].albumId;
}

/**  通过分组数, 获取标题(title)*/
- (NSString *)titleForRow:(NSInteger)row {
    return self.model.list[row].title;
}

@end
