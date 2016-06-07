//
//  MenusModel.h
//  
//
//  Created by apple-jd33 on 15/11/18.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "BaseModel.h"

@class MenuLists;
@interface MenusModel : BaseModel

@property (nonatomic, assign) BOOL hasRecommendedZones;

@property (nonatomic, assign) BOOL isFinished;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger maxPageId;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<MenuLists *> *list;

@property (nonatomic, assign) NSInteger ret;

@end
@interface MenuLists : BaseModel

@property (nonatomic, copy) NSString *tname;

@property (nonatomic, assign) NSInteger category_id;

@end

