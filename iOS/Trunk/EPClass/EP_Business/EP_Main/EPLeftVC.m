//
//  EPLeftVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/13.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPLeftVC.h"
//cell
#import "EPLeftMnuCell.h"
//
#import "EPMenuManager.h"

@interface EPLeftVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSArray        *mDataArray;

@property (nonatomic, strong)UIImageView    *mBgImageView;//背景

@property (nonatomic, strong)UIButton       *mIconButton;//头像

@property (nonatomic, strong)UITableView    *mTableView;//列表

@end

@implementation EPLeftVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#warning 判断登陆状态------
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //创建用户信息
    [EPAccountManager saveAccountData:[EPAccountManager getAccountData]];
    self.view.backgroundColor = [UIColor blueColor];
    
    
    self.mBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    self.mBgImageView.image = [UIImage imageNamed:@"bg_leftmenu.png"];
    [self.view addSubview:self.mBgImageView];
    
    self.mDataArray = @[
                        @[@"icon_sidemenu_today.pdf",@"今天"],
                        @[@"icon_sidemenu_charge.pdf",@"充值/绑卡"],
                        @[@"icon_sidemenu_device.pdf",@"绑定设备"],
                        @[@"icon_sidemenu_bills.pdf",@"我的账单"],
                        @[@"icon_sidemenu_mydevice.pdf",@"我的设备"],
                        @[@"icon_sidemenu_setting.pdf",@"账户设置"],
                        ];
    
    
    self.mIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mIconButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.mIconButton setImage:[UIImage imageNamed:@"demo_avator.png"] forState:UIControlStateNormal];
    self.mIconButton.frame = CGRectMake(45, 60, 75, 75);
    self.mIconButton.layer.cornerRadius = 37.5;
    self.mIconButton.layer.masksToBounds= YES;
    self.mIconButton.layer.borderWidth  = 2;
    self.mIconButton.layer.borderColor  = K_COLOR_WHITE_TEXT.CGColor;
    
    [self.view addSubview:self.mIconButton];
    
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(40, 150, K_SCREEN_WIDTH, self.mContentView.height)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tabelView setBackgroundColor:[UIColor clearColor]];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.bounces = NO;
    self.mTableView = tabelView;
    [self.view addSubview:tabelView];
    [tabelView release];
}


#pragma mark-----buttonActoin---------

- (void)buttonPress:(UIButton *)button_ {
    [APP_DELEGATE.mNavigationController setViewControllers:nil];
    [APP_DELEGATE.mNavigationController initWithRootViewController:[[EPMenuManager sharedMenuManager] getRootVCbyType:EPLeftMenuType_Account]];
    [APP_DELEGATE.mDDMenu showRootController:YES];
}
#pragma mark --
#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return EPLEFTTABLEVIEWCELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"EPLeftVCCell";
    EPLeftMnuCell *aCell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!aCell) {
        aCell = [[EPLeftMnuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        [aCell initUI];
    }
    [aCell setIcon:[[self.mDataArray objectAtIndex:indexPath.row] objectAtIndex:0] title:[[self.mDataArray objectAtIndex:indexPath.row] objectAtIndex:1]];
    return aCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [APP_DELEGATE.mNavigationController setViewControllers:nil];
    [APP_DELEGATE.mNavigationController initWithRootViewController:[[EPMenuManager sharedMenuManager] getRootVCbyType:indexPath.row]];
    [APP_DELEGATE.mDDMenu showRootController:YES];
}




-(void)dealloc {
    self.mBgImageView = nil;
    self.mIconButton = nil;
    self.mTableView = nil;
    [super dealloc];
}

@end
