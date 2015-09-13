//
//  LCUIView+ClickOnTheState.h
//  LeCai
//
//  Created by lehecaiminib on 15-1-29.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, clickOnTheStateType) {
    clickOnTheStateTypeaBackGround = 0,
    clickOnTheStateTypeCover = 1
};
@class LCCoverV;
//添加点击态要在所有的控件设置属性完成以后最后调用，否则容易漏掉属性，包括添加手势或者SEL
@interface UIView (clickOnTheState)
@property(nonatomic) LCCoverV  *mCoverV;
- (void)addButtonClickState:(clickOnTheStateType)_type clickStateColor:(UIColor *)_color clickStateAlpha:(float)_alpha delegate:(id)_delegate;

//如何控件上有GestureRecognizer，先执行手势的回调，再执行block,尽量统一成一个..
- (void)addClickState:(clickOnTheStateType)_type clickStateColor:(UIColor *)_color clickStateAlpha:(float)_alpha code:(void(^)(void))_complete;
@end

@interface LCCoverV : UIView
@property (nonatomic,copy)UIColor *mCoverColor;
@property (nonatomic,copy)UIColor *mRemeberColor;
@property (nonatomic,copy) void (^LCCoverVForTouchUp)(void);
@property (assign)float mCoverAlpha;
@property (assign)float mRemeberAlpha;
@end