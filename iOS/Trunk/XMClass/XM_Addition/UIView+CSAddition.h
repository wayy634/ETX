//
//  UIView+CSAddition.h
//  CSComponents
//
//  Created by HXG on 2/9/14.
//  Copyright (c) 2014 WangHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CSAddition)

+ (instancetype)csViewFromNib:(NSString *)nibName;

- (CGFloat)csTop;
- (CGFloat)csBottom;
- (CGFloat)csLeft;
- (CGFloat)csRight;
- (CGFloat)csHeight;
- (CGFloat)csWidth;

- (UIImage *)imageFromView;
- (UIImage *)imageFromDestFrame:(CGRect)destFrame;

@end
