//
//  UserInfo.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/*
 *未知
 */
@property(nonatomic,strong)NSMutableString    *avatar;
/*
 *未知
 */
@property(nonatomic,strong)NSMutableString    *balance;
/*
 *未知
 */
@property(nonatomic,strong)NSMutableString    *etcdevice;
/*
 *未知
 */
@property(nonatomic,assign)long               dataid;
/*
 *未知
 */
@property(nonatomic,assign)BOOL               isbind;
/*
 *未知
 */
@property(nonatomic,strong)NSMutableString    *mobile;
/*
 *未知
 */
@property(nonatomic,strong)NSMutableString    *nickname;


@end
