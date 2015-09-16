//
//  UserEPConnectionFuction.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/16.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "UserEPConnectionFuction.h"

@implementation UserEPConnectionFuction

/**
 * login接口并返回用户信息包含token
 */
+ (void)userLogin_Phone:(NSString *)phone_ password:(NSString *)password_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userLogin", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:phone_ forKey:@"phone"];
    [params setObject:password_ forKey:@"password"];
    
    [params setObject:@"" forKey:@"token"];
    [params setObject:@"" forKey:@"deviceid"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *注册接口
 */
+ (void)registered_Phone:(NSString *)phone_ password:(NSString *)password_ sendCode:(NSString *)sendCode_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userRegister", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:[NSNumber numberWithInt:[phone_ intValue]] forKey:@"phone"];
    [params setObject:password_ forKey:@"password"];
    [params setObject:[NSNumber numberWithInt:[sendCode_ intValue]] forKey:@"checkcode"];
    
    [params setObject:@"" forKey:@"deviceid"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *登出接口
 */
+ (void)userLoginOutDelegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userLogout", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:@"" forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

@end
