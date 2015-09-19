//
//  EPOrderVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPOrderVC.h"

#import "EPMonthVC.h"

#import "EPSMonthCell.h"
#import "EPSMonthModel.h"

@interface EPOrderVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{

    
}


@property(nonatomic, strong)UITableView     *mTableView;//TableView
@property(nonatomic, strong)UIButton        *mAddButton;//添加按钮

@end

@implementation EPOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账单";
    [self.mContentView setBackgroundColor:K_COLOR_MAIN_BACKGROUND];
    
    // Top Navi
//    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [historyBtn setAdjustsImageWhenHighlighted:NO];
//    [historyBtn setImage:[UIImage imageOrPDFNamed:@"btn_nav_history.pdf"] forState:UIControlStateNormal];
//    [historyBtn setFrame:CGRectMake(0, 0, 40, 40)];
//    historyBtn.tag = 110;
//    [historyBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self initTopRightV:@[historyBtn]];
    

    
    
    
    
    // Init Table
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tabelView setBackgroundColor:K_COLOR_LIGHT_GRAY_BG];
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    USHSQACommentModel *model = self.commentDataArray[indexPath.row];
    
    NSString *identifier =[NSString stringWithFormat:@"EPMonthCell%ld",(long)indexPath.row];
    
    EPSMonthCell *_EPSMonthCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!_EPSMonthCell) {
        _EPSMonthCell = [[EPSMonthCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identifier];
        _EPSMonthCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _EPSMonthCell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [_EPSMonthCell setEPSMonthCellTitle:@"2015年8月"
                    setEPSMonthCellCost:@"3221.00"];
    
    
    return _EPSMonthCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index : %li",(long)indexPath.row);
    
    EPMonthVC *vc = [[EPMonthVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
    [LTools pushController:vc animated:YES];
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
