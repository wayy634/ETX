//
//  LCTimesView.h
//  LeCai
//
//  Created by WangHui on 12/1/14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LCNumKeyboard.h"

@protocol LCTimesViewDelegate;
@interface LCTimesView : UIView

@property (assign, nonatomic) NSInteger maxTimes;
@property (assign, nonatomic) NSInteger minTimes;
@property (assign, nonatomic) BOOL shouldAddTimesSuffix;
@property (assign, nonatomic) BOOL timesFiledCanEdit;
@property (assign, nonatomic) BOOL inEditing;
@property (assign, nonatomic) LCTextField *timesField;

@property (assign, nonatomic) IBOutlet id<LCTimesViewDelegate> delegate;

@property (assign, nonatomic, readonly) NSInteger times;

//- (void)setPlusImage:(UIImage *)plusImage minusImage:(UIImage *)minusImage;

- (void)setEnabledMinusImage:(NSString *)enabledMinusImageName
          disabledMinusImage:(NSString *)disabledMinusImageName
            enabeldPlusImage:(NSString *)enabledPlusImageName 
           disabledPlusImage:(NSString *)disabledPlusImageName;

- (void)setEditColor:(UIColor *)editColor normalColor:(UIColor *)nomralColor;
- (void)setDisplayTimes:(NSInteger)times;
- (void)setDisplayTimesNoNeedCallBack:(NSInteger)times;
- (void)setBorderColor:(UIColor *)borderColor;

- (void)hideKeyboard;


@end

@protocol LCTimesViewDelegate <NSObject>

@optional
- (void)timesChanged:(LCTimesView *)aView;
- (void)timesChangedWhenMaxTimeCallBack:(LCTimesView *)aView;
- (void)textLCTimesViewTextFieldDidBeginEditing:(LCTextField *)_textField;
- (void)textLCTimesViewTextFieldDidEndEditing:(LCTextField *)_textField;
- (void)timesLessThanMinWhenKeyboardHide:(LCTimesView *)timesView;
- (void)textFieldDonePressed:(LCTimesView *)timesView;
- (void)textFieldEditFinish:(LCTimesView *)timesView;
@end