//
//  XMPushManager.m
//  XiaoMai
//
//  Created by chenzb on 15/9/1.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMPushManager.h"

@implementation XMPushManager

+ (XMPushManager *)sharedPushManager {
    static XMPushManager *_sharedPushManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPushManager = [[XMPushManager alloc] init];
    });
    return _sharedPushManager;
}

- (void)pushVCbyAddress:(NSDictionary *)address_ {
    
}

@end
