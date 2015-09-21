//
//  EPRechargeVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPRechargeVC.h"
#import "EPBindCardVC.h"
#import "ASDepthModalViewController.h"


@interface EPRechargeVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    //TABLE HEAER TITLE
    NSMutableArray      *_arData;
    NSArray             *_arKey;
    NSMutableDictionary *_dicTitle;
    NSMutableDictionary *_dicIcon;
    
    
    
    //POP VIEW
    UIView              *_chargePopView;
    UILabel             *_chargePopTitle;
    UITextView          *_chargePopTips;
    UITextField         *_chargePopInput;
    
    UITextView          *_chargePopText;
    
    UIButton            *EPcancelChargeBtn, *EPsubmitChargeBtn, *EPgotItBtn;
}


@property(nonatomic, strong)UITableView     *mTableView;//TableView
@property(nonatomic, strong)UIButton        *mAddButton;//添加按钮
@property(nonatomic, strong)UIView          *mTableHeaderV; //TableHeaderView

@end

@implementation EPRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户充值";
    [self.mContentView setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
    
    // Top Navi
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setAdjustsImageWhenHighlighted:NO];
    [registerButton setBackgroundColor:[UIColor clearColor]];
    [registerButton setTitleColor:K_COLOR_MAIN_FONT forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:K_FONT_SIZE(14)];
    [registerButton setTitle:@"充值说明" forState:UIControlStateNormal];
    [registerButton setFrame:CGRectMake(0, 0, 70, 20)];
    registerButton.tag = 110;
    [registerButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self initTopRightV:@[registerButton]];
    
    // Init TableView
    self.mTableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_WIDTH*0.6)];
    self.mTableHeaderV.backgroundColor = [UIColor clearColor];
    
    // Charge Background
    UIImageView  *chargeBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.mTableHeaderV.width, self.mTableHeaderV.height)];
    chargeBGView.image = [UIImage imageNamed:@"view_today_top_background.png"];
    [self.mTableHeaderV addSubview:chargeBGView];
    [chargeBGView release];
    
    // Static Label Display
    UILabel      *chargeTopTips         = [[UILabel alloc] initWithFrame:CGRectMake((K_SCREEN_WIDTH-200)/2, 20, 200, 30)];
    chargeTopTips.textColor             = K_COLOR_WHITE_TEXT;
    chargeTopTips.font                  = K_FONT_SIZE(16);
    chargeTopTips.text                  = @"账户余额";
    chargeTopTips.textAlignment         = NSTextAlignmentCenter;
    [self.mTableHeaderV addSubview:chargeTopTips];
    [chargeTopTips release];
    

    UILabel *availableBalanceTip        = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mTableHeaderV.height-75, self.mTableHeaderV.width/2, 20)];
    availableBalanceTip.textColor       = K_COLOR_WHITE_TEXT;
    availableBalanceTip.font            = K_FONT_SIZE(14);
    availableBalanceTip.text            = @"当前可用余额";
    availableBalanceTip.textAlignment   = NSTextAlignmentCenter;
    [self.mTableHeaderV addSubview:availableBalanceTip];
    [availableBalanceTip release];
    
    UILabel *freezeBalanceTip           = [[UILabel alloc] initWithFrame:CGRectMake(self.mTableHeaderV.width/2, self.mTableHeaderV.height-75 , self.mTableHeaderV.width/2, 20)];
    freezeBalanceTip.textColor          = K_COLOR_WHITE_TEXT;
    freezeBalanceTip.font               = K_FONT_SIZE(14);
    freezeBalanceTip.text               = @"当前冻结定金";
    freezeBalanceTip.textAlignment      = NSTextAlignmentCenter;
    [self.mTableHeaderV addSubview:freezeBalanceTip];
    [freezeBalanceTip release];
    
    // Charge back
    UIImageView  *whiteLine = [[UIImageView alloc] initWithFrame:CGRectMake(self.mTableHeaderV.width/2-0.25, self.mTableHeaderV.height-75, 0.5, 50)];
    whiteLine.backgroundColor           = K_COLOR_WHITE_TEXT;
    whiteLine.alpha                     = 0.7;
    [self.mTableHeaderV addSubview:whiteLine];
    [whiteLine release];
    
    // Date Label Display
    UILabel      *currentBalance        = [[UILabel alloc] initWithFrame:CGRectMake((K_SCREEN_WIDTH-200)/2, 60, 200, 60)];
    currentBalance.textColor            = K_COLOR_WHITE_TEXT;
    currentBalance.font                 = [UIFont fontWithName:FONT_HC size:50];;
    currentBalance.text                 = [NSString stringWithFormat:@"%.2f",1233.0];
    currentBalance.textAlignment        = NSTextAlignmentCenter;
    currentBalance.tag                  = 8001;
    [self.mTableHeaderV addSubview:currentBalance];
    [currentBalance release];
    
    UILabel *availableBalance           = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mTableHeaderV.height-55 , self.mTableHeaderV.width/2, 40)];
    availableBalance.textColor          = K_COLOR_WHITE_TEXT;
    availableBalance.font               = [UIFont fontWithName:FONT_HC size:30];;
    availableBalance.text               = [NSString stringWithFormat:@"%.2f",1233.0];
    availableBalance.textAlignment      = NSTextAlignmentCenter;
    availableBalance.tag                = 8002;
    [self.mTableHeaderV addSubview:availableBalance];
    [availableBalance release];
    
    UILabel *freezeBalance              = [[UILabel alloc] initWithFrame:CGRectMake(self.mTableHeaderV.width/2, self.mTableHeaderV.height-55 , self.mTableHeaderV.width/2, 40)];
    freezeBalance.textColor             = K_COLOR_WHITE_TEXT;
    freezeBalance.font                  = [UIFont fontWithName:FONT_HC size:30];;
    freezeBalance.text                  = [NSString stringWithFormat:@"%.2f",0.0];
    freezeBalance.textAlignment         = NSTextAlignmentCenter;
    freezeBalance.tag                   = 8003;
    [self.mTableHeaderV addSubview:freezeBalance];
    [freezeBalance release];
    
    // Init Charge Pop
    //HELP View Inti
    _chargePopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 280)];
    _chargePopView.backgroundColor = [UIColor clearColor];
    _chargePopView.layer.cornerRadius = 10;
    _chargePopView.layer.shouldRasterize = YES;
    _chargePopView.layer.rasterizationScale = [[UIScreen mainScreen] scale];


    UIImageView *_aboutDetailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _chargePopView.width, _chargePopView.height)];
    _aboutDetailView.layer.cornerRadius = 10;
    _aboutDetailView.layer.masksToBounds=YES;
    _aboutDetailView.backgroundColor = K_COLOR_WHITE_TEXT;
    [_chargePopView addSubview:_aboutDetailView];
    
    _chargePopTitle       = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _chargePopView.width, 30)];
    _chargePopTitle.text             = @"请输入充值金额";
    _chargePopTitle.textColor        = K_COLOR_DARK_TEXT;
    _chargePopTitle.font             = K_FONT_SIZE(18);
    _chargePopTitle.textAlignment    = NSTextAlignmentCenter;
    _chargePopTitle.numberOfLines    = 0;
    [_chargePopView addSubview:_chargePopTitle];
    
    _chargePopInput       = [[UITextField alloc] initWithFrame:CGRectMake((_chargePopView.width-200)/2, 50, 200, 40)];
    _chargePopInput.layer.cornerRadius  = 5;
    _chargePopInput.layer.masksToBounds = YES;

    _chargePopInput.layer.cornerRadius = 5;
    _chargePopInput.borderStyle  = UITextBorderStyleRoundedRect;
    _chargePopInput.layer.masksToBounds=YES;
    _chargePopInput.layer.borderColor= K_COLOR_GRAY_FONT.CGColor;
    _chargePopInput.layer.borderWidth= 1.0f;
    _chargePopInput.backgroundColor = K_COLOR_WHITE_TEXT;
    _chargePopInput.font = K_FONT_SIZE(16);
    _chargePopInput.placeholder = @"请输入充值金额";
    _chargePopInput.delegate = self;
    _chargePopInput.tag      = 1000;
    _chargePopInput.returnKeyType = UIReturnKeyDone;
    [_chargePopInput addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [_chargePopView addSubview:_chargePopInput];
    
    _chargePopTips= [[UITextView alloc] initWithFrame:CGRectMake(10, 100, _chargePopView.width-20, 140)];
    _chargePopTips.editable    = NO;
    _chargePopTips.backgroundColor = [UIColor clearColor];
    _chargePopTips.font        = [UIFont systemFontOfSize:12];
    _chargePopTips.textColor   = K_COLOR_GRAY_FONT;
    _chargePopTips.text        = EP_CHARGE_TIPS;
    [_chargePopView addSubview:_chargePopTips];
    
    
    _chargePopText= [[UITextView alloc] initWithFrame:CGRectMake(10, 50, _chargePopView.width-20, 170)];
    _chargePopText.editable    = NO;
    _chargePopText.backgroundColor = [UIColor clearColor];
    _chargePopText.font        = [UIFont systemFontOfSize:12];
    _chargePopText.textColor   = K_COLOR_GRAY_FONT;
    _chargePopText.text        = EP_CHARGE_HELP;
    [_chargePopView addSubview:_chargePopText];
    
    
    // Charge back
    UIImageView  *grayLine = [[UIImageView alloc] initWithFrame:CGRectMake(_chargePopView.width/2-0.25, _chargePopView.height-50, 0.5, 40)];
    grayLine.backgroundColor           = K_COLOR_GRAY_FONT;
    grayLine.alpha                     = 0.7;
    [_chargePopView addSubview:grayLine];
    [grayLine release];
    
    EPcancelChargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [EPcancelChargeBtn setTitle:@"取消" forState:UIControlStateNormal];
    EPcancelChargeBtn.titleLabel.font = K_FONT_SIZE(18);
    [EPcancelChargeBtn setTitleColor:K_COLOR_DARK_TEXT forState:UIControlStateNormal];
    EPcancelChargeBtn.frame = CGRectMake(0, _chargePopView.bottom-50, _chargePopView.width/2, 40);
    [EPcancelChargeBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    EPcancelChargeBtn.tag   = 901;
    EPcancelChargeBtn.backgroundColor = [UIColor clearColor];
    [_chargePopView addSubview:EPcancelChargeBtn];
    
    EPsubmitChargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [EPsubmitChargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    EPsubmitChargeBtn.titleLabel.font = K_FONT_SIZE(18);
    [EPsubmitChargeBtn setTitleColor:K_COLOR_DARK_TEXT forState:UIControlStateNormal];
    EPsubmitChargeBtn.frame = CGRectMake(_chargePopView.width/2, _chargePopView.bottom-50, _chargePopView.width/2, 40);
    [EPsubmitChargeBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    EPsubmitChargeBtn.tag   = 902;
    EPsubmitChargeBtn.backgroundColor = [UIColor clearColor];
    [_chargePopView addSubview:EPsubmitChargeBtn];
    
    EPgotItBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [EPgotItBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    EPgotItBtn.titleLabel.font = K_FONT_SIZE(18);
    [EPgotItBtn setTitleColor:K_COLOR_DARK_TEXT forState:UIControlStateNormal];
    EPgotItBtn.frame = CGRectMake(10, _chargePopView.bottom-50, _chargePopView.width-20, 40);
    [EPgotItBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    EPgotItBtn.tag   = 903;
    EPgotItBtn.backgroundColor = [UIColor whiteColor];
    EPgotItBtn.layer.cornerRadius = 5;
    EPgotItBtn.layer.masksToBounds=YES;
    EPgotItBtn.layer.borderColor= K_COLOR_GRAY_FONT.CGColor;
    EPgotItBtn.layer.borderWidth= 0.5f;
    [_chargePopView addSubview:EPgotItBtn];
    
    
    // Init Array Date
    [self initData];
    
    // Init Table
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tabelView setBackgroundColor:[UIColor whiteColor]];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.bounces = NO;
    self.mTableView = tabelView;
    self.mTableView.tableHeaderView = self.mTableHeaderV;
    [self.mContentView addSubview:tabelView];
    [tabelView release];
    
}


- (void)initData
{
    __async_opt__, ^
    {
        _arKey = @[@"ChargeMethod"];
        
        _dicTitle = [NSMutableDictionary new];
        _dicIcon = [NSMutableDictionary new];
        
        [_arKey enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             NSArray *arTitle1 = @[@"银行卡充值",@"支付宝充值",@"微信充值",@"新增账户绑定"];
             
             NSArray *arIcon1  = @[@"icon_charge_upcash.pdf",@"icon_charge_alipay.pdf",@"icon_charge_wechatpay.pdf",@"icon_device_add.pdf"];

             [_dicTitle setObject:arTitle1 forKey:obj];
             [_dicIcon setObject:arIcon1 forKey:obj];

             
         }];
        
        __async_main__, ^
        {
            [self.mTableView reloadData];
        });
    });
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
    return [[_dicTitle objectForKey:@"ChargeMethod"] count];
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"ChargeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        
    }
//    NSString *key = [_arKey objectAtIndex:[indexPath section]];
    
    self.mAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mAddButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.mAddButton setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
    [self.mAddButton setImage:[UIImage imageWithPDFNamed:[[_dicIcon objectForKey:@"ChargeMethod"] objectAtIndex:indexPath.row] atSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
    self.mAddButton.tag = indexPath.row;
    [self.mAddButton setBackgroundColor:[UIColor whiteColor]];
    [self.mAddButton setTitle:[[_dicTitle objectForKey:@"ChargeMethod"] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [self.mAddButton setTitleColor:K_COLOR_MAIN_FONT forState:UIControlStateNormal];
    self.mAddButton.titleLabel.font = K_FONT_SIZE(14);
//    self.mAddButton.frame = CGRectMake(10, self.mTableHeaderV.height +10,K_SCREEN_WIDTH-20, 64);
    self.mAddButton.frame = CGRectMake(10, self.mTableHeaderV.height +10 +74*indexPath.row ,K_SCREEN_WIDTH-20, 64);

    [LTools roundedRectangleView:self.mAddButton corner:10.0 width:1.0f color:K_COLOR_MAIN_LINE];
    [self.mTableView addSubview:self.mAddButton];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index : %li",(long)indexPath.row);
}
#pragma mark-----buttonActoin---------

- (void)buttonPressed:(UIButton *)button_ {
    if (button_.tag == 0 ) {
        NSLog(@"Help the GEDU!");
        _chargePopTitle.text = @"请输入银行卡充值金额";
        [ASDepthModalViewController presentView:_chargePopView withBackgroundColor:[UIColor whiteColor] popupAnimationStyle:ASDepthModalAnimationDefault];
        EPgotItBtn.alpha        = 0;
        EPcancelChargeBtn.alpha = 1;
        EPsubmitChargeBtn.alpha = 1;
        _chargePopInput.alpha   = 1;
        _chargePopTips.alpha    = 1;
        _chargePopInput.alpha   = 1;
        _chargePopText.alpha    = 0;

    }else if (button_.tag == 1) {
        _chargePopTitle.text = @"请输入支付宝充值金额";
        [ASDepthModalViewController presentView:_chargePopView withBackgroundColor:[UIColor whiteColor] popupAnimationStyle:ASDepthModalAnimationDefault];
        EPgotItBtn.alpha        = 0;
        EPcancelChargeBtn.alpha = 1;
        EPsubmitChargeBtn.alpha = 1;
        _chargePopInput.alpha   = 1;
        _chargePopTips.alpha    = 1;
        _chargePopInput.alpha   = 1;
        _chargePopText.alpha    = 0;
    }else if (button_.tag == 2) {
        _chargePopTitle.text = @"请输入微信充值金额";
        [ASDepthModalViewController presentView:_chargePopView withBackgroundColor:[UIColor whiteColor] popupAnimationStyle:ASDepthModalAnimationDefault];
        EPgotItBtn.alpha        = 0;
        EPcancelChargeBtn.alpha = 1;
        EPsubmitChargeBtn.alpha = 1;
        _chargePopInput.alpha   = 1;
        _chargePopTips.alpha    = 1;
        _chargePopInput.alpha   = 1;
        _chargePopText.alpha    = 0;
    }else if (button_.tag == 3) {
        NSLog(@"IndexRow 3");
        EPBindCardVC *vc = [[EPBindCardVC alloc]initCustomVCType:LCCustomBaseVCTypeNormal];
        [LTools pushController:vc animated:YES];
        [vc release],vc = nil;
        
    }else if (button_.tag == EP_BTN_RIGTH_TAG) {
        _chargePopTitle.text = @"充值帮助";
        [ASDepthModalViewController presentView:_chargePopView withBackgroundColor:[UIColor whiteColor] popupAnimationStyle:ASDepthModalAnimationDefault];
        EPgotItBtn.alpha        = 1;
        EPcancelChargeBtn.alpha = 0;
        EPsubmitChargeBtn.alpha = 0;
        _chargePopInput.alpha   = 0;
        _chargePopTips.alpha    = 0;
        _chargePopInput.alpha   = 0;
        _chargePopText.alpha    = 1;
    }else if (button_.tag == 901) {
        NSLog(@"CANCEL");
        [ASDepthModalViewController dismiss];

    }else if (button_.tag == 902) {
        NSLog(@"SUBMIT");
        [ASDepthModalViewController dismiss];

    }else if (button_.tag == 903) {
        NSLog(@"DISMISS");
        [ASDepthModalViewController dismiss];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-----TextFieldMethod---------

- (void)textFieldEditChanged:(UITextField *)textField
{

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    
    [sender resignFirstResponder];
    
    return YES;
}

-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
