//
//  UIView+CSAddition.m
//  CSComponents
//
//  Created by HXG on 2/9/14.
//  Copyright (c) 2014 WangHui. All rights reserved.
//

#import "UIView+CSAddition.h"

@implementation UIView (CSAddition)

+ (instancetype)csViewFromNib:(NSString *)nibName
{
    NSString *realNibName = nil;
    if (nibName.length > 0) {
        realNibName = nibName;
    } else {
        realNibName = NSStringFromClass([self class]);
    }
    
    NSArray *allObjects = [[NSBundle mainBundle] loadNibNamed:realNibName owner:nil options:nil];
    for (id aObject in allObjects) {
        if ([aObject isKindOfClass:[self class]]) {
            return aObject;
        }
    }
    
    return nil;
}

- (CGFloat)csTop
{
    return self.frame.origin.y;
}

- (CGFloat)csBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)csLeft
{
    return self.frame.origin.x;
}

- (CGFloat)csRight
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)csHeight
{
    return self.frame.size.height;
}

- (CGFloat)csWidth
{
    return self.frame.size.width;
}

- (UIImage *)imageFromView {
    return [self imageFromDestFrame:self.bounds];
}

- (UIImage *)imageFromDestFrame:(CGRect)destFrame {
    UIGraphicsBeginImageContextWithOptions(destFrame.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -(destFrame.origin.x), -(destFrame.origin.y));
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end