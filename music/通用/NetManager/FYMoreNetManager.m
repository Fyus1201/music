//
//  FYMoreNetManager.m
//  music
//
//  Created by 寿煜宇 on 16/5/18.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMoreNetManager.h"


#import "ContentsModel.h"
#import "MenusModel.h"
#import "ContentCategoryModel.h"
#import "EditorModel.h"
#import "SpecialModel.h"
#import "DestinationModel.h"

#define kURLPath @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends"
#define kURLCategoryPath @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends"
#define kURLAlbumPath @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album"

// 小编推荐栏 更多跳转URL
#define KURLEditor @"http://mobile.ximalaya.com/mobile/discovery/v1/recommend/editor"
// 精品听单栏 更多跳转URL
#define KURLSpecial @"http://mobile.ximalaya.com/m/subject_list"

#define kURLVersion @"version":@"4.3.26.2"
#define kURLDevice @"device":@"ios"
#define KURLScale @"scale":@2
#define kURLCalcDimension @"calcDimension":@"hot"
#define kURLPageID @"pageId":@1
#define kURLStatus  @"status":@0
#define KURLPer_page @"per_page":@10
#define kURLPosition @"position":@1

// 汉字UTF8进行转换并转入字典
#define kURLMoreTitle @"title":[@"更多" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

@implementation FYMoreNetManager



/** 解析,获取内容推荐数据模型 */
// http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=1&contentType=album&device=android&scale=2&version=4.3.32.2
+ (id)getContentsForForCategoryId:(NSInteger)categoryID contentType:(NSString*)type completionHandle:(void(^)(id responseObject, NSError *error))completed {
    
    NSDictionary *params = @{@"categoryId":@(categoryID),@"contentType":type,kURLDevice,KURLScale,kURLVersion};
    
    return [self GET:kURLPath parameters:params complationHandle:^(id responseObject, NSError *error) {
        completed([ContentsModel mj_objectWithKeyValues:responseObject],error);
        //NSLog(@"%@",responseObject);
    }];
    
}

/**  解析,内容分类数据模型*/
// http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=1&device=android&pageId=1&pageSize=20&status=0&tagName=%E6%AD%A3%E8%83%BD%E9%87%8F%E5%8A%A0%E6%B2%B9%E7%AB%99
+ (id)getCategoryForCategoryId:(NSInteger)categoryId tagName:(NSString *)name pageSize:(NSInteger)size completionHandle:(void(^)(id responseObject, NSError *error))completed {
    // tagName中文需要转换成UTF8格式, 这个另类   直接需要中文
    //    NSString *tagName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//网址转化
    NSDictionary *params = @{@"categoryId":@(categoryId),@"pageSize":@(size),@"tagName":name, kURLPageID,kURLDevice,kURLStatus,kURLCalcDimension};
    return [self GET:kURLAlbumPath parameters:params complationHandle:^(ContentCategoryModel* responseObject, NSError *error) {
        completed([ContentCategoryModel mj_objectWithKeyValues:responseObject],error);
    }];
}

/**  解析,小编推荐更多数据模型*/
// http://mobile.ximalaya.com/mobile/discovery/v1/recommend/editor?device=android&pageId=1&pageSize=20&title=%E6%9B%B4%E5%A4%9A
+ (id)getEditorMoreForPageSize:(NSInteger)size completionHandle:(void(^)(id responseObject, NSError *error))completed {
    NSDictionary *params = @{kURLPageID,@"pageSize":@(size),kURLDevice,kURLMoreTitle};
    return [self GET:KURLEditor parameters:params complationHandle:^(id responseObject, NSError *error) {
        completed([EditorModel mj_objectWithKeyValues:responseObject],error);
    }];
}

/**  解析,精品听单更多数据模型  加载更多通过page*/
// http://mobile.ximalaya.com/m/subject_list?device=android&page=1&per_page=10&title=%E6%9B%B4%E5%A4%9A
+ (id)getSpecialForPage:(NSInteger)page completionHandle:(void(^)(id responseObject, NSError *error))completed {
    NSDictionary *params = @{kURLDevice,KURLPer_page,kURLMoreTitle,@"page":@(page)};
    return [self GET:KURLSpecial parameters:params complationHandle:^(id responseObject, NSError *error) {
        completed([SpecialModel mj_objectWithKeyValues:responseObject],error);
    }];
}

/**  从网络上获取 选集信息  通过AlbumId, mainTitle, idAsc(是否升序)*/
//http://mobile.ximalaya.com/mobile/others/ca/album/track/2758446/true/1/20?position=1&albumId=2758446&isAsc=true&device=android&title=%E5%B0%8F%E7%BC%96%E6%8E%A8%E8%8D%90&pageSize=20
+ (id)getTracksForAlbumId:(NSInteger)albumId mainTitle:(NSString *)title idAsc:(BOOL)isAsc completionHandle:(void(^)(id responseObject, NSError *error))completed {
    NSDictionary *params = @{@"albumId":@(albumId),@"title":title,@"isAsc":@(isAsc), kURLDevice,kURLPosition};
    NSString *path = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%ld/true/1/20",(long)albumId];
    return [self GET:path parameters:params complationHandle:^(id responseObject, NSError *error) {
        completed([DestinationModel mj_objectWithKeyValues:responseObject],error);

    }];
}


@end
