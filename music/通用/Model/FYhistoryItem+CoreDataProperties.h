//
//  FYhistoryItem+CoreDataProperties.h
//  music
//
//  Created by 寿煜宇 on 16/6/10.
//  Copyright © 2016年 Fyus. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FYhistoryItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYhistoryItem (CoreDataProperties)

@property (nonatomic) NSInteger albumId;
@property (nullable, nonatomic, retain) NSString *albumImage;
@property (nullable, nonatomic, retain) NSString *albumTitle;
@property (nonatomic) NSInteger comments;
@property (nullable, nonatomic, retain) NSString *coverLarge;
@property (nullable, nonatomic, retain) NSString *coverMiddle;
@property (nullable, nonatomic, retain) NSString *coverSmall;
@property (nonatomic) NSInteger createdAt;
@property (nonatomic) NSInteger downloadAacSize;
@property (nullable, nonatomic, retain) NSString *downloadAacUrl;
@property (nonatomic) NSInteger downloadSize;
@property (nullable, nonatomic, retain) NSString *downloadUrl;
@property (nonatomic) float duration;
@property (nonatomic) BOOL isPublic;
@property (nonatomic) NSInteger likes;
@property (nullable, nonatomic, retain) NSString *nickname;
@property (nonatomic) NSInteger opType;
@property (nonatomic) NSInteger orderNum;
@property (nullable, nonatomic, retain) NSString *playPathAacv164;
@property (nullable, nonatomic, retain) NSString *playPathAacv224;
@property (nonatomic) NSInteger playtimes;
@property (nullable, nonatomic, retain) NSString *playUrl32;
@property (nullable, nonatomic, retain) NSString *playUrl64;
@property (nonatomic) NSInteger processState;
@property (nonatomic) NSInteger shares;
@property (nullable, nonatomic, retain) NSString *smallLogo;
@property (nonatomic) NSInteger status;
@property (nullable, nonatomic, retain) NSString *title;
@property (nonatomic) NSInteger trackId;
@property (nonatomic) NSInteger uid;
@property (nonatomic) NSInteger userSource;
@property (nonatomic) double orderingValue;
@property (nonatomic) NSInteger musicRow;

@end

NS_ASSUME_NONNULL_END
