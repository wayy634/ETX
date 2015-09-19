//
//  EPDayVC.m
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//

#import "EPDayVC.h"

#import "EPMonthVC.h"

#import "EPDayCell.h"
#import "EPDayModel.h"

@interface EPDayVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    //TABLE HEAER TITLE
    NSMutableArray      *_arData;
    NSArray             *_arKey;
    NSMutableDictionary *_dicTitle;
    NSMutableDictionary *_dicIcon;
    
    UIView              *_currentCarView;
    
    
    
    UILabel             *_dayCostSum, *_currentParkingTitle, *_currentParkingFee;
    
}


@property(nonatomic, strong)UITableView     *mTableView;//TableView
@property(nonatomic, strong)UIButton        *mAddButton;//添加按钮
@property(nonatomic, strong)UIView          *mTableHeaderV; //TableHeaderView

@end

@implementation EPDayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"8月15日";
    [self.mContentView setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
    
    // Top Navi
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtn setAdjustsImageWhenHighlighted:NO];
    [historyBtn setImage:[UIImage imageOrPDFNamed:@"btn_nav_history.pdf"] forState:UIControlStateNormal];
    [historyBtn setFrame:CGRectMake(0, 0, 40, 40)];
    historyBtn.tag = 110;
    [historyBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self initTopRightV:@[historyBtn]];
    
    // Init TableView
    self.mTableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_WIDTH*0.6+50)];
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
    chargeTopTips.text                  = @"通行消费共计(元)";
    chargeTopTips.textAlignment         = NSTextAlignmentCenter;
    [self.mTableHeaderV addSubview:chargeTopTips];
    [chargeTopTips release];
    
    
    // Date Label Display
    _dayCostSum        = [[UILabel alloc] initWithFrame:CGRectMake((K_SCREEN_WIDTH-300)/2, 60, 300, 60)];
    _dayCostSum.textColor            = K_COLOR_WHITE_TEXT;
    _dayCostSum.font                 = [UIFont fontWithName:FONT_HC size:60];
    _dayCostSum.text                 = [NSString stringWithFormat:@"%.2f",100.8];
    _dayCostSum.textAlignment        = NSTextAlignmentCenter;
    _dayCostSum.tag                  = 8001;
    [self.mTableHeaderV addSubview:_dayCostSum];
    
    
    UILabel *currrentBalenceTips              = [[UILabel alloc] initWithFrame:CGRectMake((K_SCREEN_WIDTH-300)/2, self.mTableHeaderV.height-80-45 , 300, 40)];
    currrentBalenceTips.textColor             = K_COLOR_WHITE_TEXT;
    currrentBalenceTips.font                  = K_FONT_SIZE(14);
    currrentBalenceTips.text                  = [NSString stringWithFormat:@"账户当前余额"];
    currrentBalenceTips.textAlignment         = NSTextAlignmentCenter;
    currrentBalenceTips.tag                   = 8003;
    [self.mTableHeaderV addSubview:currrentBalenceTips];
    

    UILabel *currrentBalence           = [[UILabel alloc] initWithFrame:CGRectMake((K_SCREEN_WIDTH-300)/2, self.mTableHeaderV.height-55-45 , 300, 40)];
    currrentBalence.textColor          = K_COLOR_WHITE_TEXT;
    currrentBalence.font               = [UIFont fontWithName:FONT_HC size:30];;
    currrentBalence.text               = [NSString stringWithFormat:@"%.2f",1233.0];
    currrentBalence.textAlignment      = NSTextAlignmentCenter;
    currrentBalence.tag                = 8002;
    [self.mTableHeaderV addSubview:currrentBalence];
    
    
    _currentCarView = [[UIView alloc] initWithFrame:CGRectMake(0, K_SCREEN_WIDTH*0.6, K_SCREEN_WIDTH, 50)];
    _currentCarView.backgroundColor = K_COLOR_ORANGE_BG;
    [self.mTableHeaderV addSubview:_currentCarView];
    
    UIImageView *chargeIcon            = [[UIImageView alloc] initWithFrame:CGRectMake(K_SCREEN_WIDTH/2 -40 , self.mTableHeaderV.height-40 , 30, 30)];
    chargeIcon.image                   = [UIImage imageOrPDFNamed:@"icon_charge_white.pdf"];
    [self.mTableHeaderV addSubview:chargeIcon];
    
    
    UILabel *chargeTitle           = [[UILabel alloc] initWithFrame:CGRectMake(K_SCREEN_WIDTH/2-10, self.mTableHeaderV.height-40 , 100, 30)];
    chargeTitle.textColor          = K_COLOR_WHITE_TEXT;
    chargeTitle.font               = K_BOLD_FONT_SIZE(24);
    chargeTitle.text               = @"充值";
    chargeTitle.textAlignment      = NSTextAlignmentLeft;
    chargeTitle.tag                = 8002;
    [self.mTableHeaderV addSubview:chargeTitle];
    
    

    
    // Init Table
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tabelView setBackgroundColor:K_COLOR_LIGHT_GRAY_BG];
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
    return 5;
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    USHSQACommentModel *model = self.commentDataArray[indexPath.row];
    
    NSString *identifier =[NSString stringWithFormat:@"EPDayCell%ld",(long)indexPath.row];
    
    EPDayCell *_EPDayCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!_EPDayCell) {
        _EPDayCell = [[EPDayCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier];
        _EPDayCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    [_EPDayCell setEPDayCellIcon:[UIImage imageOrPDFNamed:@"icon_parking_blue.pdf"]];
   
    [_EPDayCell setEPDayCellTitle:@"华茂中心地下停车场"
                setEPDayCellSTime:@"09:18"
                 setEPDayCellCost:@"45.00"];
    
    
    return _EPDayCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index : %li",(long)indexPath.row);
}
#pragma mark-----buttonActoin---------

- (void)buttonPressed:(UIButton *)button_ {
    if (button_.tag == 0 ) {
        NSLog(@"Help the GEDU!");

        
    }else if (button_.tag == 1) {

    }else if (button_.tag == 2) {

    }else if (button_.tag == 3) {
        
    }else if (button_.tag == 110) {
        EPMonthVC *vc = [[EPMonthVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
        [LTools pushController:vc animated:YES];
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
