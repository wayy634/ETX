//
//  LCSwitch.h
//  LeCai
//
//  Created by lehecaiminib on 15-3-11.
//
//

#import <UIKit/UIKit.h>

@protocol LCSwitchDelegate <NSObject>
@required
- (void)switchTap;
@end
@interface LCSwitch : UIView {
    UIImageView          *mActiveImageView;
    UIImageView          *mBackGroundImageView;
    id<LCSwitchDelegate>  mDelegate;
}

@property (assign)BOOL          switchOn;

- (id)initWithPosition:(CGPoint)point_ onImage:(UIImage *)onImage_ offImage:(UIImage *)offImage_ backGroundImage:(UIImage *)backGroundImage_ delegate:(id)delegate_;
- (void)handleTap;
@end
