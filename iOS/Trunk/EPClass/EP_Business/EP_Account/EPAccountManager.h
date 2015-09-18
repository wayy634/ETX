//
//  EPAccountManager.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/16.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPAccountData.h"

@interface EPAccountManager : NSObject

+ (EPAccountManager *)sharedAccountManager;

+ (EPAccountData *)getAccountData;

+ (void)saveAccountData:(EPAccountData *)accountData_;

@end
