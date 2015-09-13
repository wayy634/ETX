//
//  XMNavigationProcessC.h
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/7/10.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XMNavigationProcessCType) {
    XMNavigationProcessCTypeShow = 0,
    XMNavigationProcessCTypeDisappear = 1
};

typedef void(^compltePrecess)();
@interface XMNavigationProcessC : UINavigationController

@property (nonatomic, strong)compltePrecess mCompltePrecess;

+ (XMNavigationProcessC *)sharedXMNavigationProcessC;

- (void)initProcessRootViewController:(id)controller_ completeProcess:(compltePrecess)block_;

- (void)animation:(XMNavigationProcessCType)type_ completion:(void (^)(BOOL finished))completion_;

+ (void)XMPushViewController:(UIViewController *)vc_ animated:(BOOL)animated_;

+ (void)XMPopViewControllerAnimated:(BOOL)animated_;

+ (void)XMPopToRootViewControllerAnimated:(BOOL)animated_;
@end
