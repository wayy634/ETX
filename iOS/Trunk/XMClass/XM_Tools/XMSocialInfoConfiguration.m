//
//  XMSocialInfoConfiguration.m
//  XiaoMai
//
//  Created by chenzb on 15/6/23.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMSocialInfoConfiguration.h"
//友盟分享
#import "UMSocialConfig.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialQQHandler.h"

@implementation XMSocialInfoConfiguration

//友盟社会化配置，配置分享平台的appkey，id等
+ (void)umengSocialInfoConfiguration {
    //如果没有安装建议隐藏
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:K_WECHAT_APP_ID appSecret:K_WECHAT_APP_SECRET url:@"http://www.umeng.com/social"];
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:K_QQ_APP_ID appKey:K_QQ_APP_KEY url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关
}


+ (void)shareWeCahtSourceViewController:(UIViewController*)sourceViewController_ type:(xmShare_type)type_ url:(NSString *)url_  {

    NSString *iconName = @"";
    NSString *title    = @"";
    NSString *desc     = @"";
    if (type_ == xmShare_type_invitation_gift) {
        title = @"小麦的新伙伴，送你6元新手优惠券，快来领取吧";
        desc  = @"领取小麦新手优惠券,首单力减6元,同时为好友赢得6元优惠券奖励";
        iconName = @"icon_my_invitation_share.png";
    }else if (type_ == xmShare_type_pay_gift) {
        title = @"小麦红包砸过来了，做最好的校园电商，与你共成长！";
        desc  = @"点击领取小麦优惠券，物价回到十年前，校园便利新体验！";
        iconName = @"icon_my_pay.png";
    }
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url_;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url_;
    [UMSocialSnsService presentSnsIconSheetView:sourceViewController_
                                         appKey:K_UMENG_IOS_KEY
                                      shareText:desc
                                     shareImage:[UIImage imageNamed:iconName]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:nil];
}

+ (BOOL)handleOPenURL:(NSURL *)url_ {
    return [UMSocialSnsService handleOpenURL:url_];
}


@end
