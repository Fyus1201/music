//
//  NAKPlaybackIndicatorContentView.h
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/28/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//  音乐播放指示

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/**
 This is an internal private class. Do not use this class directly.
 */
@interface NAKPlaybackIndicatorContentView : UIView

- (void)startOscillation;
- (void)stopOscillation;
- (BOOL)isOscillating;

- (void)startDecay;
- (void)stopDecay;

@end
