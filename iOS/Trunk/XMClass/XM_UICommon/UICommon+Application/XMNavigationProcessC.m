//
//  XMNavigationProcessC.m
//  XiaoMai
//
//  Created by Jeanne on 15/7/10.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMNavigationProcessC.h"

@interface XMNavigationProcessC ()

@end

@implementation XMNavigationProcessC

+ (XMNavigationProcessC *)sharedXMNavigationProcessC {
    static XMNavigationProcessC *sharedXMNavigationProcessC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedXMNavigationProcessC = [[XMNavigationProcessC alloc] init];
        sharedXMNavigationProcessC.navigationBarHidden = YES;
        [sharedXMNavigationProcessC.view setFrame:CGRectMake(0, K_SCREEN_HEIGHT, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
        [APP_DELEGATE.mWindow addSubview:sharedXMNavigationProcessC.view];
    });
    return sharedXMNavigationProcessC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initProcessRootViewController:(id)controller_ completeProcess:(compltePrecess)block_ {
    [self setViewControllers:nil];
    [self initWithRootViewController:controller_];
    self.mCompltePrecess = nil;
    self.mCompltePrecess = block_;
}

- (void)animation:(XMNavigationProcessCType)type_ completion:(void (^)(BOOL finished))completion_ {
    if (type_ == XMNavigationProcessCTypeShow) {
        [UIView animateWithDuration:LCCUSTOMBASEVC_ANIMATION_DURATION delay:LCCUSTOMBASEVC_ANIMATION_DELAY options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [self.view setFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            if (completion_) {
                completion_(finished);
            }
        }];
    } else if (type_ == XMNavigationProcessCTypeDisappear) {
        [UIView animateWithDuration:LCCUSTOMBASEVC_ANIMATION_DURATION delay:LCCUSTOMBASEVC_ANIMATION_DELAY options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [self.view setFrame:CGRectMake(0, K_SCREEN_HEIGHT, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            if (completion_) {
                completion_(finished);
                [self popToRootViewControllerAnimated:NO];
            }
            if (self.mCompltePrecess) {
                self.mCompltePrecess();
            }
        }];
    }
}

+ (void)XMPushViewController:(UIViewController *)vc_ animated:(BOOL)animated_ {
    [[XMNavigationProcessC sharedXMNavigationProcessC] pushViewController:vc_ animated:YES];
}

+ (void)XMPopViewControllerAnimated:(BOOL)animated_ {
    [[XMNavigationProcessC sharedXMNavigationProcessC] popViewControllerAnimated:animated_];
}

+ (void)XMPopToRootViewControllerAnimated:(BOOL)animated_ {
    [[XMNavigationProcessC sharedXMNavigationProcessC] popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    self.mCompltePrecess = nil;
    [super dealloc];
}
@end
