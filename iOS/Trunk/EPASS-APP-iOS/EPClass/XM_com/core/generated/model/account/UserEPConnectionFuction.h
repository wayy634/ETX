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
 *用户注销
 */
+ (void)userLoginOutDelegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;
@end
