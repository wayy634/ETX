//
//  EPDeviceAlertView.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/18.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPDeviceAlertView.h"

@interface EPDeviceAlertView ()

@property(nonatomic, strong)UIView                     *mShadowView;//半透明
@property(nonatomic, strong)UIView                     *mAlertView;//弹窗
@property(nonatomic, strong)UIImageView                *mIconView;//icon
@property(nonatomic, strong)UILabel                    *mTitleLabel;//标题
@property(nonatomic, strong)UILabel                    *mDescLabel;//描述
@property(nonatomic, strong)UIButton                   *mCannelButton;//取消
@property(nonatomic, strong)UIButton                   *mSendButton;//发送

@end


@implementation EPDeviceAlertView

- (void)initUIWithType:(EPDeviceAlertType)type_ {
    self.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
    self.hidden = YES;
    
    self.mShadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.mShadowView.backgroundColor = K_COLOR_MAIN_FONT;
    self.mShadowView.alpha = 0.7;
    self.backgroundColor =[UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAreaSelectView)];
    [self.mShadowView addGestureRecognizer:tap];
    [self addSubview:self.mShadowView];
    [tap release],tap = nil;
    
    
    self.mAlertView = [[UIView alloc]initWithFrame:CGRectMake(DEVICEALERT_LEFT, DEVICEALERT_TOP, DEVICEALERT_WIDTH, DEVICEALERT_HEIGHT)];
    self.mAlertView.layer.cornerRadius = 10.0;
    [self.mAlertView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.mAlertView];
    self.mType = type_;
    
    self.mTitleLabel = [LCUITools creatNewLabel:CGRectMake(0, 0, self.mAlertView.width, 55) text:@"" color:K_COLOR_MAIN_FONT font:K_FONT_SIZE(15) textAlinment:NSTextAlignmentCenter];
    [self.mAlertView addSubview:self.mTitleLabel];
    
    UIImage *iconImage = [UIImage imageWithPDFNamed:@"icon_sidemenu_today.pdf" atSize:CGSizeMake(98, 98)];
    self.mIconView = [[UIImageView alloc] initWithFrame:CGRectMake((self.mAlertView.width-iconImage.size.width)/2, self.mTitleLabel.bottom+10, iconImage.size.width, iconImage.size.height)];
    [self.mIconView setBackgroundColor:[UIColor redColor]];
    self.mIconView.image = iconImage;
    [self.mAlertView addSubview:self.mIconView];
    
    self.mDescLabel = [LCUITools creatNewLabel:CGRectMake(25, self.mIconView.bottom+10, self.mAlertView.width-50, 55) text:@"" color:K_COLOR_MAIN_FONT font:K_FONT_SIZE(15) textAlinment:NSTextAlignmentCenter];
    self.mDescLabel.numberOfLines = 0;
    [self.mAlertView addSubview:self.mDescLabel];
    
    self.mCannelButton = [self createButtonWithTitle:@"关闭" titleColor:K_COLOR_MAIN_FONT frame:CGRectMake(0,self.mAlertView.height-30-15,self.mAlertView.width/2, 30) bgColor:[UIColor whiteColor] tag:0];
    [self.mAlertView addSubview:self.mCannelButton];
    
    self.mSendButton = [self createButtonWithTitle:@"开始查找" titleColor:K_COLOR_MAIN_FONT frame:CGRectMake(self.mCannelButton.right, self.mCannelButton.top, self.mCannelButton.width, self.mCannelButton.height) bgColor:[UIColor whiteColor] tag:1];
    [self.mAlertView addSubview:self.mSendButton];
    
    [self.mAlertView addSubview:[LCUITools creatLineView:CGRectMake(self.mAlertView.width/2, self.mAlertView.height-30-15, 1, 30) bgColor:K_COLOR_MAIN_LINE]];
    
    self.mType = type_;
}

-(void)setMType:(EPDeviceAlertType)mType {
    _mType = mType;
    [self createViews];
}

- (void)createViews {
    if (self.mType == EPDeviceAlertType_WaitSearch) {
        self.mTitleLabel.text = @"查找设备";
        [self.mSendButton setTitle:@"开始查找" forState:UIControlStateNormal];
        self.mDescLabel.text = @"查找设备提示:\n1.请在车内与设备一起操作;\n2.请确认蓝牙状态开启;";
        self.mDescLabel.textAlignment = NSTextAlignmentLeft;
    }else if (self.mType == EPDeviceAlertType_Searched) {
        self.mTitleLabel.text = @"查找到一下设备";
        [self.mSendButton setTitle:@"确认绑定" forState:UIControlStateNormal];
        self.mDescLabel.text = @"设备状态:未绑定\n设备号:123213123123";
        self.mDescLabel.textAlignment = NSTextAlignmentCenter;
    }
}


#pragma 创建button
-(UIButton *)createButtonWithTitle:(NSString *)title_ titleColor:(UIColor *)color_ frame:(CGRect)rect_ bgColor:(UIColor *)bgColor_ tag:(long)tag_  {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = bgColor_;
    button.frame = rect_;
    [button setTitle:title_ forState:UIControlStateNormal];
    button.titleLabel.font = K_FONT_SIZE(15);
    [button setTitleColor:color_ forState:UIControlStateNormal];
    button.tag = tag_;
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)showAlertView {
    self.hidden = NO;
    self.mAlertView.alpha = 0.0;
    self.mShadowView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.mAlertView.alpha = 1;
        self.mShadowView.alpha = 0.7;
    }];
}

- (void)hiddenAreaSelectView {
    [UIView animateWithDuration:0.3 animations:^{
        self.mAlertView.alpha = 0;
        self.mShadowView.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}

- (void)buttonPress:(UIButton *)button_ {
    [self hiddenAreaSelectView];
    if (button_.tag == 1) {
        if(self.mType == EPDeviceAlertType_WaitSearch) {
            [self.mDelegate startSearch:self];
        }else if (self.mType == EPDeviceAlertType_Searched) {
            [self.mDelegate bindingDevice:self device:nil];
        }
    }else if (button_.tag == 0){
        [self.mDelegate cannelSearch:self];
    }
}

- (void)dealloc {
    self.mIconView = nil;
    self.mDescLabel = nil;
    self.mSendButton = nil;
    self.mCannelButton = nil;
    [super dealloc];
}


@end
