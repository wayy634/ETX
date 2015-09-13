//
//  MathFunction.h
//  LeCai
//
//  Created by hecai le on 12-9-3.
//  Copyright (c) 2012年 lehecai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MathFunction : NSObject {
    
}
//把sum 分解为在区间（_minNum,_maxNum）count个数的和 返回和的个数  其中count个数中不同的数有顺序 相同的数没有顺序//add by zhuhao 20130805
+ (int64_t)mathNumOfSumIsTotal:(int)_sum maxNum:(int)_maxNum minNum:(int)_minNum count:(int)_count;

//数学的组合公式，totalCount为总数量，subCount为子数量，即从totalCount中选出subCount个数的情况
+(int64_t)MathCombination:(NSInteger)totalCount :(NSInteger)subCount;

+(NSMutableArray*)getCombination:(NSInteger)totalCount subCount:(int)subCount;

//竞技足球 自由过关 算注数
+ (int)mathTotalFreeType:(NSArray *)array subCount:(NSArray *)sub;
+ (int)mathTotalMoreType:(NSArray *)array playType:(NSString *)type;
+ (int)mathTotalSingleMoreType:(NSArray *)array playType:(NSString *)type;

//计算篮彩玩法的彩票注数
+ (int)caulateLotteryAmountOfBasketPlayType:(NSArray *)betArray playTypes:(NSArray *)playTypes;

//排序小-大
+ (void)arrangeCards:(NSMutableArray *)array;

//排序
+ (void)arrangeCards:(NSMutableArray *)array_ arrayData:(NSArray *)arrayData_ isPositive:(BOOL)isPositive_;

//排序与目标数组一起 大->小 以后改..
+ (void)arrangeCards:(NSMutableArray *)_array withOtherArray1:(NSMutableArray *)_otherArray1 withOtherArray2:(NSMutableArray *)_otherArray2;

//排序_type=YES 小-大
+ (void)arrangeCards:(NSMutableArray *)_array withOtherArray1:(NSMutableArray *)_otherArray1 withOtherArray2:(NSMutableArray *)_otherArray2 withOtherArray3:(NSMutableArray *)_otherArray3 withOtherArray4:(NSMutableArray *)_otherArray4 type:(BOOL)_type;

//计算列的排列组合并且无相同数字
+ (int)MathCombinationWithNoSameNumber:(NSMutableArray *)_array;

@end
