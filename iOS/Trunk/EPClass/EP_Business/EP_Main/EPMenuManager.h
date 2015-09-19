//
//  EPMenuManager.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/19.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EPLeftMenuType) {
    EPLeftMenuType_Today          = 0,
    EPLeftMenuType_Recharge       = 1,
    EPLeftMenuType_BindingDevice  = 2,
    EPLeftMenuType_Order          = 3,
    EPLeftMenuType_MyDevice       = 4,
    EPLeftMenuType_Account        = 5
};

@interface EPMenuManager : NSObject



+ (EPMenuManager *)sharedMenuManager;

/*
 * 获取根目录
 */
- (LCCustomBaseVC *)getRootVCbyType:(EPLeftMenuType)type_;

@end
