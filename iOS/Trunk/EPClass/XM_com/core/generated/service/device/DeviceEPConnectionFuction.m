//
//  DeviceEPConnectionFuction.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "DeviceEPConnectionFuction.h"

@implementation DeviceEPConnectionFuction

/*
 *新增设备信息
 */
+ (void)userAddDevice_Etcdevice:(NSString *)etcdevice_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userAddDevice", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:etcdevice_ forKey:@"etcdevice"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *解绑设备
 */
+ (void)userUnbindDevice_Etcdevice:(NSString *)etcdevice_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userUnbindDevice", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:etcdevice_ forKey:@"etcdevice"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *获取设备信息
 */
+ (void)userDevice_Etcdevice:(NSString *)etcdevice_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userDevice", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:etcdevice_ forKey:@"etcdevice"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

@end
