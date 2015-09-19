//
//  EPCenterVC.m
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//

#import "EPCenterVC.h"

#import "EPModGarageVC.h"

#import "EPGarageVC.h"
#import "EPCarGarageCell.h"
#import "EPCarGarageModel.h"

@interface EPGarageVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    //TABLE HEAER TITLE

    UIImageView         *_accountAvator;
    UILabel             *_accountTitle;
    
    //ACTION BTN
    UIButton            *actionBtn;
    
    //TEXTVIEW FIELD
    NSString            *_garageEstate;
    NSString            *_garageLoc;
    NSString            *_garageIsPrivate;
    NSString            *_garageType;
    NSString            *_garageIsRent;
    NSString            *_garageRentFee;
    
    //TEXTFILED UI
    UITextField         *profileTextField;
}

@property (nonatomic, strong)NSArray        *mDataArray;


@property(nonatomic, strong)UITableView     *mTableView;//TableView
@property(nonatomic, strong)UIButton        *mAddButton;//添加按钮

@end

@implementation EPGarageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的车库管理";
    
    // Top Navi
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setAdjustsImageWhenHighlighted:NO];
    [addBtn setTitleColor:K_COLOR_DARK_TEXT forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:K_FONT_SIZE(14)];
    [addBtn setTitle:@"新增" forState:UIControlStateNormal];
    [addBtn setFrame:CGRectMake(0, 0, 40, 40)];
    addBtn.tag = 110;
    [addBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self initTopRightV:@[addBtn]];
    
    
    // Init Table
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tabelView setBackgroundColor:[UIColor clearColor]];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.bounces = NO;
    self.mTableView = tabelView;
    [self.mContentView addSubview:tabelView];
    [tabelView release];
    
    
    actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionBtn setFrame:CGRectMake((K_SCREEN_WIDTH-300)/2, K_SCREEN_HEIGHT-120, 300, 40)];
    [actionBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [actionBtn setTitleColor:K_COLOR_WHITE_TEXT forState:UIControlStateNormal];
    [actionBtn setTitleColor:K_COLOR_WHITE_TEXT forState:UIControlStateHighlighted];
    actionBtn.titleLabel.font = K_BOLD_FONT_SIZE(16);
    [actionBtn setBackgroundColor:K_COLOR_ORANGE_BG];
    [actionBtn.layer setMasksToBounds:YES];
    actionBtn.layer.cornerRadius = 5.0;
    actionBtn.tag       = 100;
    [actionBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.mContentView addSubview:actionBtn];
    
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
    return 2;
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
    
    NSString *identifier =[NSString stringWithFormat:@"EPGarageCell%ld",(long)indexPath.row];
    
    EPCarGarageCell *_EPGarageCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!_EPGarageCell) {
        _EPGarageCell = [[EPCarGarageCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:identifier];
        _EPGarageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _EPGarageCell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [_EPGarageCell setEPCarGarageCellTitle:@"城市经典（小区）"
               setEPCarGarageCellDetail:@"地上1个车位，待出租"];
    
    
    return _EPGarageCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index : %li",(long)indexPath.row);
}
#pragma mark-----buttonActoin---------

- (void)buttonPressed:(UIButton *)button_ {
    if (button_.tag == 100) {
        NSLog(@"IT'S GREAT");
    }else if (button_.tag == 110) {
        EPModGarageVC *vc = [[EPModGarageVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
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