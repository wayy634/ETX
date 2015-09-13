//
//  XMThemeManager.h
//  XiaoMai
//
//  Created by Jeanne on 15/6/4.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XMThemeManagerType) {
    XMThemeManagerTypeNormal = 0,
    XMThemeManagerTypeFast = 1
};

@interface XMThemeManager : NSObject

@property (assign) XMThemeManagerType mThemeManagerType;

+ (XMThemeManager *)sharedThemeManager;

- (UIColor *)getAppThemeColor;
@end
