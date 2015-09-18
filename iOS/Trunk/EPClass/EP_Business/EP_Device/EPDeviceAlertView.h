//
//  EPDeviceAlertView.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/18.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEVICEALERT_LEFT    38.0
#define DEVICEALERT_WIDTH   K_SCREEN_WIDTH - (DEVICEALERT_LEFT*2)

#define DEVICEALERT_HEIGHT  300.0
#define DEVICEALERT_TOP     (K_SCREEN_HEIGHT - DEVICEALERT_HEIGHT)/2-AUTOSIZE(20)

typedef NS_ENUM(NSInteger, EPDeviceAlertType) {
    EPDeviceAlertType_WaitSearch      =  0 ,//等待
    EPDeviceAlertType_Searched        =  1  //邀请成功
};

@class EPDeviceAlertView;

@protocol EPDeviceAlertViewDelegate <NSObject>

- (void)cannelSearch:(EPDeviceAlertView *)view_;

- (void)startSearch:(EPDeviceAlertView *)view_;

- (void)bindingDevice:(EPDeviceAlertView *)view_ device:(id)device_;

@end


@interface EPDeviceAlertView : UIView

@property(nonatomic, assign)id<EPDeviceAlertViewDelegate>         mDelegate;//类型
@property(nonatomic, assign)EPDeviceAlertType                     mType;//类型


- (void)initUIWithType:(EPDeviceAlertType)type_;

- (void)showAlertView;

@end
