//
//  EPLoginTextField.h
//  EPASS-APP-iOS
//
//  Created by zhanghan on 15/9/18.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//


@protocol EPLoginTextFieldDelegate <NSObject>

- (void)EPLoginTextFieldSendCaptcha:(UIButton *)button;

@end

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, EPLoginTextFieldType){
    EPLoginTextFieldTypePhone = 0,
    EPLoginTextFieldTypeCaptcha = 1,
    EPLoginTextFieldTypePassword = 2
};


@interface EPLoginTextField : UIView

@property(nonatomic,retain)UITextField * textField;
@property(nonatomic,assign)id<EPLoginTextFieldDelegate> mDelegate;


- (instancetype)initWithFrame:(CGRect)frame_ type:(EPLoginTextFieldType)type_ captchaSec:(int)captchaSec_;

@end
