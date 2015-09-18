//
//  EPAccountVC.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPAccountVC.h"
#import "UserEPConnectionFuction.h"


@interface EPAccountVC (){
    UIImageView * mLoginContentV;
    UIView      * mInputV;
    EPLoginTextField * mPhone;
    EPLoginTextField * mPassword;
    EPLoginTextField * mCaptcha;
    
    UIButton * mProtocolButton;
    
    UIButton * mSubmitButton;
    
    UIButton * mChangeLoginAndRegistButton;
    
    NSString * phoneCode;
    
    UITextField * mCurrentTextField;
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

- (void)dealloc
{
    [mLoginContentV release],mLoginContentV = nil;
    [mInputV release],mInputV = nil;
    [super dealloc];
}

@end
