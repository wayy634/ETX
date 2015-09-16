//
//  EPAccountVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPAccountVC.h"
#import "UserEPConnectionFuction.h"

@interface EPAccountVC ()

@end

@implementation EPAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"userCenter";
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadData {
    [UserEPConnectionFuction userLogin_Phone:@"18500212113" password:@"12345678" delegate:self allowCancel:YES finishSelector:@selector(requestInfoFinsh:) failSelector:@selector(requestFailed:) timeOutSelector:@selector(requestTimeOut:)];
}


//获取用户信息成功
- (void)requestInfoFinsh:(RKMappingResult *)data_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    LCAPIResult *result = data_.firstObject;
    if ([LTools isAPIJsonError:result]) {
        [APP_DELEGATE.mWindow makeToast:result.msg duration:2.0 position:@"custom"];
        return;
    }
    
}
- (void)requestFailed:(NSError *)error_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    [APP_DELEGATE.mWindow makeToast:@"网络连接失败" duration:2.0 position:@"custom"];
}

- (void)requestTimeOut:(NSError *)error_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    [APP_DELEGATE.mWindow makeToast:@"网络连接超时" duration:2.0 position:@"custom"];
}

@end
