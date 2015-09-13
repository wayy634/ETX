//
//  XMSocialInfoConfiguration.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/6/23.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XM_INVITATION_SHARE_TITLE   @"小麦红包砸过来了，做最好的校园电商，与你共成长！"
#define XM_INVITATION_SHARE_DESC    @"点击领取小麦优惠券，物价回到十年前，校园便利新体验！"
#define XM_INVITATION_SHARE_PAYGIFT_URL     @"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxd888b8a9c5763733&redirect_uri=http://weixin.test.imEPASS-APP-iOS.com%2foauth%2fredirect&response_type=code&scope=snsapi_base&state=%7B%22url%22%3A%22http%3a%2f%2fwap.tmall.imEPASS-APP-iOS.com%2fpage%2fbonus%2fsuccess.html%3fuserId%3d%ld%26orderId%3d%ld%22%2C%20%22type%22%3A%22base%22%7D#wechat_redirect"

#define XM_INVITATION_SHARE_INVITATIONGIFT_URL @"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxd888b8a9c5763733&redirect_uri=http://weixin.test.imEPASS-APP-iOS.com%2foauth%2fredirect&response_type=code&scope=snsapi_base&state=%7B%22url%22%3A%22http%3a%2f%2fwap.tmall.imEPASS-APP-iOS.com%2fpage%2fbonus%2finvitedFriend.html%3fuserId%3d%@%22%2C%20%22type%22%3A%22base%22%7D#wechat_redirect"


typedef NS_ENUM(NSInteger, xmShare_type) {
    xmShare_type_pay_gift          =  0,//支付红包
    xmShare_type_invitation_gift   = 1  //邀请红包
};


@interface XMSocialInfoConfiguration : NSObject

//友盟社会化配置，配置分享平台的appkey，id等
+ (void)umengSocialInfoConfiguration;

+ (void)shareWeCahtSourceViewController:(UIViewController*)sourceViewController_ type:(xmShare_type)type_ url:(NSString *)url_;

+ (BOOL)handleOPenURL:(NSURL *)url_;

@end
