//
//  NewCategoryModel.h
//  music
//
//  Created by 寿煜宇 on 16/6/14.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "BaseModel.h"

@class NewCategoryList;
@interface NewCategoryModel : BaseModel

@property (nonatomic, assign) NSInteger pageId;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSArray *subfields;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger maxPageId;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<NewCategoryList *> *list;

@property (nonatomic, assign) NSInteger ret;

@end
@interface NewCategoryList : BaseModel

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *intro;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, assign) NSInteger tracks;

@property (nonatomic, assign) NSInteger tracksCounts;

@property (nonatomic, assign) NSInteger playsCounts;

@property (nonatomic, assign) NSInteger isFinished;

@property (nonatomic, copy) NSString *tags;

@property (nonatomic, copy) NSString *coverMiddle;

@property (nonatomic, copy) NSString *coverLarge;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *tracktitle;

@property (nonatomic, assign) long long lastUptrackAt;

@property (nonatomic, copy) NSString *albumCoverUrl290;

@property (nonatomic, assign) NSInteger serialState;

@property (nonatomic, assign) NSInteger albumid;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *lastUptrackTitle;

@property (nonatomic, assign) NSInteger lastUptrackId;

@property (nonatomic, copy) NSString *weburl;

@end
