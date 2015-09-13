//
//  OrderAddress.h
//  XiaoMai
//
//  Created by Jeanne on 15/7/28.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>
//addressType： string，非空，一级地址
//addresses：array，非空，二级地址
@interface OrderAddress : NSObject

/**
 * 一级地址
 */
@property (nonatomic,strong)NSMutableString *addressType;

/**
 * 二级地址
 */
@property (nonatomic,strong)NSArray *addresses;
@end
