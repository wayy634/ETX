//
//  CarEPConnectionFuction.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "CarEPConnectionFuction.h"

@implementation CarEPConnectionFuction

/*
 *新增车辆信息
 */
+ (void)userAddCar_Licensceid:(NSString *)licensceid_ licencename:(NSString *)licencename_ engineid:(NSString *)engineid_ lpn:(NSString *)lpn_ boughttime:(NSString *)boughttime_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userAddCar", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:licensceid_ forKey:@"licensceid"];
    [params setObject:licencename_ forKey:@"licencename"];
    [params setObject:engineid_ forKey:@"engineid"];
    [params setObject:lpn_ forKey:@"lpn"];
    [params setObject:boughttime_ forKey:@"boughttime"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *更新车辆信息
 */
+ (void)userUpdateCar_Licensceid:(NSString *)licensceid_ licencename:(NSString *)licencename_ engineid:(NSString *)engineid_ lpn:(NSString *)lpn_ boughttime:(NSString *)boughttime_  carid:(NSString *)carid_  delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userAddCar", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:licensceid_ forKey:@"licensceid"];
    [params setObject:licencename_ forKey:@"licencename"];
    [params setObject:engineid_ forKey:@"engineid"];
    [params setObject:lpn_ forKey:@"lpn"];
    [params setObject:boughttime_ forKey:@"boughttime"];
    [params setObject:carid_ forKey:@"carid"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *新增车库信息
 */
+ (void)userAddGarage_Estate:(NSString *)estate_ location:(NSString *)location_ type:(int)type_ area:(int)area_ isrent:(int)isrent_  rentfee:(NSString *)rentfee_  delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userAddGarage", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:estate_ forKey:@"estate"];
    [params setObject:location_ forKey:@"location"];
    [params setObject:[NSNumber numberWithInt:type_] forKey:@"type"];
    [params setObject:[NSNumber numberWithInt:area_] forKey:@"area"];
    [params setObject:[NSNumber numberWithInt:isrent_] forKey:@"isrent"];
    [params setObject:rentfee_ forKey:@"rentfee"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *更新车库信息
 */
+ (void)userUpdateGarage_Estate:(NSString *)estate_ location:(NSString *)location_ type:(int)type_ area:(int)area_ isrent:(int)isrent_  rentfee:(NSString *)rentfee_ garageid:(int)garageid_  delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userUpdateGarage", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:estate_ forKey:@"estate"];
    [params setObject:location_ forKey:@"location"];
    [params setObject:[NSNumber numberWithInt:type_] forKey:@"type"];
    [params setObject:[NSNumber numberWithInt:area_] forKey:@"area"];
    [params setObject:[NSNumber numberWithInt:isrent_] forKey:@"isrent"];
    [params setObject:rentfee_ forKey:@"rentfee"];
    [params setObject:[NSNumber numberWithInt:garageid_] forKey:@"garageid"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *获取用户车辆资料
 */
+ (void)userCarDelegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userCar", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"GET" delegate:delegate_ allowCancel:allowCancel_ mappingName:@"UserCarsList" urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *获取用户车库资料
 */
+ (void)userGarageDelegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userGarage", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"GET" delegate:delegate_ allowCancel:allowCancel_ mappingName:@"UserCarsList" urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

@end
