//
//  EPCenterVC.m
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//

#import "EPCenterVC.h"

#import "EPModPwdVC.h"

@interface EPModPwdVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    //TABLE HEAER TITLE

    UIImageView         *_accountAvator;
    UILabel             *_accountTitle;
    
    //ACTION BTN
    UIButton            *actionBtn;
    
    //TEXTVIEW FIELD
    NSString            *_oPwd;
    NSString            *_nPwd;
    NSString            *_nVPwd;
    
    //TEXTFILED UI
    UITextField         *profileTextField;
}

@property (nonatomic, strong)NSArray        *mDataArray;


@property(nonatomic, strong)UITableView     *mTableView;//TableView
@property(nonatomic, strong)UIButton        *mAddButton;//添加按钮

@end

@implementation EPModPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    self.mDataArray = @[
                        @[@"原   密   码"],
                        @[@"新   密   码"],
                        @[@"确认新密码"]
                      ];
    
    
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
    NSInteger row = [indexPath row];
    
    NSString *reuseIdentifier = @"ModifyPwdCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView  *grayLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50-0.5, K_SCREEN_WIDTH, 0.5)];
        grayLine.backgroundColor           = K_COLOR_GRAY_FONT;
        grayLine.alpha                     = 0.4;
        [cell.contentView addSubview:grayLine];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentNatural];
        [titleLabel setTextColor:K_COLOR_DARK_TEXT];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        titleLabel.tag = 10001;
        [cell.contentView addSubview:titleLabel];
    }
    ((UILabel *)[cell.contentView viewWithTag:10001]).text = [[self.mDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
    
    CGRect textFieldRect = CGRectMake(40.0, 15.0f, K_SCREEN_WIDTH-110, 44.0f);
    profileTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    profileTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    profileTextField.returnKeyType = UIReturnKeyDone;
    profileTextField.tag = row;
    [profileTextField setFont:[UIFont systemFontOfSize:15.0f]];
    profileTextField.textColor = [UIColor blackColor];
    profileTextField.delegate = self;
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15.f]
                                                                forKey:NSFontAttributeName];
    
    //Init Delegate
    [profileTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    switch (row) {
        case 0:
            profileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入原密码" attributes:attrsDictionary];
            break;
        case 1:
            profileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:attrsDictionary];
            break;
        case 2:
            profileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请确认输入新密码" attributes:attrsDictionary];
            break;
        default:
            break;
    }
    
    cell.accessoryView = profileTextField;
    
    return cell;
}


- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _oPwd = textField.text;
            break;
        case 1:
            _nPwd = textField.text;
            break;
        case 2:
            _nVPwd = textField.text;
            break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Adjust the UI
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    // Adjust the UI
    [sender resignFirstResponder];
    
    return YES;
}

-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [profileTextField resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index : %li",(long)indexPath.row);
}
#pragma mark-----buttonActoin---------

- (void)buttonPressed:(UIButton *)button_ {
    if (button_.tag == 100) {
        NSLog(@"IT'S GREAT");
    }else if (button_.tag == EP_BTN_RIGTH_TAG) {
//        EPDayVC *vc = [[EPDayVC alloc]initCustomVCType:LCCustomBaseVCTypeRoot];
//        [self.navigationController pushViewController:vc animated:YES];
        
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
