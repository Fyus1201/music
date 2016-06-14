//
//  FYPickerView.h
//  TestProject1
//
//  Created by 寿煜宇 on 16/6/14.
//
//

#import <UIKit/UIKit.h>

@protocol FYPickerViewDelegate <NSObject>

@optional
-(void)didSelectedFYPickerView:(NSInteger)index time:(NSInteger)time;

@end
@interface FYPickerView : UIView

@property (nonatomic, assign) id<FYPickerViewDelegate> delegate;

@end
