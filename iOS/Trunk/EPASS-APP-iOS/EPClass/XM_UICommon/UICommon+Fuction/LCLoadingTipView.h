//
//  LCLoadingTipView.h
//  LeCai
//
//  Created by HXG on 9/5/14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LCLoadingTipView : UIView

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, assign, readonly) BOOL visible;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message withIndicator:(BOOL)shouldShowIndicator;

- (void)show;
- (void)dismiss;

- (void)enableTapDismiss:(BOOL)enabled;

@end
