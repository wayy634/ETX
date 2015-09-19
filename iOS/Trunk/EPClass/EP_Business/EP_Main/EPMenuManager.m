//
//  EPMenuManager.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/19.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPMenuManager.h"

#import "EPAccountVC.h"
#import "EPTodayVC.h"
#import "EPRechargeVC.h"
#import "EPBindingDeviceVC.h"
#import "EPOrderVC.h"
#import "EPDeviceVC.h"
#import "EPSettingVC.h"
#import "EPAccountManager.h"

@interface EPMenuManager ()

@property(nonatomic,strong)NSMutableDictionary  *mRootVCDic;//根视图的字典

@end


@implementation EPMenuManager


+ (EPMenuManager *)sharedMenuManager {
    static EPMenuManager *_sharedMenuManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMenuManager = [[EPMenuManager alloc] init];
    });
    return _sharedMenuManager;
}
//获取对应的跟页面

- (LCCustomBaseVC *)getRootVCbyType:(EPLeftMenuType)type_ {
    
    if (!self.mRootVCDic) {
        self.mRootVCDic = [[NSMutableDictionary alloc] init];
    }
    LCCustomBaseVC *object = nil;
    object = [self.mRootVCDic objectForKey:[NSString stringWithFormat:@"%i",(int)(type_ == EPLeftMenuType_BindingDevice ?EPLeftMenuType_MyDevice : type_)]];
    if (object != nil) {
        return object;
    }
    switch (type_) {
        case EPLeftMenuType_Account:{
            EPAccountVC *accountVC = [[EPAccountVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCDic setObject:accountVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
            object = accountVC;
            [accountVC release];
            break;
        }
        case EPLeftMenuType_Today:{
            EPTodayVC *todayVC = [[EPTodayVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCDic setObject:todayVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
            object = todayVC;
            [todayVC release];
            break;
        }
        case EPLeftMenuType_Recharge:{
            EPRechargeVC *rechargeVC = [[EPRechargeVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCDic setObject:rechargeVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
            object = rechargeVC;
            [rechargeVC release];
            break;
        }
        case EPLeftMenuType_BindingDevice:{
            EPDeviceVC *deviceVC = [[EPDeviceVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCDic setObject:deviceVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
            object = deviceVC;
            [deviceVC release];
            break;
        }
        case EPLeftMenuType_Order:{
            EPOrderVC *orderVC = [[EPOrderVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCDic setObject:orderVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
            object = orderVC;
            [orderVC release];
            break;
        }
        case EPLeftMenuType_MyDevice:{
            EPDeviceVC *deviceVC = [[EPDeviceVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCDic setObject:deviceVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
            object = deviceVC;
            [deviceVC release];
            break;
        }
    }
    return object;
}


@end
