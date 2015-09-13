//
//  LCNotificationFloatView.h
//  LeCai
//
//  Created by HXG on 3/12/15.
//
//

#import <UIKit/UIKit.h>

@interface LCNotificationFloatView : UIView

+ (LCNotificationFloatView *)showFloatViewWithImage:(UIImage *)iconImage_
                                          titleInfo:(NSString *)titleInfo_
                                         detailInfo:(NSString *)detailInfo_;

+ (LCNotificationFloatView *)showFloatViewWithDetailInfo:(NSString *)detailInfo_;

@end
