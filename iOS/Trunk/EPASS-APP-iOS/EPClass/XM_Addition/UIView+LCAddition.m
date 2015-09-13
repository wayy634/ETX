//
//  UIView+LCAddition.m
//  LeCai
//
//  Created by HXG on 9/29/14.
//
//

#import "UIView+LCAddition.h"

@implementation UIView (LCAddition)

+ (id)viewFromNib:(NSString *)nibName
{
    NSString *realNibName = nil;
    
    if (nibName.length > 0) {
        realNibName = nibName;
    } else {
        realNibName = NSStringFromClass([self class]);
    }
    
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:realNibName owner:nil options:nil];
    
    for (id aObject in viewArray) {
        if ([aObject isKindOfClass:[self class]]) {
            return aObject;
        }
    }
    
    return nil;
}

@end