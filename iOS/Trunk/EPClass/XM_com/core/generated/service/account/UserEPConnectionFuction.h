//
//  UserEPConnectionFuction.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/16.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEPConnectionFuction : NSObject

/*
 *登陆接口
 */
+ (void)userLogin_Phone:(NSString *)phone_ password:(NSString *)password_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;
/*
 *注册接口
 */
+ (void)registered_Phone:(NSString *)phone_ password:(NSString *)password_ sendCode:(NSString *)sendCode_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *修改密码
 */
+ (void)userModifyPwd_OldPwd:(NSString *)oldPwd_ newPwd:(NSString *)newPwd_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *忘记密码
 */
+ (void)userForgetPwd_Phone:(NSString *)phone_ code:(NSString *)code_ newPwd:(NSString *)newPwd_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *更新资料
 */
+ (void)userUpdateProfile_NickName:(NSString *)nickName_ realName:(NSString *)realName_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *用户注销
 */
+ (void)userLoginOutDelegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *获取用户资料
 */
+ (void)userProfileDelegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *获取短信验证码
 */
+ (void)phoneCode_mobile:(NSString *)mobile delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;



/************用户车辆的接口***********/


@end
