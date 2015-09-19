//
//  EPSettingVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPSettingVC.h"

@interface EPSettingVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
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

@implementation EPSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设  置";

    // Init Table
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    [tabelView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSString *key = [_arKey objectAtIndex:section];
    if (section == 1) {
        return 1;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 15;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 400, 30)];
                [titleLabel setBackgroundColor:[UIColor clearColor]];
                [titleLabel setTextAlignment:NSTextAlignmentNatural];
                [titleLabel setTextColor:K_COLOR_DARK_TEXT];
                [titleLabel setFont:K_FONT_SIZE(15)];
                titleLabel.text = @"消息推送提醒";
                [cell.contentView addSubview:titleLabel];
                
                // Switch View
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                cell.accessoryView = switchView;
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                BOOL isAutoDown = [[userDefaultes valueForKey:@"isPushMSG"] boolValue];
                
                [switchView setOn:isAutoDown animated:NO];
                switchView.tag  = 1001;
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

            }else if(indexPath.row == 1) {
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 400, 30)];
                [titleLabel setBackgroundColor:[UIColor clearColor]];
                [titleLabel setTextAlignment:NSTextAlignmentNatural];
                [titleLabel setTextColor:K_COLOR_DARK_TEXT];
                [titleLabel setFont:K_FONT_SIZE(15)];
                titleLabel.text = @"清理缓存";
                [cell.contentView addSubview:titleLabel];
                
                UILabel *detalLabel = [[UILabel alloc] initWithFrame:CGRectMake(K_SCREEN_WIDTH - 118, 10, 100, 30)];
                [detalLabel setBackgroundColor:[UIColor clearColor]];
                [detalLabel setTextAlignment:NSTextAlignmentRight];
                [detalLabel setTextColor:K_COLOR_GRAY_FONT];
                [detalLabel setFont:K_FONT_SIZE(12)];
                detalLabel.tag = 1003;
                [cell.contentView addSubview:detalLabel];
            }else if(indexPath.row == 2) {
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 400, 30)];
                [titleLabel setBackgroundColor:[UIColor clearColor]];
                [titleLabel setTextAlignment:NSTextAlignmentNatural];
                [titleLabel setTextColor:K_COLOR_DARK_TEXT];
                [titleLabel setFont:K_FONT_SIZE(15)];
                titleLabel.text =  @"软件更新";;
                [cell.contentView addSubview:titleLabel];
                
                UILabel *detalLabel = [[UILabel alloc] initWithFrame:CGRectMake(K_SCREEN_WIDTH - 118, 10, 100, 30)];
                [detalLabel setBackgroundColor:[UIColor clearColor]];
                [detalLabel setTextAlignment:NSTextAlignmentRight];
                [detalLabel setTextColor:K_COLOR_GRAY_FONT];
                [detalLabel setFont:K_FONT_SIZE(12)];
                detalLabel.tag = 1003;
                [cell.contentView addSubview:detalLabel];
            }
            
        }else if (indexPath.section == 1) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 400, 40)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setTextAlignment:NSTextAlignmentNatural];
            [titleLabel setTextColor:K_COLOR_DARK_TEXT];
            [titleLabel setFont:K_FONT_SIZE(15)];
            titleLabel.text = @"关于易通行";
            [cell.contentView addSubview:titleLabel];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

            // Cal Documents/Audio files sizes
            ((UILabel *)[cell.contentView viewWithTag:1003]).text = [NSString stringWithFormat:@"%.2f M",13.5] ;
        }else if (indexPath.row == 2){
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            ((UILabel *)[cell.contentView viewWithTag:1003]).text = [NSString stringWithFormat:@"版本号：%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]] ;
        }
    }
    return cell;
}

- (void)switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    switch (switchControl.tag) {

            break;
        default:
            break;
    }
//    [self.mTableView reloadData];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index : %li",(long)indexPath.row);
}
#pragma mark-----buttonActoin---------

- (void)buttonPressed:(UIButton *)button_ {
    if (button_.tag == 100) {
        NSLog(@"IT'S GREAT");
    }else if (button_.tag == EP_BTN_RIGTH_TAG) {

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
