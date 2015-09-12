//
//  LCGifView.h
//  LeCai
//
//  Created by lehecaiminib on 14-12-19.
//
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define K_LCGIFVIEW_WIDTHANDHEIGHT 60

@interface LCGifView : UIView
{
    CGImageSourceRef gif; // 保存gif动画
    NSDictionary *gifProperties; // 保存gif动画属性
    size_t index; // gif动画播放开始的帧序号
    size_t count; // gif动画的总帧数
    NSTimer *timer; // 播放gif动画所使用的timer
    UIView  *contentV;
}

- (id)initWithFrame:(CGRect)frame filePathName:(NSString *)filePathName;

+ (LCGifView *)gifViewOnSuperView:(UIView *)parentView gifName:(NSString *)gifName;

- (void)playGif;
- (void)stopGif;
@end
