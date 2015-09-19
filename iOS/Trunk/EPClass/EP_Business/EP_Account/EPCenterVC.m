//
//  EPCenterVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/13.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPCenterVC.h"

#import "EPAccountCell.h"

#import "EPModProfileVC.h"
#import "EPModPwdVC.h"
#import "EPModCarVC.h"
#import "EPModGarageVC.h"

#import "EPSettingVC.h"

#import "EPCarVC.h"
#import "EPGarageVC.h"

@interface EPCenterVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    //TABLE HEAER TITLE
    UIView              *_currentCarView;
    UIImageView         *_accountAvator;
    UILabel             *_accountTitle;
    
}

@property (nonatomic, strong)NSArray        *mDataArray;


@property(nonatomic, strong)UITableView     *mTableView;//TableView
@property(nonatomic, strong)UIButton        *mAddButton;//添加按钮
@property(nonatomic, strong)UIView          *mTableHeaderV; //TableHeaderView

@end

@implementation EPCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    [self setTopViewHidden:YES];
    
    UIImageView *accountTopBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_WIDTH*0.533)];
    accountTopBG.image = [UIImage imageOrPDFNamed:@"view_account_top_background.png"];
    [self.mContentView addSubview:accountTopBG];
    
    // Top Navi
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setAdjustsImageWhenHighlighted:NO];
    [loginBtn setTitleColor:K_COLOR_WHITE_TEXT forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:K_FONT_SIZE(14)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setFrame:CGRectMake(0, 0, 40, 40)];
    loginBtn.tag = 110;
    [loginBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self initTopRightV:@[loginBtn]];
    
    // Init TableView
    self.mTableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_WIDTH*0.6+70)];
    self.mTableHeaderV.backgroundColor = [UIColor clearColor];
    
    // Charge Background
    
    
    _accountAvator            = [[UIImageView alloc] initWithFrame:CGRectMake((K_SCREEN_WIDTH-90)/2, self.mTableHeaderV.height-_currentCarView.height-90-50 , 90, 90)];
    _accountAvator.image                   = [UIImage imageOrPDFNamed:@"demo_avator.png"];
    _accountAvator.layer.cornerRadius      = 45;
    _accountAvator.layer.masksToBounds     = YES;
    _accountAvator.layer.borderWidth       = 3;
    _accountAvator.layer.borderColor       = K_COLOR_WHITE_TEXT.CGColor;
    
    [self.mTableHeaderV addSubview:_accountAvator];
    
    
    _accountTitle              = [[UILabel alloc] initWithFrame:CGRectMake(10, self.mTableHeaderV.height-35 , K_SCREEN_WIDTH-20, 15)];
    _accountTitle.textColor                 = K_COLOR_DARK_TEXT;
    _accountTitle.font                      = K_FONT_SIZE(16);
    _accountTitle.text                      = [NSString stringWithFormat:@"易通行用户"];
    _accountTitle.textAlignment             = NSTextAlignmentCenter;
    _accountTitle.tag                       = 8003;
    [self.mTableHeaderV addSubview:_accountTitle];
    
    
    
    self.mDataArray = @[
                        @[@"icon_account_profile.pdf",@"修改资料"],
                        @[@"icon_account_password.pdf",@"修改密码"],
                        @[@"icon_account_mycar.pdf",@"我的车辆管理"],
                        @[@"icon_account_mygarage.pdf",@"我的车库管理"],
                        @[@"icon_account_setting.pdf",@"账户设置"]
                        ];
    
    
    // Init Table
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tabelView setBackgroundColor:[UIColor clearColor]];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.bounces = NO;
    self.mTableView = tabelView;
    self.mTableView.tableHeaderView = self.mTableHeaderV;
    [self.mContentView addSubview:tabelView];
    [tabelView release];
    
}


#pragma mark --
#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSString *key = [_arKey objectAtIndex:section];
    return [self.mDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    USHSQACommentModel *model = self.commentDataArray[indexPath.row];
    
    NSString *identifier =[NSString stringWithFormat:@"EPAccountCell%ld",(long)indexPath.row];
    
    EPAccountCell *_EPAccountCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!_EPAccountCell) {
        _EPAccountCell = [[EPAccountCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identifier];
        _EPAccountCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _EPAccountCell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        
    }

    [_EPAccountCell setEPAccountCellIcon:[UIImage imageOrPDFNamed:[[self.mDataArray objectAtIndex:indexPath.row] objectAtIndex:0]]
                   setEPAccountCellTitle:[[self.mDataArray objectAtIndex:indexPath.row] objectAtIndex:1]];
    
    
    return _EPAccountCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index : %li",(long)indexPath.row);
    if (indexPath.row == 0) {
        EPModProfileVC *vc = [[EPModProfileVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
        [LTools pushController:vc animated:YES];
    }else if (indexPath.row == 1){
        EPModPwdVC *vc = [[EPModPwdVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
        [LTools pushController:vc animated:YES];
    }else if (indexPath.row == 2){
        EPCarVC *vc = [[EPCarVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
        [LTools pushController:vc animated:YES];
    }else if (indexPath.row == 3){
        EPGarageVC *vc = [[EPGarageVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
        [LTools pushController:vc animated:YES];
    }else if (indexPath.row == 4){
        EPSettingVC *vc = [[EPSettingVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
        [LTools pushController:vc animated:YES];
    }
    
}
#pragma mark-----buttonActoin---------

- (void)buttonPressed:(UIButton *)button_ {
    if (button_.tag == 110) {
        
    }else if (button_.tag == 901) {
        
        
    }else if (button_.tag == 902) {
        
        
    }else if (button_.tag == 903) {
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
