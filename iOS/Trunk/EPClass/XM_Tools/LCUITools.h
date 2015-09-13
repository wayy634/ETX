//
//  LCUITools.h
//  LeCai
//
//  Created by HXG on 12/28/14.
//
//

#import <Foundation/Foundation.h>

extern NSString * const LCNotificationShouldRefreshWebViewAfterLogin;
extern NSString * const LCNotificationNewUserPrizeCommingFromURL;

@interface LCUITools : NSObject



//+ (void)enterRewardHistoryDetails:(LotteryType)lottery checkDuplication:(BOOL)shouldCheck;
//+ (void)enterBetPage:(LotteryType)lotteryType shouldCheckSingle:(BOOL)shouldCheck;
//
///**
// *  查看requestURL是否直接由webview展示，如果可以则直接展示，否则直接跳转出去调用[[UIApplication sharedApplication] openURL:@"xxx"]
// *  @param requestURL 请求的URL对象
// *  @return requestURL是否直接由webview展示， 可以直接显示返回YES，否则NO
// */
//+ (BOOL)checkWebviewRequestURL:(NSURL *)requestURL;
//
//+ (BOOL)processURLInApp:(NSURL *)openURL;
//
//+ (void)checkSNSLoginButtonStatus:(NSArray *)loginButtons;

/*
 *缩放动画
 *sx,sy 分别为x,y 比例
 */

//+ (void)scaleAnmiartionView:(UIView *)view_ andDuration
//                           :(NSTimeInterval)duration_ andAnimationDelay
//                           :(NSTimeInterval)delay andScale_X
//                           :(CGFloat)scale_x_ andScale_y
//                           :(CGFloat)scale_y_;
/*
 *旋转动画
 *rotation :旋转方向 values = x|| y||z 默认和其他非法的为 x
 * angle_ :角度
 */

//划线
+ (UIView *)creatLineView:(CGRect)_frame bgColor:(UIColor *)_color;
//绘制虚线
+ (UIView *)creatDashedLineView:(CGRect)_frame;
//创建label
+ (UILabel *)creatNewLabel:(CGRect)_frame text:(NSString *)_text color:(UIColor *)_color font:(UIFont *)_font textAlinment:(NSTextAlignment)_alignment;

+(void)rotationAnmiartionView:(UIView *)view_ andDuration
                             :(NSTimeInterval)duration andRotation
                             :(NSString *)rotation_ andAngle
                             :(CGFloat)angle_ andRepeatCount
                             :(NSInteger)repeatCount_;
/***摆动动画
 ***/
+(void)swingAnmiartionView:(UIView*)view_ andDuration
                          :(NSTimeInterval)duration andRotation
                          :(NSString*)rotation_ andRepeatCount
                          :(NSInteger)repeatCount_ andAngle:(CGFloat)angle_;
/*
 *慢显示动画
 */
+ (void)slowDisplay:(UIView *)view_ andDuration
               :(NSTimeInterval)duration_ andAnimationDelay
               :(NSTimeInterval)delay;

/*
*
*/
+ (void)slowDisplay:(UIView *)view_ andDuration
                   :(NSTimeInterval)duration_ andAnimationDelay
                   :(NSTimeInterval)delay finishedBlock:(void (^)(void))continuAnimations_;


+ (void)scaleAnmiartionView:(UIView *)view_ andDuration
                           :(NSTimeInterval)duration_ andAnimationDelay
                           :(NSTimeInterval)delay andScale_X
                           :(CGFloat)scale_x_ andScale_y
                           :(CGFloat)scale_y_ finishedBlock:(void (^)(void))continuAnimations_;

+ (void)animationView:(UIView *)aView
                fromX:(float)fromX
                fromY:(float)fromY
                  toX:(float)toX
                  toY:(float)toY
                delay:(float)delayTime
             duration:(float)durationTime
        finishedBlock:(void (^)(void))continuAnimations_;
@end
