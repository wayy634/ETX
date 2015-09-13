//
//  LCAdButton.h
//  LeCai
//
//  Created by HXG on 12/27/14.
//
//

#import <UIKit/UIKit.h>

@protocol LCAdButtonDelegate;
@interface LCAdButton : UIView

@property (assign, nonatomic) id<LCAdButtonDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<LCAdButtonDelegate>)delegate;
+ (id)buttonWithFrame:(CGRect)frame delegate:(id<LCAdButtonDelegate>)delegate;

- (void)setImage:(UIImage *)aImage;
- (void)setPlaceHolderImage:(UIImage *)phImage remoteURL:(NSString *)imageURL;

@end

@protocol LCAdButtonDelegate <NSObject>

- (void)buttonClickedInAdButton:(LCAdButton *)adButton;

@end