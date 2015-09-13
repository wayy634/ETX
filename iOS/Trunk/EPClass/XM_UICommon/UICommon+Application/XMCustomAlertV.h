//
//  XMCustomAlertV.h
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/8/4.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMCustomAlertV : UIView
+ (XMCustomAlertV *)shareXMCustomAlertV;

- (void)setWithTitle:(NSString *)title_ msg:(NSString *)msg_ specialDataArray:(NSArray *)dataArray_ cancelButtonTitle:(NSString *)cancelTitle_ confirmButtonTitle:(NSString *)confirmTitle_ cancelButtonBlock:(void (^)(void))cancelBlock_ confirmButtonTitle:(void (^)(void))confirmBlock_;

@end
