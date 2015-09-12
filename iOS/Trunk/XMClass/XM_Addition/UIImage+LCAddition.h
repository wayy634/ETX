//
//  UIImage+LCAddition.h
//  LeCai
//
//  Created by HXG on 3/14/15.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (LCAddition)

- (UIImage *)imageByScaleingToMinimumSize:(CGSize)targetSize_;
- (UIImage *)scaleImageWithFactor:(CGFloat)scaleFactor_;

@end
