//
//  EPCenterVC.m
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//

#import "EPCenterVC.h"

#import "EPModCarVC.h"

#import "EPCarVC.h"
#import "EPCarGarageCell.h"
#import "EPCarGarageModel.h"

@interface EPCarVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    //TABLE HEAER TITLE

    UIImageView         *_accountAvator;
    UILabel             *_accountTitle;
    
    //ACTION BTN
    UIButton            *actionBtn;
    
    //TEXTVIEW FIELD
    NSString            *_carDriveNO;
    NSString            *_carEngineNO;
    NSString            *_carOwner;
    NSString            *_carLPN;
    NSString            *_carCarBrand;
    NSString            *_carCarBoughtTime;
    
    //TEXTFILED UI
    UITextField         *profileTextField;
}

@property (nonatomic, strong)NSArray        *mDataArray;


@property(nonatomic, strong)UITableView     *mTableView;//TableView
@property(nonatomic, strong)UIButton        *mAddButton;//添加按钮

@end

@implementation EPCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的车辆管理";
    
    // Top Navi
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setAdjustsImageWhenHighlighted:NO];
    [addBtn setTitleColor:K_COLOR_DARK_TEXT forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:K_FONT_SIZE(14)];
    [addBtn setTitle:@"新增" forState:UIControlStateNormal];
    [addBtn setFrame:CGRectMake(0, 0, 40, 40)];
    addBtn.tag = EP_BTN_RIGTH_TAG;
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
    
    NSString *identifier =[NSString stringWithFormat:@"EPCarCell%ld",(long)indexPath.row];
    
    EPCarGarageCell *_EPCarCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!_EPCarCell) {
        _EPCarCell = [[EPCarGarageCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:identifier];
        _EPCarCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _EPCarCell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [_EPCarCell setEPCarGarageCellTitle:@"京P-781P9"
               setEPCarGarageCellDetail:@"大众宝莱"];
    
    
    return _EPCarCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index : %li",(long)indexPath.row);
}
#pragma mark-----buttonActoin---------

- (void)buttonPressed:(UIButton *)button_ {
    if (button_.tag == EP_BTN_RIGTH_TAG) {
        EPModCarVC *vc = [[EPModCarVC alloc]initCustomVCType:LCCustomBaseVCTypeNormal];
        [LTools pushController:vc animated:YES];
        [vc release],vc = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
