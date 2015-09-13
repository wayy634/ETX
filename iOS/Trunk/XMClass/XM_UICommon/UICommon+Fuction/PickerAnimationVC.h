//
//  PickerAnimationVC.h
//  LeHeCai
//
//  Created by HXG on 11-10-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//need release by yourself
#import <UIKit/UIKit.h>
#define PICKERVIEW_ANIMATION_OFFSET_Y (K_SCREEN_HEIGHT==568&&[[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)?44:64
#define PICKERVIEW_ANIMATION_DURATION 0.5
@protocol PickerAnimationDelegate <NSObject>
- (void)pickerAnimationOkButtonPressed:(id)object;
- (void)pickerAnimationClose;
@end

@interface PickerAnimationVC : LCBaseViewController <UIPickerViewDelegate,UIPickerViewDataSource>{

    IBOutlet UIPickerView *mPickerView;
    IBOutlet UIButton     *mCancelButton;
    IBOutlet UIButton     *mDecideButton;
    IBOutlet UILabel      *mMessageLabel;
    IBOutlet UIView       *mCoverView;
    IBOutlet UIView       *mBottomView;
    NSString              *mPickerString;
    NSMutableArray        *mDataArray;
    id<PickerAnimationDelegate> pickerAnimationDelegate;
    BOOL                   isSelected;
}
@property (nonatomic) BOOL                   isSelected;
@property (nonatomic, assign) id<PickerAnimationDelegate> pickerAnimationDelegate;

- (id)initPickerAnimationData:(NSMutableArray *)array 
              titleTextString:(NSString *)text
                   controller:(id)controller;
- (void)setPickerAnimationFrame:(CGRect)_frame;
- (void)updataDataArray:(NSMutableArray *)array;
- (void)animationShow;
- (void)animationDisappear;
- (void)removeAll;
// add by chw at 20130115
- (void)updataPickerToIndex:(NSInteger)_index;
- (IBAction)buttonPressed:(UIButton *)sender;
@end
