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
    [params setObject:[NSNumber numberWithInt:[phone_ intValue]] forKey:@"mobile"];
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
//    [params setObject:[NSNumber numberWithInt:[phone_ intValue]] forKey:@"phone"];
    [params setObject:phone_ forKey:@"mobile"];
    [params setObject:password_ forKey:@"password"];
    [params setObject:[NSNumber numberWithInt:[sendCode_ intValue]] forKey:@"checkcode"];
    [params setObject:@"" forKey:@"token"];
    [params setObject:@"" forKey:@"deviceid"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *修改密码
 */
+ (void)userModifyPwd_OldPwd:(NSString *)oldPwd_ newPwd:(NSString *)newPwd_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userModifyPwd", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:oldPwd_ forKey:@"oldpwd"];
    [params setObject:newPwd_ forKey:@"newpwd"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *忘记密码
 */
+ (void)userForgetPwd_Phone:(NSString *)phone_ code:(NSString *)code_ newPwd:(NSString *)newPwd_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userForgetPwd", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:phone_ forKey:@"mobile"];
    [params setObject:[NSNumber numberWithInt:[code_ intValue]] forKey:@"code"];
    [params setObject:newPwd_ forKey:@"newpwd"];
    
    [params setObject:@"" forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *更新资料
 */
+ (void)userUpdateProfile_NickName:(NSString *)nickName_ realName:(NSString *)realName_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userUpdateProfile", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:nickName_ forKey:@"nickname"];
    [params setObject:realName_ forKey:@"realname"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
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

/*
 *获取用户资料
 */
+ (void)userProfileDelegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userProfile", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"GET" delegate:delegate_ allowCancel:allowCancel_ mappingName:@"UserInfo" urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *获取短信验证码
 */
+ (void)phoneCode_mobile:(NSString *)mobile delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_{

    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/phoneCode", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:mobile forKey:@"mobile"];
//    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"token"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"GET" delegate:delegate_ allowCancel:allowCancel_ mappingName:@"PhoneCode" urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;

}

/************用户新增车辆的接口***********/



@end
