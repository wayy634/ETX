//
//  EPRechargeVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPRechargeVC.h"

@interface EPRechargeVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
    //TABLE HEAER TITLE
    NSMutableArray      *_arData;
    NSArray             *_arKey;
    NSMutableDictionary *_dicTitle;
    NSMutableDictionary *_dicIcon;
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
    
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setAdjustsImageWhenHighlighted:NO];
    [registerButton setBackgroundColor:[UIColor clearColor]];
    [registerButton setTitleColor:K_COLOR_MAIN_FONT forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:K_FONT_SIZE(14)];
    [registerButton setTitle:@"充值说明" forState:UIControlStateNormal];
    [registerButton setFrame:CGRectMake(0, 0, 70, 20)];
    registerButton.tag = 0;
    [registerButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self initTopRightV:@[registerButton]];
    
    
    self.mTableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_WIDTH*0.6)];
    self.mTableHeaderV.backgroundColor = [UIColor clearColor];
    
    // Charge back
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
    currentBalance.font                 = K_FONT_SIZE(50);
    currentBalance.text                 = [NSString stringWithFormat:@"%.2f",1233.0];
    currentBalance.textAlignment        = NSTextAlignmentCenter;
    currentBalance.tag                  = 8001;
    [self.mTableHeaderV addSubview:currentBalance];
    [currentBalance release];
    
    UILabel *availableBalance           = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mTableHeaderV.height-55 , self.mTableHeaderV.width/2, 40)];
    availableBalance.textColor          = K_COLOR_WHITE_TEXT;
    availableBalance.font               = K_FONT_SIZE(30);
    availableBalance.text               = [NSString stringWithFormat:@"%.2f",1233.0];
    availableBalance.textAlignment      = NSTextAlignmentCenter;
    availableBalance.tag                = 8002;
    [self.mTableHeaderV addSubview:availableBalance];
    [availableBalance release];
    
    UILabel *freezeBalance              = [[UILabel alloc] initWithFrame:CGRectMake(self.mTableHeaderV.width/2, self.mTableHeaderV.height-55 , self.mTableHeaderV.width/2, 40)];
    freezeBalance.textColor             = K_COLOR_WHITE_TEXT;
    freezeBalance.font                  = K_FONT_SIZE(30);
    freezeBalance.text                  = [NSString stringWithFormat:@"%.2f",0.0];
    freezeBalance.textAlignment         = NSTextAlignmentCenter;
    freezeBalance.tag                   = 8003;
    [self.mTableHeaderV addSubview:freezeBalance];
    [freezeBalance release];
    
    
    
    
    
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 300)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tabelView setBackgroundColor:[UIColor whiteColor]];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.bounces = NO;
    self.mTableView = tabelView;
    self.mTableView.tableHeaderView = self.mTableHeaderV;
    [self.mContentView addSubview:tabelView];
    [tabelView release];
    
    self.mAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mAddButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.mAddButton setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
    [self.mAddButton setImage:[UIImage imageWithPDFNamed:@"icon_device_add.pdf" atSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
    self.mAddButton.tag = 1;
    [self.mAddButton setBackgroundColor:[UIColor whiteColor]];
    [self.mAddButton setTitle:@"新增账户绑定" forState:UIControlStateNormal];
    [self.mAddButton setTitleColor:K_COLOR_MAIN_FONT forState:UIControlStateNormal];
    self.mAddButton.titleLabel.font = K_FONT_SIZE(14);
    self.mAddButton.frame = CGRectMake(10, self.mTableView.bottom+15,K_SCREEN_WIDTH-20, 64);
    [LTools roundedRectangleView:self.mAddButton corner:10.0 width:1.0f color:K_COLOR_MAIN_LINE];
    [self.mContentView addSubview:self.mAddButton];
    
    
    [self initData];
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
    return [_arKey count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [_arKey objectAtIndex:section];
    return [[_dicTitle objectForKey:key] count];
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
    NSString *key = [_arKey objectAtIndex:[indexPath section]];
    
    self.mAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mAddButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.mAddButton setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
    [self.mAddButton setImage:[UIImage imageWithPDFNamed:[[_dicIcon objectForKey:key] objectAtIndex:indexPath.row] atSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
    self.mAddButton.tag = indexPath.row;
    [self.mAddButton setBackgroundColor:[UIColor whiteColor]];
    [self.mAddButton setTitle:[[_dicTitle objectForKey:key] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [self.mAddButton setTitleColor:K_COLOR_MAIN_FONT forState:UIControlStateNormal];
    self.mAddButton.titleLabel.font = K_FONT_SIZE(14);
    self.mAddButton.frame = CGRectMake(10, self.mTableView.bottom+15,K_SCREEN_WIDTH-20, 64);
    [LTools roundedRectangleView:self.mAddButton corner:10.0 width:1.0f color:K_COLOR_MAIN_LINE];
    [self.mContentView addSubview:self.mAddButton];
    
    return cell;
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
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
