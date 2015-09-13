//
//  LCMenuBar.h
//  LeCai
//
//  Created by HXG on 3/7/15.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LCMenuBarSelectionAnimationType) {
    LCMenuBarSelectionAnimationTypeNone = 0,
    LCMenuBarSelectionAnimationTypeMove,
    LCMenuBarSelectionAnimationTypeFadeOutIn
};

typedef NS_ENUM(NSInteger, LCMenuBarWidthCaclRule) {
    LCMenuBarWidthCaclRuleAuto = 0,
    LCMenuBarWidthCaclRuleCustom
};

@interface LCMenuBarButtonConfiguration : NSObject

@property (nonatomic, strong) UIColor *mNormalTextColor;
@property (nonatomic, strong) UIColor *mSelectionTextColor;
@property (nonatomic, strong) UIColor *mNormalBackgroundColor;
@property (nonatomic, strong) UIColor *mSelectionBackgroundColor;
@property (nonatomic, strong) UIFont  *mFont;

@property (nonatomic, strong) UIColor *mBottomSelectionColor;
@property (nonatomic, assign) CGFloat  mBottomSelectionHeight;

@property (nonatomic, assign) CGFloat                         mButtonWidth;
@property (nonatomic, assign) LCMenuBarWidthCaclRule          mWidthCaclRule;
@property (nonatomic, assign) LCMenuBarSelectionAnimationType mSelectionAnimationType;
@property (nonatomic, assign) BOOL                            mShouldShowBottomLine;

@property (nonatomic, assign) BOOL     mShouldAddSplitLine;
@property (nonatomic, strong) UIColor *mSplitLineColor;
@property (nonatomic, assign) CGFloat  mSplitLineMargin;

+ (id)menuBarButtonConfiguration;

@end

@protocol LCMenuBarDelegate;
@interface LCMenuBar : UIView

@property (nonatomic, assign) IBOutlet id<LCMenuBarDelegate> mMenuBarDelegate;

@property (nonatomic, assign, readonly) NSInteger mCurrentIndex;

/**
 *  初始化按钮和配置
 *
 *  @param buttonConfiguration_ 相关配置信息，如果值为nil，则使用默认的配置
 *  @param buttonTitles_        按钮上的文字集合
 */
- (void)setButtonConfiguration:(LCMenuBarButtonConfiguration *)buttonConfiguration_ buttonTitles:(NSArray *)buttonTitles_;
- (void)changeCurrentIndex:(NSInteger)targetIndex_;
- (void)changeCurrentIndex:(NSInteger)targetIndex_ shouldSendMessage:(BOOL)shouldSend_;
- (void)resetButtonTitles:(NSArray *)buttonTitles_;

- (void)changeButtonStatusAtIndexes:(NSArray *)buttonIndexes_ disabled:(BOOL)isDisabled_;

@end

@protocol LCMenuBarDelegate <NSObject>

- (void)menuBar:(LCMenuBar *)menuBar_ didSelectButtonAtIndex:(NSInteger)index_;

@end