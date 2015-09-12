//
//  LCButton.h
//  LeCai
//
//  Created by HXG on 1/31/15.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LCButtonHighlightType) {
    LCButtonHighlightTypeNone = 0,
    LCButtonHighlightTypeBackground,
    LCButtonHighlightTypeTopCover
};

@protocol LCButtonDelegate;
@interface LCButton : UIButton

@property (nonatomic, strong) UIColor *LCNormalBgColor;
@property (nonatomic, strong) UIColor *LCHighlightBgColor; //默认值e5e5e5

@property (nonatomic, assign) LCButtonHighlightType highlightType; //默认值LCButtonHighlightTypeTopCover

@property (nonatomic, assign) IBOutlet id<LCButtonDelegate> buttonDelegate;

@end

@protocol LCButtonDelegate <NSObject>

- (void)button:(LCButton *)aButton highlightStatusChanged:(BOOL)isHighlighted;

@end
