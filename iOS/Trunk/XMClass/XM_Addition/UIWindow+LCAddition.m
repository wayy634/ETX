//
//  UIWindow+LCAddition.m
//  LeCai
//
//  Created by HXG on 9/28/14.
//
//

#import "UIWindow+LCAddition.h"

@implementation UIWindow (LCAddition)

+ (UIWindow *)lcTopWindow:(BOOL *)created
{
    BOOL tmpCreated = NO;
    UIWindow *aWindow = [UIApplication sharedApplication].keyWindow;
    if (!aWindow) {
        if ([[UIApplication sharedApplication].windows count] > 0) {
            aWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        } else {
            tmpCreated = YES;
            aWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            aWindow.windowLevel = UIWindowLevelAlert;
            aWindow.backgroundColor = [UIColor clearColor];
            [aWindow autorelease];
        }
    }
    
    if (created != NULL) {
        *created = tmpCreated;
    }
    
    return aWindow;
}

+ (UIWindow *)lcCurrentTopWindow
{
    UIWindow *aWindow = [UIApplication sharedApplication].keyWindow;
    if (!aWindow) {
        if ([[UIApplication sharedApplication].windows count] > 0) {
            aWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        } else {
//            aWindow = APP_DELEGATE.mWindow;
        }
    }
    return aWindow;
}

@end
