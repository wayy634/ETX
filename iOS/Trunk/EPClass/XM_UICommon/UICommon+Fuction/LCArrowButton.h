//
//  LCArrowButton.h
//  LeCai
//
//  Created by HXG on 12/10/14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol LCArrowButtonDelegate;
@interface LCArrowButton : UIView

@property (assign, nonatomic) id<LCArrowButtonDelegate> delegate;
@property (assign, nonatomic) CGFloat offset;
@property (assign, nonatomic) BOOL selected;

- (void)setTitle:(NSString *)title;
- (NSString *)currentTitle;

@end


@protocol LCArrowButtonDelegate <NSObject>
- (BOOL)shouldSelectArrowButton:(LCArrowButton *)arrowButton;
- (void)clickedAtArrowButton:(LCArrowButton *)arrowButton;
@end