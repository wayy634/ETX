//
//  UITextField+Addition.h
//  XiaoMai
//
//  Created by Jeanne on 15/7/1.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextField (Addition)

//扩展数组把正则表达式按二维数组的方式添加,遍历的block返回msg是按添加的正则表达式添加顺序判断返回 例:regularExpressionArray =@[@[正则表达式,msg],@[正则表达式,msg]];
@property (nonatomic, strong)NSArray *regularExpressionArray;

//check当前的UITextField的text是否通过正则表达式数组的验证
- (BOOL)checkRegularExpression:(void (^)(NSString *msg))error_;

@end
