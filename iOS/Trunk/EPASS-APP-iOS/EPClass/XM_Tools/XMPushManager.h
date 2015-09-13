//
//  XMPushManager.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/1.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMPushManager : NSObject

+ (XMPushManager *)sharedPushManager;

- (void)pushVCbyAddress:(NSDictionary *)address_;

@end
