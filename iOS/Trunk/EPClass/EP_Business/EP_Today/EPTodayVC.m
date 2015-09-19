//
//  EPRechargeVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPTodayVC.h"

#import "EPDayVC.h"

#import "EPDayCell.h"
#import "EPDayModel.h"

@interface EPTodayVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    //TABLE HEAER TITLE
    NSMutableArray      *_arData;
    NSArray             *_arKey;
    NSMutableDictionary *_dicTitle;
    NSMutableDictionary *_dicIcon;
    
    UIView              *_currentCarView;
    
    
    
    UILabel             *_currentParkingTime, *_currentParkingTitle, *_currentParkingFee;
    
}


@property(nonatomic, strong)UITableView     *mTableView;//TableView
@property(nonatomic, strong)UIButton        *mAddButton;//添加按钮
@property(nonatomic, strong)UIView          *mTableHeaderV; //TableHeaderView

@end

@implementation EPTodayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日";
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
    chargeTopTips.text                  = @"停车/时";
    chargeTopTips.textAlignment         = NSTextAlignmentCenter;
    [self.mTableHeaderV addSubview:chargeTopTips];
    [chargeTopTips release];
    
    
    // Date Label Display
    _currentParkingTime        = [[UILabel alloc] initWithFrame:CGRectMake((K_SCREEN_WIDTH-200)/2, 60, 200, 60)];
    _currentParkingTime.textColor            = K_COLOR_WHITE_TEXT;
    _currentParkingTime.font                 = [UIFont fontWithName:FONT_HC size:60];
    _currentParkingTime.text                 = [NSString stringWithFormat:@"%.1fh",6.8];
    _currentParkingTime.textAlignment        = NSTextAlignmentCenter;
    _currentParkingTime.tag                  = 8001;
    [self.mTableHeaderV addSubview:_currentParkingTime];
    [_currentParkingTime release];
    
    UIImageView *parkingIcon            = [[UIImageView alloc] initWithFrame:CGRectMake((K_SCREEN_WIDTH-30)/2, self.mTableHeaderV.height-_currentCarView.height-80-50 , 30, 30)];
    parkingIcon.image                   = [UIImage imageOrPDFNamed:@"icon_parking_white.pdf"];
    [self.mTableHeaderV addSubview:parkingIcon];
    
    UILabel *currentCarTips              = [[UILabel alloc] initWithFrame:CGRectMake((K_SCREEN_WIDTH-200)/2, self.mTableHeaderV.height-50-45 , 200, 40)];
    currentCarTips.textColor             = K_COLOR_WHITE_TEXT;
    currentCarTips.font                  = K_FONT_SIZE(14);
    currentCarTips.text                  = [NSString stringWithFormat:@"我的爱车所在停车场"];
    currentCarTips.textAlignment         = NSTextAlignmentCenter;
    currentCarTips.tag                   = 8003;
    [self.mTableHeaderV addSubview:currentCarTips];
    

    _currentCarView = [[UIView alloc] initWithFrame:CGRectMake(0, K_SCREEN_WIDTH*0.6, K_SCREEN_WIDTH, 50)];
    _currentCarView.backgroundColor = K_COLOR_ORANGE_BG;
    [self.mTableHeaderV addSubview:_currentCarView];
    
    UIImageView *downArrow            = [[UIImageView alloc] initWithFrame:CGRectMake((K_SCREEN_WIDTH-20)/2, self.mTableHeaderV.height-50 , 20, 10)];
    downArrow.image                   = [UIImage imageOrPDFNamed:@"icon_today_downarraw.pdf"];
    [self.mTableHeaderV addSubview:downArrow];
    
    
    _currentParkingTitle              = [[UILabel alloc] initWithFrame:CGRectMake(10, self.mTableHeaderV.height-40 , K_SCREEN_WIDTH-20, 15)];
    _currentParkingTitle.textColor             = K_COLOR_WHITE_TEXT;
    _currentParkingTitle.font                  = K_FONT_SIZE(13);
    _currentParkingTitle.text                  = [NSString stringWithFormat:@"华茂中心地下停车场"];
    _currentParkingTitle.textAlignment         = NSTextAlignmentCenter;
    _currentParkingTitle.tag                   = 8003;
    [self.mTableHeaderV addSubview:_currentParkingTitle];
    
    _currentParkingFee              = [[UILabel alloc] initWithFrame:CGRectMake(10, self.mTableHeaderV.height-20 , K_SCREEN_WIDTH-20, 15)];
    _currentParkingFee.textColor             = K_COLOR_WHITE_TEXT;
    _currentParkingFee.font                  = K_FONT_SIZE(13);
    _currentParkingFee.text                  = [NSString stringWithFormat:@"车费：10元/时"];
    _currentParkingFee.textAlignment         = NSTextAlignmentCenter;
    _currentParkingFee.tag                   = 8003;
    [self.mTableHeaderV addSubview:_currentParkingFee];
    

    
    // Init Table
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
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
                 setEPDayCellCost:@"计费中"];
    
    
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
        EPDayVC *vc = [[EPDayVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
        [self.navigationController pushViewController:vc animated:YES];
        
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
