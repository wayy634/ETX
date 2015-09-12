//
//  XMPayManager.h
//  XiaoMai
//
//  Created by chenzb on 15/8/13.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface XMPayManager : NSObject

+ (XMPayManager *)sharedPayManager;

//注册第三方支付信息
+ (void)registerThirdpartyPayBaseInfo;

//微信支付的回调
- (BOOL)weChatHandleOPenURL:(NSURL *)url_;

//支付宝支付的回调
- (BOOL)aliPayHandleOPenURL:(NSURL *)url_;

//支付发起请求
//- (void)sendPay:(OrderPay *)orderPay_ params:(NSMutableDictionary *)dic_ source:(UIViewController *)source_ type:(int)type_;
@end
