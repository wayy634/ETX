//
//  XMAccountManager.m
//  XiaoMai
//
//  Created by chenzb on 15/6/25.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//


#import "XMAccountManager.h"

@interface XMAccountManager ()

@property (nonatomic,assign)XMAccountLoginSource     mSource;
@property (nonatomic,assign)UIViewController        *mSourceController;//进入的页面
@property (nonatomic,assign)UIViewController        *mEndController;//最后离开的页面

@property (nonatomic,strong)LoginSuccess             mSuccess;
@property (nonatomic,strong)LoginFail                mFail;


//统一的登陆注册
@property (nonatomic,strong)NSString             *mUserName;
@property (nonatomic,strong)NSString             *mPassWord;
@end

@implementation XMAccountManager

@end
