//
//  FYNAKPlaybackIndicatorView.m
//  music
//
//  Created by 寿煜宇 on 16/5/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYNAKPlaybackIndicatorView.h"

@implementation FYNAKPlaybackIndicatorView

+ (instancetype)sharedInstance {
    
    static FYNAKPlaybackIndicatorView *_sharedMusicIndicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMusicIndicator = [[FYNAKPlaybackIndicatorView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width - 50, 0, 50, 44)];
    });
    
    return _sharedMusicIndicator;
}

@end
