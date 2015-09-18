//
//  DeviceEPConnectionFuction.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceEPConnectionFuction : NSObject

/*
 *新增设备绑定
 */
+ (void)userAddDevice_Etcdevice:(NSString *)etcdevice_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *解绑设备
 */
+ (void)userUnbindDevice_Etcdevice:(NSString *)etcdevice_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *获取设备信息
 */
+ (void)userDevice_Etcdevice:(NSString *)etcdevice_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

@end
