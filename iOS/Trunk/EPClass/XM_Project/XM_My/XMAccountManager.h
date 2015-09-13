//
//  XMAccountManager.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/6/25.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM (NSInteger, XMAccountLoginSource){
    XMAccountLoginSourceAccount,//我的账户
    XMAccountLoginSourcePay,//结账
    XMAccountLoginSourceBanners //活动
};

typedef NS_ENUM (NSInteger, XMAccountLoginOpenType){
    XMAccountLoginOpenNormal , //正常
    XMAccountLoginOpenPopup    //弹出
};

typedef void(^LoginSuccess)(id code);
typedef void(^LoginFail)(NSString *msg);

@interface XMAccountManager : NSObject
//打开方式
@property (nonatomic,assign)XMAccountLoginOpenType   mOpenType;


@end
