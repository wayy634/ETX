//
//  EPAccountManager.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/16.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPAccountManager.h"

@implementation EPAccountManager

+ (EPAccountManager *)sharedAccountManager {
    static EPAccountManager *_sharedAccountManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAccountManager = [[EPAccountManager alloc] init];
    });
    return _sharedAccountManager;
}

+ (EPAccountData *)getAccountData {
    EPAccountData  *myData = [[XMCacheManager shareCacheManager] getClassCache:K_CACHE_ACCOUNTINFO];
    if (!myData) {
        myData = [[EPAccountData alloc] init];
    }
    return myData;
}

+ (void)saveAccountData:(EPAccountData *)accountData_ {
    [[XMCacheManager shareCacheManager] saveClassCache:accountData_ key:K_CACHE_ACCOUNTINFO];
}

@end
