//
//  EPDeviceVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPDeviceVC.h"
#import "UserEPConnectionFuction.h"

@interface EPDeviceVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UITableView     *mTableView;

@property(nonatomic, strong)UIButton        *mAddButton;//添加按钮

@end

@implementation EPDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的设备";
    [self.mContentView setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
    
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setAdjustsImageWhenHighlighted:NO];
    [registerButton setBackgroundColor:[UIColor clearColor]];
    [registerButton setTitleColor:K_COLOR_MAIN_FONT forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:K_FONT_SIZE(14)];
    [registerButton setTitle:@"设备说明" forState:UIControlStateNormal];
    [registerButton setFrame:CGRectMake(0, 0, 70, 20)];
    registerButton.tag = 0;
    [registerButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self initTopRightV:@[registerButton]];
    
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 300)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tabelView setBackgroundColor:[UIColor whiteColor]];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.bounces = NO;
    self.mTableView = tabelView;
    [self.mContentView addSubview:tabelView];
    [tabelView release];
    
    self.mAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mAddButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.mAddButton setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
    [self.mAddButton setImage:[UIImage imageWithPDFNamed:@"icon_device_add.pdf" atSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
    self.mAddButton.tag = 1;
    [self.mAddButton setBackgroundColor:[UIColor whiteColor]];
    [self.mAddButton setTitle:@"新增设备绑定" forState:UIControlStateNormal];
    [self.mAddButton setTitleColor:K_COLOR_MAIN_FONT forState:UIControlStateNormal];
    self.mAddButton.titleLabel.font = K_FONT_SIZE(14);
    self.mAddButton.frame = CGRectMake(10, self.mTableView.bottom+15,K_SCREEN_WIDTH-20, 64);
    [LTools roundedRectangleView:self.mAddButton corner:10.0 width:1.0f color:K_COLOR_MAIN_LINE];
    [self.mContentView addSubview:self.mAddButton];
    
}
#pragma mark --
#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index : %li",indexPath.row);
}
#pragma mark-----buttonActoin---------

- (void)buttonPressed:(UIButton *)button_ {
    if (button_.tag == 0 ) {
        NSLog(@"rule");
    }else if (button_.tag == 1) {
        NSLog(@"add");
        [UserEPConnectionFuction userLogin_Phone:@"18500212113" password:@"12345678" delegate:self allowCancel:YES finishSelector:@selector(requestInfoFinsh:) failSelector:@selector(requestFailed:) timeOutSelector:@selector(requestTimeOut:)];
    }
    
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
