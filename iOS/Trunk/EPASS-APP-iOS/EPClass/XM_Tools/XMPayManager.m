//
//  XMPayManager.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/8/13.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMPayManager.h"
#import "WXApiObject.h"

#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import "AlipayOrder.h"

@interface XMPayManager ()<WXApiDelegate>

@property(nonatomic, strong)NSMutableDictionary *mParams;
@property(nonatomic, assign)int                  mPayType;

@property(nonatomic, assign)BOOL                 mWeChatPayResp;//微信支付回调

@end

@implementation XMPayManager

+ (XMPayManager *)sharedPayManager {
    static XMPayManager *_sharedPayManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPayManager = [[XMPayManager alloc] init];
    });
    return _sharedPayManager;
}


+ (void)registerThirdpartyPayBaseInfo {
    //向微信注册
    [WXApi registerApp:K_WECHAT_APP_ID withDescription:@"EPASS-APP-iOS"];
}

- (BOOL)weChatHandleOPenURL:(NSURL *)url_ {
    return [WXApi handleOpenURL:url_ delegate:self];
}

- (BOOL)aliPayHandleOPenURL:(NSURL *)url_ {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url_ standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    
    return YES;
}

//- (void)sendPay:(OrderPay *)orderPay_ params:(NSMutableDictionary *)dic_ source:(UIViewController *)source_ type:(int)type_ {
//    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
//    self.mOrderPay = orderPay_;
//    self.mParams = dic_;
//    self.mPayType = type_;
//    self.mWeChatPayResp = NO;
//    if (type_ == 1) {
//        [self weChatPay];
//    }else if (type_ == 2)  {
//        [self aliPay];
//    }
//
//}

//- (void)weChatPay {
//    if(![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]){
//        return;
//    }
//    PayReq* req     = [[[PayReq alloc] init]autorelease];
//    req.openID      = self.mOrderPay.prepayData.appId;
//    req.partnerId   = self.mOrderPay.prepayData.partnerid;
//    req.prepayId    = self.mOrderPay.prepayData.prepayid;
//    req.nonceStr    = self.mOrderPay.prepayData.noncestr;
//    req.timeStamp   = (UInt32)[self.mOrderPay.prepayData.timestamp intValue];
//    req.package     = self.mOrderPay.prepayData.package;
//    req.sign        = self.mOrderPay.prepayData.sign;
//    [WXApi sendReq:req];
//}
//
//- (void)aliPay {
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    AlipayOrder *order = [[AlipayOrder alloc] init];
//    order.partner = self.mOrderPay.prepayData.partner;
//    order.seller = self.mOrderPay.prepayData.seller_id;
//    order.tradeNO = self.mOrderPay.prepayData.out_trade_no; //订单ID（由商家自行制定）
//    order.productName = self.mOrderPay.prepayData.subject; //商品标题
//    order.productDescription =self.mOrderPay.prepayData.body; //商品描述
//    order.amount =self.mOrderPay.prepayData.total_fee; //商品价格
//    order.notifyURL =  self.mOrderPay.prepayData.notify_url; //回调URL
//    
//    order.service =self.mOrderPay.prepayData.service;
//    order.paymentType = self.mOrderPay.prepayData.payment_type;
//    order.inputCharset = self.mOrderPay.prepayData._input_charset;
//    order.itBPay = self.mOrderPay.prepayData.it_b_pay;
//    order.showUrl = self.mOrderPay.prepayData.show_url;
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    id<DataSigner> signer = CreateRSADataSigner(self.mOrderPay.prepayData.aliPrivate);
//    NSString *signedString = [signer signString:[order description]];
//    
//    
//    NSString * orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       [order description],signedString , @"RSA"];
//        
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"EPASS-APP-iOSPay" callback:^(NSDictionary *resultDic) {
//        [self payResult:[[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]];
//    }];
//}


#pragma mark-----WXApiDelegate----------

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        if (!self.mWeChatPayResp) {
            self.mWeChatPayResp = YES;
            [self payResult:resp.errCode >=0];
        }
        
    }
}


- (void)payResult:(int)successs_ {
    
}
@end
