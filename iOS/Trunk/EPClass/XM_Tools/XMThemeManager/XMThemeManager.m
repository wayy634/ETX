//
//  XMThemeManager.m
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/6/4.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMThemeManager.h"

@implementation XMThemeManager

+ (XMThemeManager *)sharedThemeManager {
    static XMThemeManager *LCSharedThemeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LCSharedThemeManager = [[XMThemeManager alloc] init];
    });
    return LCSharedThemeManager;
}

#pragma mark - public
- (UIColor *)getAppThemeColor {
    return self.mThemeManagerType == XMThemeManagerTypeNormal?[LTools colorWithHexString:@"ff5201"]:[LTools colorWithHexString:@"0090ff"];
}

@end
