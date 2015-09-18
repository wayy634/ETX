//
//  RechargeEPConnectionFuction.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeEPConnectionFuction : NSObject

/*
 *新增充值记录
 * type    0/1/2 : 支付宝/银联/微信
 */
+ (void)userCharge_Type:(int)type_ billsno:(NSString *)billsno_ money:(NSString *)money_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *新增账户绑定
 * type    0/1/2 : 支付宝/银联/微信
 */
+ (void)userBindAccount_Type:(int)type_ accountname:(NSString *)accountname_ accountholder:(NSString *)accountholder_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

@end
