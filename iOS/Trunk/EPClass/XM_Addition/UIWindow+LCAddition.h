//
//  UIWindow+LCAddition.h
//  LeCai
//
//  Created by HXG on 9/28/14.
//
//

#import <UIKit/UIKit.h>

@interface UIWindow (LCAddition)

+ (UIWindow *)lcTopWindow:(BOOL *)created;

+ (UIWindow *)lcCurrentTopWindow;

@end
