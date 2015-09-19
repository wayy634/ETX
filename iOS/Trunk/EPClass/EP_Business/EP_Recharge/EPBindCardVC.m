//
//  EPBindCardVC.m
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//

#import "EPBindCardVC.h"

#import "ASDepthModalViewController.h"


@interface EPBindCardVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
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
    UITextField         *_chargePopInputCardNO, *_chargePopInputCardValidID, *_chargePopInputCardYEAR;
    
    UITextView          *_chargePopText;
    
    UIButton            *EPcancelChargeBtn, *EPsubmitChargeBtn, *EPgotItBtn;
}


@property(nonatomic, strong)UITableView     *mTableView;//TableView
@property(nonatomic, strong)UIButton        *mAddButton;//添加按钮

@property(nonatomic, strong)UIView          *mTableHeaderV; //TableHeaderView

@end

@implementation EPBindCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡绑定";
    [self.mContentView setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
    
    // Top Navi
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setAdjustsImageWhenHighlighted:NO];
    [registerButton setBackgroundColor:[UIColor clearColor]];
    [registerButton setTitleColor:K_COLOR_MAIN_FONT forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:K_FONT_SIZE(14)];
    [registerButton setTitle:@"绑卡说明" forState:UIControlStateNormal];
    [registerButton setFrame:CGRectMake(0, 0, 70, 20)];
    registerButton.tag = 110;
    [registerButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self initTopRightV:@[registerButton]];
    
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
    
    _chargePopInputCardNO       = [[UITextField alloc] initWithFrame:CGRectMake((_chargePopView.width-200)/2, 50, 200, 40)];
    _chargePopInputCardNO.layer.cornerRadius  = 5;
    _chargePopInputCardNO.layer.masksToBounds = YES;
    _chargePopInputCardNO.layer.cornerRadius = 5;
    _chargePopInputCardNO.borderStyle  = UITextBorderStyleRoundedRect;
    _chargePopInputCardNO.layer.masksToBounds=YES;
    _chargePopInputCardNO.layer.borderColor= K_COLOR_GRAY_FONT.CGColor;
    _chargePopInputCardNO.layer.borderWidth= 1.0f;
    _chargePopInputCardNO.backgroundColor = K_COLOR_WHITE_TEXT;
    _chargePopInputCardNO.font = K_FONT_SIZE(16);
    _chargePopInputCardNO.placeholder = @"请输入银行卡号";
    _chargePopInputCardNO.delegate = self;
    _chargePopInputCardNO.tag      = 1000;
    _chargePopInputCardNO.returnKeyType = UIReturnKeyDone;
    [_chargePopInputCardNO addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [_chargePopView addSubview:_chargePopInputCardNO];
    
    _chargePopInputCardYEAR       = [[UITextField alloc] initWithFrame:CGRectMake((_chargePopView.width-200)/2, 100, 100, 40)];
    _chargePopInputCardYEAR.layer.cornerRadius  = 5;
    _chargePopInputCardYEAR.layer.masksToBounds = YES;
    _chargePopInputCardYEAR.layer.cornerRadius = 5;
    _chargePopInputCardYEAR.borderStyle  = UITextBorderStyleRoundedRect;
    _chargePopInputCardYEAR.layer.masksToBounds=YES;
    _chargePopInputCardYEAR.layer.borderColor= K_COLOR_GRAY_FONT.CGColor;
    _chargePopInputCardYEAR.layer.borderWidth= 1.0f;
    _chargePopInputCardYEAR.backgroundColor = K_COLOR_WHITE_TEXT;
    _chargePopInputCardYEAR.font = K_FONT_SIZE(16);
    _chargePopInputCardYEAR.placeholder = @"月/年";
    _chargePopInputCardYEAR.delegate = self;
    _chargePopInputCardYEAR.tag      = 1000;
    _chargePopInputCardYEAR.returnKeyType = UIReturnKeyDone;
    [_chargePopInputCardYEAR addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [_chargePopView addSubview:_chargePopInputCardYEAR];
    
    
    _chargePopInputCardValidID       = [[UITextField alloc] initWithFrame:CGRectMake((_chargePopView.width-200)/2+120, 100, 80, 40)];
    _chargePopInputCardValidID.layer.cornerRadius  = 5;
    _chargePopInputCardValidID.layer.masksToBounds = YES;
    _chargePopInputCardValidID.layer.cornerRadius = 5;
    _chargePopInputCardValidID.borderStyle  = UITextBorderStyleRoundedRect;
    _chargePopInputCardValidID.layer.masksToBounds=YES;
    _chargePopInputCardValidID.layer.borderColor= K_COLOR_GRAY_FONT.CGColor;
    _chargePopInputCardValidID.layer.borderWidth= 1.0f;
    _chargePopInputCardValidID.backgroundColor = K_COLOR_WHITE_TEXT;
    _chargePopInputCardValidID.font = K_FONT_SIZE(16);
    _chargePopInputCardValidID.placeholder = @"验证码";
    _chargePopInputCardValidID.delegate = self;
    _chargePopInputCardValidID.tag      = 1000;
    _chargePopInputCardValidID.returnKeyType = UIReturnKeyDone;
    [_chargePopInputCardValidID addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [_chargePopView addSubview:_chargePopInputCardValidID];
    
    
    
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
    grayLine.alpha                     = 0.4;
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
    [EPsubmitChargeBtn setTitle:@"绑定" forState:UIControlStateNormal];
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
        _arKey = @[@"BankCards"];
        
        _dicTitle = [NSMutableDictionary new];
        _dicIcon = [NSMutableDictionary new];
        
        [_arKey enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             NSArray *arTitle1 = @[@"招商银行"];
             
             NSArray *arIcon1  = @[@"view_creditcard.pdf"];

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[_dicTitle objectForKey:@"BankCards"] count];
    }else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return K_SCREEN_WIDTH *0.6+10;
    }else{
        return 100;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"ChargeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
//    NSString *key = [_arKey objectAtIndex:[indexPath section]];
    if (indexPath.section == 1) {
        self.mAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mAddButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.mAddButton setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
        [self.mAddButton setImage:[UIImage imageWithPDFNamed:@"icon_device_add.pdf" atSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
        self.mAddButton.tag = indexPath.row;
        [self.mAddButton setBackgroundColor:[UIColor whiteColor]];
        [self.mAddButton setTitle:@"新增银行卡绑定" forState:UIControlStateNormal];
        [self.mAddButton setTitleColor:K_COLOR_MAIN_FONT forState:UIControlStateNormal];
        self.mAddButton.titleLabel.font = K_FONT_SIZE(14);
        //    self.mAddButton.frame = CGRectMake(10, self.mTableHeaderV.height +10,K_SCREEN_WIDTH-20, 64);
        self.mAddButton.frame = CGRectMake(10, self.mTableHeaderV.height +10 +74*indexPath.row ,K_SCREEN_WIDTH-20, 64);
        
        [LTools roundedRectangleView:self.mAddButton corner:10.0 width:1.0f color:K_COLOR_MAIN_LINE];
        [self.mTableView addSubview:self.mAddButton];
    }else{
        // Charge Background
        UIImageView  *cardsBGView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, K_SCREEN_WIDTH-30 , K_SCREEN_WIDTH*0.6)];
        cardsBGView.image = [UIImage imageNamed:@"view_creditcard.pdf"];
        [cell.contentView addSubview:cardsBGView];
    
    }
    
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
        _chargePopText.alpha    = 0;
        
        _chargePopInputCardYEAR.alpha       = 1;
        _chargePopInputCardValidID.alpha    = 1;
        _chargePopInputCardNO.alpha         = 1;

    }else if (button_.tag == 1) {
        _chargePopTitle.text = @"请输入支付宝充值金额";
        [ASDepthModalViewController presentView:_chargePopView withBackgroundColor:[UIColor whiteColor] popupAnimationStyle:ASDepthModalAnimationDefault];
        EPgotItBtn.alpha        = 0;
        EPcancelChargeBtn.alpha = 1;
        EPsubmitChargeBtn.alpha = 1;
        _chargePopText.alpha    = 0;
        
        _chargePopInputCardYEAR.alpha       = 1;
        _chargePopInputCardValidID.alpha    = 1;
        _chargePopInputCardNO.alpha         = 1;
        
    }else if (button_.tag == 2) {
        _chargePopTitle.text = @"请输入微信充值金额";
        [ASDepthModalViewController presentView:_chargePopView withBackgroundColor:[UIColor whiteColor] popupAnimationStyle:ASDepthModalAnimationDefault];
        EPgotItBtn.alpha        = 0;
        EPcancelChargeBtn.alpha = 1;
        EPsubmitChargeBtn.alpha = 1;
        _chargePopText.alpha    = 0;
        
        _chargePopInputCardYEAR.alpha       = 1;
        _chargePopInputCardValidID.alpha    = 1;
        _chargePopInputCardNO.alpha         = 1;
        
    }else if (button_.tag == 3) {
        NSLog(@"IndexRow 3");
    }else if (button_.tag == 110) {
        _chargePopTitle.text = @"绑卡帮助";
        [ASDepthModalViewController presentView:_chargePopView withBackgroundColor:[UIColor whiteColor] popupAnimationStyle:ASDepthModalAnimationDefault];
        EPgotItBtn.alpha        = 1;
        EPcancelChargeBtn.alpha = 0;
        EPsubmitChargeBtn.alpha = 0;
        _chargePopText.alpha    = 1;
        
        _chargePopInputCardYEAR.alpha       = 0;
        _chargePopInputCardValidID.alpha    = 0;
        _chargePopInputCardNO.alpha         = 0;
        
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
