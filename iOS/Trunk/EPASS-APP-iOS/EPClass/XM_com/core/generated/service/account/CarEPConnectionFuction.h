//
//  CarEPConnectionFuction.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarEPConnectionFuction : NSObject


/*
 *新增车辆信息
 */
+ (void)userAddCar_Licensceid:(NSString *)licensceid_ licencename:(NSString *)licencename_ engineid:(NSString *)engineid_ lpn:(NSString *)lpn_ boughttime:(NSString *)boughttime_ delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *更新车辆信息
 */
+ (void)userUpdateCar_Licensceid:(NSString *)licensceid_ licencename:(NSString *)licencename_ engineid:(NSString *)engineid_ lpn:(NSString *)lpn_ boughttime:(NSString *)boughttime_  carid:(NSString *)carid_  delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *新增车库信息
 */
+ (void)userAddGarage_Estate:(NSString *)estate_ location:(NSString *)location_ type:(int)type_ area:(int)area_ isrent:(int)isrent_  rentfee:(NSString *)rentfee_  delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *更新车库信息
 */
+ (void)userUpdateGarage_Estate:(NSString *)estate_ location:(NSString *)location_ type:(int)type_ area:(int)area_ isrent:(int)isrent_  rentfee:(NSString *)rentfee_ garageid:(int)garageid_  delegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *获取用户车辆资料
 */
+ (void)userCarDelegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

/*
 *获取用户车库资料
 */
+ (void)userGarageDelegate:(id)delegate_ allowCancel:(BOOL)allowCancel_ finishSelector:(SEL)finishSEL_ failSelector:(SEL)failSEL_ timeOutSelector:(SEL)timeOutSEL_;

@end
