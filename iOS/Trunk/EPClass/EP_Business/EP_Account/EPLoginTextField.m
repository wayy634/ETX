//
//  EPLoginTextField.m
//  EPASS-APP-iOS
//
//  Created by zhanghan on 15/9/18.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPLoginTextField.h"

@interface EPLoginTextField(){
    UIImageView * iconImageV;
    UILabel     * titleLabel;
    EPLoginTextFieldType type;
    UIButton    * sendCaptchaButton;
    NSTimer     * timer;
    
    int           captchaSec;
    int           captchaCurrentSec;
}


@end

@implementation EPLoginTextField


- (instancetype)initWithFrame:(CGRect)frame_ type:(EPLoginTextFieldType)type_ captchaSec:(int)captchaSec_{
    if (self = [super initWithFrame:frame_]) {
        type = type_;
        captchaSec = captchaSec_;
        [self initViews];
    }
    return self;
}

- (void)initViews{
    
    
    self.backgroundColor = COLOR(10, 83, 164);
    
    UIImage * icon;
    NSString * title = @"";
    
    switch (type) {
        case EPLoginTextFieldTypePhone:
            icon = [UIImage imageWithPDFNamed:@"icon_login_mobile.pdf" atSize:CGSizeMake(23, 23)];
//            icon = [UIImage imageOrPDFNamed:@"icon_login_mobile.pdf"];
            title = @"手机号";
            break;
        case EPLoginTextFieldTypeCaptcha:
//            icon = [UIImage imageOrPDFNamed:@"icon_login_code.pdf"];
            icon = [UIImage imageWithPDFNamed:@"icon_login_code.pdf" atSize:CGSizeMake(23, 23)];
            title = @"验证码";
            break;
        case EPLoginTextFieldTypePassword:
            icon = [UIImage imageWithPDFNamed:@"icon_login_password.pdf" atSize:CGSizeMake(23, 23)];
//            icon = [UIImage imageOrPDFNamed:@"icon_login_password.pdf"];
            title = @"密码";
            break;
    }
    
    iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, self.height/2 - icon.size.height/2, icon.size.width, icon.size.height)];
    iconImageV.image = icon;
    iconImageV.backgroundColor = [UIColor clearColor];
    [self addSubview:iconImageV];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageV.right + 7, 0, 45, self.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [self addSubview:titleLabel];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.right + 5, 0, 0, self.height)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.placeholder = @"";
    _textField.textColor = [UIColor whiteColor];
    
    [self addSubview:_textField];
    
    if(type == EPLoginTextFieldTypePhone){
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        
        _textField.width = self.width - _textField.left - 10;
        
    }else if (type == EPLoginTextFieldTypePassword){
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.secureTextEntry = YES;
        
        _textField.width = self.width - _textField.left - 10;
    }else if (type == EPLoginTextFieldTypeCaptcha){
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        sendCaptchaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendCaptchaButton.frame = CGRectMake(self.width - 9 - 85, 10, 85, self.height - 20);
        sendCaptchaButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [sendCaptchaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendCaptchaButton.backgroundColor = COLOR( 85, 146, 199);
        [sendCaptchaButton addTarget:self action:@selector(sendCaptchaAction:) forControlEvents:UIControlEventTouchUpInside];
        [sendCaptchaButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self addSubview:sendCaptchaButton];
        _textField.width = self.width - _textField.left - sendCaptchaButton.width - 5;
    }
}


- (void)sendCaptchaAction:(UIButton *)button{
    if ([_mDelegate respondsToSelector:@selector(EPLoginTextFieldSendCaptcha:)]) {
        [_mDelegate EPLoginTextFieldSendCaptcha:sendCaptchaButton];
    }
    captchaCurrentSec = captchaSec;
    sendCaptchaButton.enabled = NO;
    captchaCurrentSec--;
    [sendCaptchaButton setTitle:[NSString stringWithFormat:@"%d秒后重发",captchaCurrentSec] forState:UIControlStateNormal];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(captchaAction:) userInfo:nil repeats:YES];
}

- (void)captchaAction:(NSTimer *)timer_{
    captchaCurrentSec--;
    if (captchaCurrentSec == 0) {
        sendCaptchaButton.enabled = YES;
        [sendCaptchaButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [timer_ invalidate];
        timer_ = nil;
        return;
    }
    [sendCaptchaButton setTitle:[NSString stringWithFormat:@"%d秒后重试",captchaCurrentSec] forState:UIControlStateNormal];
}

-(void)dealloc{
    [iconImageV release],iconImageV = nil;
    [titleLabel release],titleLabel = nil;
    [_textField release],_textField = nil;
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
