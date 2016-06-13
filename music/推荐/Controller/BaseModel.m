//
//  BaseModel.m
//  
//
//  Created by apple-jd33 on 15/11/9.
//  现成的model改～听说喜马拉雅的接口要更新了，到时候再自己弄
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "BaseModel.h"


@implementation BaseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end
