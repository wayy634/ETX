//
//  RechargeEPConnectionFuction.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "RechargeEPConnectionFuction.h"

@implementation RechargeEPConnectionFuction

/*
 *新增充值记录
 * type    0/1/2 : 支付宝/银联/微信
 */
+ (void)userCharge_Type:(int)type_ billsno:(NSString *)billsno_ money:(NSString *)money_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userCharge", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:billsno_ forKey:@"billsno"];
    [params setObject:money_ forKey:@"money"];
    [params setObject:[NSNumber numberWithInt:type_] forKey:@"type"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

/*
 *新增账户绑定
 * type    0/1/2 : 支付宝/银联/微信
 */
+ (void)userBindAccount_Type:(int)type_ accountname:(NSString *)accountname_ accountholder:(NSString *)accountholder_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_ {

    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url appendFormat:@"%@/epass/userCharge", K_URL_HOST];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:accountname_ forKey:@"accountname"];
    [params setObject:accountholder_ forKey:@"accountholder"];
    [params setObject:[NSNumber numberWithInt:type_] forKey:@"type"];
    
    [params setObject:[EPAccountManager getAccountData].mUserToken forKey:@"token"];
    [params setObject:@"" forKey:@"deviceId"];
    
    [LTools startAsynchronousUrl:url parameter:params method:@"POST" delegate:delegate_ allowCancel:allowCancel_ mappingName:nil urlCacheMode:NO finishSelector:finishSEL_ failSelector:failSEL_ timeOutSelector:timeOutSEL_];
    params = nil;
    url = nil;
}

@end
