//
//  LCActiveV.h
//  LeCai
//
//  Created by lehecaiminib on 14-12-12.
//
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LCActiveVAnimationType) {
    LCActiveVAnimationTypyShow = 0,
    LCActiveVAnimationTypyDisappear = 1
};
@interface LCActiveV : UIView <UIWebViewDelegate , UIAlertViewDelegate>{
    UIWebView               *mActiveView;
    UIActivityIndicatorView *activityIndicator;
    NSString                *mDestUrl;
}

//@property (assign, nonatomic) LotteryType lotteryType;

- (id)initActiveVFrame:(CGRect)_frame advDestUrl:(NSString *)_destUrl;
- (void)activeAnimation:(LCActiveVAnimationType)_type isAnimation:(BOOL)_isAnimation;
- (void)reFreshWebView:(NSString *)_destUrl;
@end
