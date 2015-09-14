//
//  EPLeftVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/13.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPLeftVC.h"
//VC
#import "EPAccountVC.h"
#import "EPTodayVC.h"
#import "EPRechargeVC.h"
#import "EPBindingDeviceVC.h"
#import "EPOrderVC.h"
#import "EPDeviceVC.h"
#import "EPSettingVC.h"


@interface EPLeftVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSArray        *mDataArray;

@property (nonatomic, strong)UIImageView    *mBgImageView;//背景

@property (nonatomic, strong)UIButton       *mIconButton;//头像

@property (nonatomic, strong)UITableView    *mTableView;//列表

@end

@implementation EPLeftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mRootVCDic = [[NSMutableDictionary alloc] init];
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
    [self.mIconButton setBackgroundColor:K_COLOR_MAIN_ORANGER];
    self.mIconButton.frame = CGRectMake(20, 50, 80, 80);
    [self.view addSubview:self.mIconButton];
    
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(20, 200, K_SCREEN_WIDTH, self.mContentView.height)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tabelView setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.backgroundColor = [UIColor clearColor];
    self.mTableView = tabelView;
    [self.view addSubview:tabelView];
    [tabelView release];
}


#pragma mark-----buttonActoin---------

- (void)buttonPress:(UIButton *)button_ {
    NSLog(@"into  accountcenter");
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
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!aCell) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        aCell.backgroundColor = [UIColor clearColor];
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
        aCell.textLabel.font = K_FONT_SIZE(14);
        aCell.textLabel.textColor = [UIColor whiteColor];
    }
    aCell.imageView.image = [UIImage imageOrPDFNamed:[[self.mDataArray objectAtIndex:indexPath.row] objectAtIndex:0]];
    
    aCell.textLabel.text = [[self.mDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
    return aCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = [self getRootVCbyType:indexPath.row+1];
    [APP_DELEGATE.mNavigationController setViewControllers:nil];
    [APP_DELEGATE.mNavigationController initWithRootViewController:object];
    [APP_DELEGATE.mDDMenu showRootController:YES];
    object = nil;
}

//获取对应的跟页面

-(id)getRootVCbyType:(EPLeftMenuType)type_ {
    
    id object = nil;
    object = [self.mRootVCDic objectForKey:[NSString stringWithFormat:@"%li",(long)type_]];
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
            EPBindingDeviceVC *bindingDeviceVC = [[EPBindingDeviceVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCDic setObject:bindingDeviceVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
            object = bindingDeviceVC;
            [bindingDeviceVC release];
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
        case EPLeftMenuType_Set:{
            EPSettingVC *settingVC = [[EPSettingVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCDic setObject:settingVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
            object = settingVC;
            [settingVC release];
            break;
        }
    }
    return object;
    
    
    
//    if (type_ == EPLeftMenuType_Today) {
//        EPTodayVC *todayVC = (EPTodayVC *)[self.mRootVCDic objectForKey:[NSString stringWithFormat:@"%i",(int)type_]];
//        if (todayVC) {
//            return todayVC;
//        }else{
//            EPTodayVC *todayVC = [[EPTodayVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
//            [self.mRootVCDic setObject:todayVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
//            return todayVC;
//        }
//    }else if (type_ == EPLeftMenuType_Recharge ) {
//        EPRechargeVC *rechargeVC = (EPRechargeVC *)[self.mRootVCDic objectForKey:[NSString stringWithFormat:@"%i",(int)type_]];
//        if (rechargeVC) {
//            return rechargeVC;
//        }else{
//            EPRechargeVC *rechargeVC = [[EPRechargeVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
//            [self.mRootVCDic setObject:rechargeVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
//            return rechargeVC;
//        }
//    }else if (type_ == EPLeftMenuType_BindingDevice ) {
//        EPBindingDeviceVC *bindingDeviceVC = (EPBindingDeviceVC *)[self.mRootVCDic objectForKey:[NSString stringWithFormat:@"%i",(int)type_]];
//        if (bindingDeviceVC) {
//            return bindingDeviceVC;
//        }else{
//            EPBindingDeviceVC *bindingDeviceVC = [[EPBindingDeviceVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
//            [self.mRootVCDic setObject:bindingDeviceVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
//            return bindingDeviceVC;
//        }
//    }else if (type_ == EPLeftMenuType_Order ) {
//        EPOrderVC *orderVC = (EPOrderVC *)[self.mRootVCDic objectForKey:[NSString stringWithFormat:@"%i",(int)type_]];
//        if (orderVC) {
//            return orderVC;
//        }else{
//            EPOrderVC *orderVC = [[EPOrderVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
//            [self.mRootVCDic setObject:orderVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
//            return orderVC;
//        }
//    }else if (type_ == EPLeftMenuType_MyDevice) {
//        EPDeviceVC *deviceVC = (EPDeviceVC *)[self.mRootVCDic objectForKey:[NSString stringWithFormat:@"%i",(int)type_]];
//        if (deviceVC) {
//            return deviceVC;
//        }else{
//            EPDeviceVC *deviceVC = [[EPDeviceVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
//            [self.mRootVCDic setObject:deviceVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
//            return deviceVC;
//        }
//    }else if (type_ == EPLeftMenuType_Set ) {
//        EPSettingVC *settingVC = (EPSettingVC *)[self.mRootVCDic objectForKey:[NSString stringWithFormat:@"%i",(int)type_]];
//        if (settingVC) {
//            return settingVC;
//        }else{
//            EPSettingVC *settingVC = [[EPSettingVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
//            [self.mRootVCDic setObject:settingVC forKey:[NSString stringWithFormat:@"%i",(int)type_]];
//            return settingVC;
//        }
//    }
//    return nil;
}



-(void)dealloc {
    self.mBgImageView = nil;
    self.mIconButton = nil;
    self.mTableView = nil;
    [super dealloc];
}

@end
