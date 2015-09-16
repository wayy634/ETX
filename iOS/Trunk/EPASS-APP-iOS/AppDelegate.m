//
//  AppDelegate.m
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/5/4.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "AppDelegate.h"
#import "XMSocialInfoConfiguration.h"
#import "XMPayManager.h"
#import "UIAlertView+Block.h"
#import "UMSocialData.h"
#import "XMPushManager.h"
#import "XMHomePageVC.h"


//
#import "DDMenuController.h"
#import "EPLeftVC.h"
#import "EPCenterVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    [self initData];
//    [[XMThreadCountDownManager sharedXMThreadCountDownManager] runThread];
//
//
//    [XMThemeManager sharedThemeManager].mThemeManagerType = XMThemeManagerTypeNormal;
//    [LTools bottomMenuVSelected:XMBottomMenuVTypeHomePage animation:YES];
    //友盟分享平台参数配置
//    [XMSocialInfoConfiguration umengSocialInfoConfiguration];
    
    //微信支付注册
//    [XMPayManager registerThirdpartyPayBaseInfo];
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    self.mWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.mWindow setBackgroundColor:[UIColor clearColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.mWindow.rootViewController = self.mNavigationController;
    [self.mWindow makeKeyAndVisible];
    self.mDDMenu = [[DDMenuController alloc] init];
    EPLeftVC *leftVC = [[EPLeftVC alloc]init];
    EPCenterVC *centerVC = [[EPCenterVC alloc]init];
    self.mNavigationController = [[UINavigationController alloc] initWithRootViewController:centerVC];
    [self.mNavigationController setNavigationBarHidden:YES];
    [self.mNavigationController.view setBackgroundColor:[UIColor whiteColor]];
    self.mDDMenu.leftViewController = leftVC;
    self.mDDMenu.rootViewController = self.mNavigationController;
    self.mWindow.rootViewController = self.mDDMenu;
    // push--------------------------
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    } else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    }
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenStr = [[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"token-----%@",deviceToken);
    [LTools setObjectFromSystem:[LTools trimManual:deviceTokenStr] key:K_KEY_DEVICE_TOKEN];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"error = %@",error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL) {
        NSDictionary *alertData = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if (state == UIApplicationStateActive){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[alertData objectForKey:@"title"]
                                                               message:[alertData objectForKey:@"description"]
                                                              delegate:self
                                                     cancelButtonTitle:@"知道了"
                                                     otherButtonTitles:@"去看看", nil];
            [alertView showWithCompleteBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1){
                    [[XMPushManager sharedPushManager] pushVCbyAddress:alertData];
                }
            }];
        }else{
             [[XMPushManager sharedPushManager] pushVCbyAddress:alertData];
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([XMSocialInfoConfiguration handleOPenURL:url]) {
        return  [XMSocialInfoConfiguration handleOPenURL:url];
    }else if ([[XMPayManager sharedPayManager] weChatHandleOPenURL:url]){
        return [[XMPayManager sharedPayManager] weChatHandleOPenURL:url];
    }else if ([url.host isEqualToString:@"safepay"]){
        return [[XMPayManager sharedPayManager] aliPayHandleOPenURL:url];
    }
    return YES;
}



@end
