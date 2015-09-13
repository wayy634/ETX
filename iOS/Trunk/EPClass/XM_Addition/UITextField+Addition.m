//
//  UITextField+Addition.m
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/7/1.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "UITextField+Addition.h"
#import <objc/runtime.h>

@implementation UITextField (Addition)
static char UITextFieldAddtion;
@dynamic regularExpressionArray;

- (void)setRegularExpressionArray:(NSArray *)array_ {
    objc_setAssociatedObject(self, &UITextFieldAddtion,
                             [array_ retain],
                             OBJC_ASSOCIATION_ASSIGN);
}

- (NSArray *)regularExpressionArray {
    return objc_getAssociatedObject(self, &UITextFieldAddtion);
}

- (BOOL)checkRegularExpression:(void (^)(NSString *msg))error_ {
    for (int i = 0 ;i < self.regularExpressionArray.count ;i++) {
        if (![[NSPredicate predicateWithFormat:[[self.regularExpressionArray objectAtIndex:i] objectAtIndex:0]] evaluateWithObject:self.text]) {
            error_([[self.regularExpressionArray objectAtIndex:i] lastObject]);
            return NO;
        }
    }
    return YES;
}

- (void)dealloc {
    self.regularExpressionArray = nil;
    [super dealloc];
}
@end
