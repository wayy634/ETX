//
//  LCNumKeyboard.h
//  LeCai
//
//  Created by wanghui on 10/13/14.
//
//

#import <UIKit/UIKit.h>

@interface LCTextField : UITextField
@end

@protocol LCNumKeyboardDelegate
@optional
- (void)numKeyBoardDonePressed;
@end

@interface LCNumKeyboard : UIView
@property (nonatomic,strong)id<LCNumKeyboardDelegate> mDelegate;

+ (LCNumKeyboard *)numKeyboardWithTextField:(LCTextField *)aTextField maxValue:(long long)maxValue deleagte:(id)delegate_;
+ (LCNumKeyboard *)numKeyboardWithTextField:(LCTextField *)aTextField maxValue:(long long)maxValue finishedText:(NSString *)finishedText delegate:(id)deleagte_;

- (void)changeMaxValue:(long long)maxValue;

- (void)doneButtonClicked;

@end
