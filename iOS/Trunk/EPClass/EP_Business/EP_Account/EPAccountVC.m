//
//  EPAccountVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//


#define CELLHEIGHT_ROW0 283
#define CELLHEIGHT_ROW1 50
#define CELLHEIGHT_ROW2 50
#define CELLHEIGHT_ROW3 50
#define CELLHEIGHT_ROW4 50
#define CELLHEIGHT_ROW5 50
#define CELLHEIGHT_ROW6 100


#import "EPAccountVC.h"
#import "UserEPConnectionFuction.h"


@interface EPAccountVC (){
    UIImageView * mLoginContentV;
    UIView      * mAccountContentV;
    
    UIView      * mInputV;
    EPLoginTextField * mPhone;
    EPLoginTextField * mPassword;
    EPLoginTextField * mCaptcha;
    
    UIButton * mProtocolButton;
    
    UIButton * mSubmitButton;
    
    UIButton * mChangeLoginAndRegistButton;
    
    NSString * phoneCode;
    
    UITextField * mCurrentTextField;
    
    UITableView * mTableV;
}
@end

@implementation EPAccountVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (mType == EPAccountTypeAccount) {
        [self login];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"userCenter";
    [self setTopViewHidden:YES];

    mLoginContentV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.mContentView.width, self.mContentView.height)];
    mLoginContentV.image = [UIImage imageOrPDFNamed:@"view_login_background.pdf"];
    [self.mContentView addSubview:mLoginContentV];

    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageWithPDFNamed:@"btn_nav_back.pdf" atSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 100, 100);
//    [self.mContentView addSubview:backButton];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    mInputV = [[UIView alloc] initWithFrame:CGRectMake(AUTOSIZE(37), 309, K_SCREEN_WIDTH - AUTOSIZE(37 * 2), 40 * 3 + 7 * 2)];
    mInputV.backgroundColor = [UIColor clearColor];
    [self.mContentView addSubview:mInputV];

    mPhone = [[EPLoginTextField alloc] initWithFrame:CGRectMake(0, 0, mInputV.width, 40) type:EPLoginTextFieldTypePhone captchaSec:0];
    mPhone.textField.delegate = self;
    [mInputV addSubview:mPhone];
    
    mCaptcha = [[EPLoginTextField alloc] initWithFrame:CGRectMake(0, mPhone.bottom + 7, mInputV.width, 40) type:EPLoginTextFieldTypeCaptcha captchaSec:60];
    mCaptcha.mDelegate = self;
    mCaptcha.textField.delegate = self;
    [mInputV addSubview:mCaptcha];
    
    mPassword = [[EPLoginTextField alloc] initWithFrame:CGRectMake(0, mCaptcha.bottom + 7, mInputV.width, 40) type:EPLoginTextFieldTypePassword captchaSec:0];
    mPassword.textField.delegate = self;
    [mInputV addSubview:mPassword];
    
    mProtocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mProtocolButton.frame = CGRectMake(K_SCREEN_WIDTH/2 - 170/2, mInputV.bottom, 170, 40);
    mProtocolButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [mProtocolButton setTitle:@"易通行APP服务协议" forState:UIControlStateNormal];
    [mProtocolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mProtocolButton addTarget:self action:@selector(agreeProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mContentView addSubview:mProtocolButton];
    
    mSubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mSubmitButton.frame = CGRectMake(mInputV.left, mProtocolButton.bottom, mInputV.width, 40);
    mSubmitButton.backgroundColor = COLOR(240, 127, 56);
    mSubmitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [mSubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mSubmitButton addTarget:self action:@selector(submitToLoginOrRegist:) forControlEvents:UIControlEventTouchUpInside];
    if (mType == EPAccountTypeLogin) {
        [mSubmitButton setTitle:@"登陆" forState:UIControlStateNormal];
    }else if (mType == EPAccountTypeRegist){
        [mSubmitButton setTitle:@"注册" forState:UIControlStateNormal];
    }
    
    [self.mContentView addSubview:mSubmitButton];
    
    mChangeLoginAndRegistButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mChangeLoginAndRegistButton.frame = CGRectMake(K_SCREEN_WIDTH/2 - 170/2, mSubmitButton.bottom, 170, 40);
    mChangeLoginAndRegistButton.titleLabel.font = [UIFont systemFontOfSize:11];
    if (mType == EPAccountTypeLogin) {
        [mChangeLoginAndRegistButton setTitle:@"还没有账号? 注册" forState:UIControlStateNormal];
    }else if (mType == EPAccountTypeRegist){
        [mChangeLoginAndRegistButton setTitle:@"已有账号? 登陆" forState:UIControlStateNormal];
    }
    [mChangeLoginAndRegistButton addTarget:self action:@selector(changeLoginAndRegistTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [mChangeLoginAndRegistButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.mContentView addSubview:mChangeLoginAndRegistButton];
    
    [self changeTypeAndRefrashState:mType];
    
    mAccountContentV = [[UIView alloc] init];
    [self.view addSubview:mAccountContentV];
    
    __block EPAccountVC * weakVC = self;
    [mAccountContentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakVC.view);
        make.left.equalTo(weakVC.view);
        make.size.equalTo(CGSizeMake(K_SCREEN_WIDTH, K_SCREEN_HEIGHT));
    }];
    mAccountContentV.backgroundColor = [UIColor clearColor];
    
    mTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT) style:UITableViewStylePlain];
    mTableV.delegate = self;
    mTableV.dataSource = self;
    mTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mAccountContentV addSubview:mTableV];
    
}

- (void)changeTypeAndRefrashState:(EPAccountType)type_{
    mType = type_;
    if (type_ == EPAccountTypeLogin) {
        mCaptcha.hidden = YES;
        mInputV.height = 40 * 2 + 7;
        mPhone.top = 0;
        mPassword.top = mPhone.bottom + 7;
        mProtocolButton.top = mInputV.bottom;
        mSubmitButton.top = mProtocolButton.bottom;
        mChangeLoginAndRegistButton.top = mSubmitButton.bottom;
        [mSubmitButton setTitle:@"登陆" forState:UIControlStateNormal];
        [mChangeLoginAndRegistButton setTitle:@"还没有账号? 注册" forState:UIControlStateNormal];
    }else if (type_ == EPAccountTypeRegist){
        mCaptcha.hidden = NO;
        mInputV.height = 40 * 3 + 7 * 2;
        mPhone.top = 0;
        mCaptcha.top = mPhone.bottom + 7;
        mPassword.top = mCaptcha.bottom + 7;
        mProtocolButton.top = mInputV.bottom;
        mSubmitButton.top = mProtocolButton.bottom;
        mChangeLoginAndRegistButton.top = mSubmitButton.bottom;
        [mSubmitButton setTitle:@"注册" forState:UIControlStateNormal];
        [mChangeLoginAndRegistButton setTitle:@"已有账号? 登陆" forState:UIControlStateNormal];
    }
}

- (void)changeLoginAndRegistTypeAction:(UIButton *)button{
    if (mType == EPAccountTypeRegist) {
        [self changeTypeAndRefrashState:EPAccountTypeLogin];
    }else if (mType == EPAccountTypeLogin){
        [self changeTypeAndRefrashState:EPAccountTypeRegist];
    }
}

- (void)agreeProtocolAction:(UIButton *)button{
    button.selected = !button.selected;
}

- (void)submitToLoginOrRegist:(UIButton *)button{
    if (mType == EPAccountTypeLogin) {
        [self login];
    }else if (mType == EPAccountTypeRegist){
        [self regist];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)phoneCodeFinsh:(RKMappingResult *)data_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    LCAPIResult *result = data_.firstObject;
    if ([LTools isAPIJsonError:result]) {
        [APP_DELEGATE.mWindow makeToast:result.msg duration:2.0 position:@"custom"];
        return;
    }
}
- (void)phoneCodeFailed:(NSError *)error_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    [APP_DELEGATE.mWindow makeToast:@"网络连接失败" duration:2.0 position:@"custom"];
}

- (void)phoneCodeTimeOut:(NSError *)error_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    [APP_DELEGATE.mWindow makeToast:@"网络连接超时" duration:2.0 position:@"custom"];
}

- (void)login{
    [UserEPConnectionFuction userLogin_Phone:mPhone.textField.text password:mPassword.textField.text delegate:self allowCancel:YES finishSelector:@selector(requestInfoFinsh:) failSelector:@selector(requestFailed:) timeOutSelector:@selector(requestTimeOut:)];
}

- (void)getPhoneCode{
    [UserEPConnectionFuction phoneCode_mobile:mPhone.textField.text delegate:self allowCancel:YES finishSelector:@selector(phoneCodeFinsh:) failSelector:@selector(phoneCodeFailed:) timeOutSelector:@selector(phoneCodeTimeOut:)];
}

- (void)regist{
    [UserEPConnectionFuction registered_Phone:mPhone.textField.text password:mPassword.textField.text sendCode:mCaptcha.textField.text delegate:self allowCancel:YES finishSelector:@selector(registerFinsh:) failSelector:@selector(registerFailed:) timeOutSelector:@selector(registerTimeOut:)];
}


- (void)registerFinsh:(RKMappingResult *)data_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    LCAPIResult *result = data_.firstObject;
    if ([LTools isAPIJsonError:result]) {
        [APP_DELEGATE.mWindow makeToast:result.msg duration:2.0 position:@"custom"];
        return;
    }
}
- (void)registerFailed:(NSError *)error_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    [APP_DELEGATE.mWindow makeToast:@"网络连接失败" duration:2.0 position:@"custom"];
}

- (void)registerTimeOut:(NSError *)error_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    [APP_DELEGATE.mWindow makeToast:@"网络连接超时" duration:2.0 position:@"custom"];
}



//获取用户信息成功
- (void)requestInfoFinsh:(RKMappingResult *)data_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    LCAPIResult *result = data_.firstObject;
    if ([LTools isAPIJsonError:result]) {
        [APP_DELEGATE.mWindow makeToast:result.msg duration:2.0 position:@"custom"];
        return;
    }
}
- (void)requestFailed:(NSError *)error_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    [APP_DELEGATE.mWindow makeToast:@"网络连接失败" duration:2.0 position:@"custom"];
}

- (void)requestTimeOut:(NSError *)error_ {
    [LTools hideLoadingVOnTargetView:APP_DELEGATE.mWindow animation:YES];
    [APP_DELEGATE.mWindow makeToast:@"网络连接超时" duration:2.0 position:@"custom"];
}

- (void)EPLoginTextFieldSendCaptcha:(UIButton *)button{
    NSLog(@"sendCaptcha");
    [self getPhoneCode];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (mCurrentTextField && [mCurrentTextField isFirstResponder]) {
        [mCurrentTextField resignFirstResponder];
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    mCurrentTextField = textField;
    return YES;
}

-(void)backAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellIdentifier = [NSString stringWithFormat:@"EPAccountVCcellIdentifier%ld%ld",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        switch (indexPath.row) {
            case 0:{
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 200)];
                imageV.image = [UIImage imageNamed:@"view_account_top_background.png"];
                [cell.contentView addSubview:imageV];
                [imageV release];
                
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(K_SCREEN_WIDTH / 2 - 92 / 2, imageV.bottom - 92/2, 92, 92)];
                view.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:view];
                [LTools roundedRectangleView:view corner:view.width/2 width:0 color:[UIColor clearColor]];
                [view release];
                
                
                UIImageView * imageIconV = [[UIImageView alloc] initWithFrame:CGRectMake(view.width/2- 84/2, view.height/2-84/2, 84, 84)];
                imageIconV.backgroundColor = [UIColor blueColor];
                [LTools roundedRectangleView:imageIconV corner:imageIconV.width/2 width:0 color:[UIColor clearColor]];
                [view addSubview:imageIconV];
                [imageIconV release];
                
                UIView * bottomLine = [[UIView alloc] init];
                bottomLine.backgroundColor = HEXCOLOR(0xe5e5e5);
                [cell.contentView addSubview:bottomLine];
                [bottomLine release];
                
                [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(cell);
                    make.size.equalTo(CGSizeMake(K_SCREEN_WIDTH, 0.5));
                    make.left.equalTo(cell);
                    
                }];
                
            }
                break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:{
                UIImage * image;
                NSString * title = @"";
                switch (indexPath.row) {
                    case 1:
                        title = @"修改资料";
                        image = [UIImage imageWithPDFNamed:@"icon_account_profile.pdf" atSize:CGSizeMake(30, 30)];
                        break;
                    case 2:
                        title = @"修改密码";
                        image = [UIImage imageWithPDFNamed:@"icon_account_password.pdf" atSize:CGSizeMake(30, 30)];
                        break;
                    case 3:
                        title = @"车辆信息提交";
                        image = [UIImage imageWithPDFNamed:@"icon_account_mycar.pdf" atSize:CGSizeMake(30, 30)];
                        break;
                    case 4:
                        title = @"车库信息提交";
                        image = [UIImage imageWithPDFNamed:@"icon_account_mygarage.pdf" atSize:CGSizeMake(30, 30)];
                        break;
                    case 5:
                        title = @"设置";
                        image = [UIImage imageWithPDFNamed:@"icon_account_setting.pdf" atSize:CGSizeMake(30, 30)];
                        break;
                }
                
                UIImageView * iconImageV = [[UIImageView alloc] init];
                iconImageV.image = image;
                [cell.contentView addSubview:iconImageV];
                [iconImageV release];
                
                [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell);
                    make.left.equalTo(cell).with.offset(10);
                    make.size.equalTo(CGSizeMake(30, 30));
                }];
                
                
                
                UILabel * label = [[UILabel alloc] init];
                label.textAlignment = NSTextAlignmentLeft;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = HEXCOLOR(0x333333);
                label.backgroundColor = [UIColor clearColor];
                label.text = title;
                [cell.contentView addSubview:label];
                [label release];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(iconImageV.mas_right).with.offset(10);
                    make.centerY.equalTo(cell);
                    make.width.equalTo(cell).with.offset(label.right + 10);
                    make.height.equalTo(cell);
                    
                }];
                
                
                
                UIView * bottomLine = [[UIView alloc] init];
                bottomLine.backgroundColor = HEXCOLOR(0xe5e5e5);
                [cell.contentView addSubview:bottomLine];
                [bottomLine release];
                
                [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(cell);
                    make.size.equalTo(CGSizeMake(K_SCREEN_WIDTH, 0.5));
                    make.left.equalTo(cell);
                    
                }];
                
                
            }
                break;
            case 6:{
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.backgroundColor = COLOR(240, 127, 56);
                button.titleLabel.font = [UIFont systemFontOfSize:16];
                [button setTitle:@"登出" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(logoutAccount:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
                
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell).with.offset(37);
                    make.right.equalTo(cell).with.offset(-37);
                    make.height.equalTo(@40);
                    make.centerX.equalTo(cell);
                    make.bottom.equalTo(cell);
                }];
                
                
            }
                break;
        }
        
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return CELLHEIGHT_ROW0;
            break;
        case 1:
            return CELLHEIGHT_ROW1;
            break;
        case 2:
            return CELLHEIGHT_ROW2;
            break;
        case 3:
            return CELLHEIGHT_ROW3;
            break;
        case 4:
            return CELLHEIGHT_ROW4;
            break;
        case 5:
            return CELLHEIGHT_ROW5;
            break;
        case 6:
            return CELLHEIGHT_ROW6;
            break;
    }
    return 0;
}

- (void)logoutAccount:(UIButton *)button_{
    
    NSLog(@"logout");
}

- (void)dealloc
{
    [mLoginContentV release],mLoginContentV = nil;
    [mInputV release],mInputV = nil;
    [super dealloc];
}

@end
