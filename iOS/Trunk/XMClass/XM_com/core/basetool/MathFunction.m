//
//  MathFunction.m
//  LeCai
//
//  Created by hecai le on 12-9-3.
//  Copyright (c) 2012年 lehecai. All rights reserved.
//

#import "MathFunction.h"

@implementation MathFunction
+ (int64_t)mathNumOfSumIsTotal:(int)_sum maxNum:(int)_maxNum minNum:(int)_minNum count:(int)_count{
    int64_t num = 0;
    if (_count < 2) {
        return 0;
    }
    if (_count == 2) {
        if (_sum <= _maxNum) {
            num =  _sum+1-2*_minNum;
        }else{
            num = _sum+1-2*_minNum-2*(_sum-_maxNum-_minNum);
        }
        return num > 0?num:0;
    }
    _count--;
    for (int i = 0; i <= _sum; i++) {
        if (i >= _minNum && i <= _maxNum) {
            num += [MathFunction mathNumOfSumIsTotal:_sum-i maxNum:_maxNum minNum:_minNum count:_count];
        }
    }
    return num;
}

+(int64_t)MathCombination:(NSInteger)totalCount :(NSInteger)subCount
{
	if(totalCount < subCount)
	{
		return 0;
	}
	if(totalCount == subCount ){
		return 1;
	}else{
		int64_t numerator  =  subCount+1;//分子
		int64_t denominator = 1;//分母
		int64_t countNum = 1;//循环次数
		int64_t countUnit[2] = {subCount+1,1};
		
		if( totalCount - subCount > subCount ){
			numerator = totalCount - subCount +1;
			countUnit[0] = numerator;
			countNum = subCount -1;
		}else{
			countNum = totalCount - subCount-1;
		}
		
		for( int64_t i = 0; i< countNum; i++ ){
			numerator *= (++countUnit[0]);
			denominator *=(++countUnit[1]);
		}
		return numerator/denominator;
	}
}

+(NSMutableArray*)getCombination:(NSInteger)totalCount subCount:(int)subCount
{
	NSMutableArray	*result = [NSMutableArray arrayWithCapacity:10];
	//OC中支持动态数组，非常高兴 
	int	num[subCount+1],s,i; 
	
	num[1]=0;s=1; 
	while(s!=0) 
	{ 
		if(s!=subCount)//取小于M个数 
		{ 
			num[s]++; 
			
			if(num[s]> totalCount-subCount+s) 
				s--;//回朔 
			else 
			{ 
				s++; 
				num[s]=num[s-1]; 
			} 
		} 
		else//取第M个数 
		{ 
			num[s]++; 
			NSMutableArray* itemResult = [[NSMutableArray alloc] init];
			for(i=1;i <=subCount;i++)
			{
				[itemResult addObject: [NSNumber numberWithInt: num[i]]];
			}
			[result addObject:itemResult];
			[itemResult release];
			if(num[s]==totalCount-subCount+s)
				s--;//回朔 
		} 
	} 
	return result;
}

+ (int)mathTotalFreeType:(NSArray *)array subCount:(NSArray *)sub {
    int totalCount = 0;
    for (int z = 0; z < [sub count]; z++) {
        int result = 0;
        int dan = 0;
        int danCount = 0;
        NSMutableArray *tempDanarray = [[NSMutableArray alloc] init];
        NSMutableArray *tempNoDanArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; i++) {
            if ([[[array objectAtIndex:i] lastObject] intValue] == 1) {
                dan++;
                danCount = 0;
                for (int j = 0; j < [(NSArray *)[array objectAtIndex:0] count] - 1; j++) {
                    if ([[[array objectAtIndex:i] objectAtIndex:j] intValue] == 1) {
                        danCount++;
                    }
                }
                if (danCount != 0) {
                    [tempDanarray addObject:[NSNumber numberWithInt:danCount]];
                }
            }
            else {
                [tempNoDanArray addObject:[array objectAtIndex:i]];
            }
            
        }
        NSMutableArray	*results = [NSMutableArray arrayWithCapacity:60];
        for(int i=0; i<[tempNoDanArray count]; i++)
        {
            NSMutableArray*	item = [tempNoDanArray objectAtIndex:i];
            int count = 0;
            for (int j = 0; j < [(NSArray *)[array objectAtIndex:0] count] - 1; j++) {
                if ([[item objectAtIndex:j] intValue] == 1) {
                    count++;
                }
            }
            if(count > 0)
            {
                [results addObject:[NSNumber numberWithInt:count]];
            }
        }
        //        if([results count] + dan >= 9)
        //        {
        for(NSNumber *temp in results)
        {      
            result *= [temp intValue];
        }
//        NSLog(@"results.count = %i",results.count);
//        NSLog(@"tempNoDanArray = %@",tempNoDanArray);
//        NSLog(@"tempDanarray = %@",tempDanarray);
//        
//        NSLog(@"[[sub objectAtIndex:z] intValue] = %i",[[sub objectAtIndex:z] intValue]);
//        NSLog(@"dan = %i",dan);
        if (results.count == 0) {
            return totalCount;
        }
        NSMutableArray* test = [MathFunction getCombination:results.count subCount:([[sub objectAtIndex:z] intValue] - dan)];
        
//        NSLog(@"test = %@",test);
        
        int tempResult = 1;
        for(NSMutableArray* item in test)
        {
            for(NSNumber* num in item)
            {
                tempResult *= [[results objectAtIndex:[num intValue]-1] intValue];
            }
            result += tempResult;
            tempResult = 1;
        }
        test = nil;
        if (dan != 0) {
            for (NSNumber *temp in tempDanarray){
                result *= [temp intValue]; 
            }
        }
        totalCount += result;
        results = nil;
        [tempDanarray release] ,   tempDanarray = nil;
        [tempNoDanArray release] , tempNoDanArray = nil;
        
    }
    return totalCount;
}

+ (int)mathTotalSingleMoreType:(NSArray *)array playType:(NSString *)type {
    int billCount = 0;
    //    for (int i = 0; i < [array count]; i++) {
    //        [[array objectAtIndex:i] removeLastObject];
    //        [[array objectAtIndex:i] addObject:@"0"];
    //    }
    if ([type isEqualToString:@"单关"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1", nil]];
    } else if ([type isEqualToString:@"2串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2", nil]];
    } else if ([type isEqualToString:@"2串3"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1",@"2", nil]];
    } else if ([type isEqualToString:@"3串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3", nil]];
    } else if ([type isEqualToString:@"3串3"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2", nil]];
    } else if ([type isEqualToString:@"3串4"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",nil]];
    } else if ([type isEqualToString:@"3串7"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1",@"2",@"3",nil]];
    } else if ([type isEqualToString:@"4串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",nil]];
    } else if ([type isEqualToString:@"4串4"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3",nil]];
    } else if ([type isEqualToString:@"4串5"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3",@"4",nil]];
    } else if ([type isEqualToString:@"4串6"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",nil]];
    } else if ([type isEqualToString:@"4串11"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",nil]];
    } else if ([type isEqualToString:@"4串15"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",nil]];
    } else if ([type isEqualToString:@"5串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"5",nil]];
    } else if ([type isEqualToString:@"5串5"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",nil]];
    } else if ([type isEqualToString:@"5串6"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",@"5",nil]];
    } else if ([type isEqualToString:@"5串10"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",nil]];
    } else if ([type isEqualToString:@"5串16"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3",@"4",@"5",nil]];
    } else if ([type isEqualToString:@"5串20"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",nil]];
    } else if ([type isEqualToString:@"5串26"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",@"5",nil]];
    } else if ([type isEqualToString:@"5串31"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil]];
    } else if ([type isEqualToString:@"6串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"6",nil]];
    } else if ([type isEqualToString:@"6串6"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"5",nil]];
    } else if ([type isEqualToString:@"6串7"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"5",@"6",nil]];
    } else if ([type isEqualToString:@"6串15"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",nil]];
    } else if ([type isEqualToString:@"6串20"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3",nil]];
    } else if ([type isEqualToString:@"6串22"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",@"5",@"6",nil]];
    } else if ([type isEqualToString:@"6串35"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",nil]];
    } else if ([type isEqualToString:@"6串42"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3",@"4",@"5",@"6",nil]];
    } else if ([type isEqualToString:@"6串50"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",nil]];
    } else if ([type isEqualToString:@"6串57"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6",nil]];
    } else if ([type isEqualToString:@"6串63"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",nil]];
    } else if ([type isEqualToString:@"7串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"7",nil]];
    } else if ([type isEqualToString:@"7串7"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"6",nil]];
    } else if ([type isEqualToString:@"7串8"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"6",@"7",nil]];
    } else if ([type isEqualToString:@"7串21"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"5",nil]];
    } else if ([type isEqualToString:@"7串35"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",nil]];
    } else if ([type isEqualToString:@"7串120"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6",@"7",nil]];
    } else if ([type isEqualToString:@"8串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"8",nil]];
    } else if ([type isEqualToString:@"8串8"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"7",nil]];
    } else if ([type isEqualToString:@"8串9"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"7",@"8",nil]];
    } else if ([type isEqualToString:@"8串28"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"6",nil]];
    } else if ([type isEqualToString:@"8串56"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"5",nil]];
    } else if ([type isEqualToString:@"8串70"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",nil]];
    } else if ([type isEqualToString:@"8串247"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6",@"7",@"8",nil]];
    } else if ([type isEqualToString:@"9串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"9",nil]];
    } else if ([type isEqualToString:@"10串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"10",nil]];
    } else if ([type isEqualToString:@"11串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"11",nil]];
    } else if ([type isEqualToString:@"12串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"12",nil]];
    } else if ([type isEqualToString:@"13串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"13",nil]];
    } else if ([type isEqualToString:@"14串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"14",nil]];
    } else if ([type isEqualToString:@"15串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"15",nil]];
    }
    
    
    return billCount;
}

+ (int)mathTotalMoreType:(NSArray *)array playType:(NSString *)type {
    int billCount = 0;
    for (int i = 0; i < [array count]; i++) {
        [[array objectAtIndex:i] removeLastObject];
        [[array objectAtIndex:i] addObject:@"0"];
    }
    if ([type isEqualToString:@"单关"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1", nil]];
    } else if ([type isEqualToString:@"2串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2", nil]];
    } else if ([type isEqualToString:@"2串3"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1",@"2", nil]];
    } else if ([type isEqualToString:@"3串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3", nil]];
    } else if ([type isEqualToString:@"3串3"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2", nil]];
    } else if ([type isEqualToString:@"3串4"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",nil]];
    } else if ([type isEqualToString:@"3串7"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1",@"2",@"3",nil]];
    } else if ([type isEqualToString:@"4串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",nil]];
    } else if ([type isEqualToString:@"4串4"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3",nil]];
    } else if ([type isEqualToString:@"4串5"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3",@"4",nil]];
    } else if ([type isEqualToString:@"4串6"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",nil]];
    } else if ([type isEqualToString:@"4串11"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",nil]];
    } else if ([type isEqualToString:@"4串15"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",nil]];
    } else if ([type isEqualToString:@"5串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"5",nil]];
    } else if ([type isEqualToString:@"5串5"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",nil]];
    } else if ([type isEqualToString:@"5串6"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",@"5",nil]];
    } else if ([type isEqualToString:@"5串10"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",nil]];
    } else if ([type isEqualToString:@"5串16"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3",@"4",@"5",nil]];
    } else if ([type isEqualToString:@"5串20"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",nil]];
    } else if ([type isEqualToString:@"5串26"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",@"5",nil]];
    } else if ([type isEqualToString:@"5串31"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil]];
    } else if ([type isEqualToString:@"6串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"6",nil]];
    } else if ([type isEqualToString:@"6串6"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"5",nil]];
    } else if ([type isEqualToString:@"6串7"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"5",@"6",nil]];
    } else if ([type isEqualToString:@"6串15"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",nil]];
    } else if ([type isEqualToString:@"6串20"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3",nil]];
    } else if ([type isEqualToString:@"6串22"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",@"5",@"6",nil]];
    } else if ([type isEqualToString:@"6串35"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",nil]];
    } else if ([type isEqualToString:@"6串42"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"3",@"4",@"5",@"6",nil]];
    } else if ([type isEqualToString:@"6串50"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",nil]];
    } else if ([type isEqualToString:@"6串57"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6",nil]];
    } else if ([type isEqualToString:@"6串63"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",nil]];
    } else if ([type isEqualToString:@"7串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"7",nil]];
    } else if ([type isEqualToString:@"7串7"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"6",nil]];
    } else if ([type isEqualToString:@"7串8"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"6",@"7",nil]];
    } else if ([type isEqualToString:@"7串21"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"5",nil]];
    } else if ([type isEqualToString:@"7串35"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",nil]];
    } else if ([type isEqualToString:@"7串120"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6",@"7",nil]];
    } else if ([type isEqualToString:@"8串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"8",nil]];
    } else if ([type isEqualToString:@"8串8"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"7",nil]];
    } else if ([type isEqualToString:@"8串9"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"7",@"8",nil]];
    } else if ([type isEqualToString:@"8串28"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"6",nil]];
    } else if ([type isEqualToString:@"8串56"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"5",nil]];
    } else if ([type isEqualToString:@"8串70"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"4",nil]];
    } else if ([type isEqualToString:@"8串247"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6",@"7",@"8",nil]];
    } else if ([type isEqualToString:@"9串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"9",nil]];
    } else if ([type isEqualToString:@"10串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"10",nil]];
    } else if ([type isEqualToString:@"11串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"11",nil]];
    } else if ([type isEqualToString:@"12串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"12",nil]];
    } else if ([type isEqualToString:@"13串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"13",nil]];
    } else if ([type isEqualToString:@"14串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"14",nil]];
    } else if ([type isEqualToString:@"15串1"]) {
        billCount += [self mathTotalFreeType:array subCount:[NSArray arrayWithObjects:@"15",nil]];
    }
    
    
    return billCount;
}

+ (int)caulateLotteryAmountOfBasketPlayType:(NSArray *)betArray playTypes:(NSArray *)playTypes
{
    NSMutableArray *tmpPlayTypes = [NSMutableArray array];
    BOOL hasSingle = NO;
    
    for (id aPlayType in playTypes) {
        if ([aPlayType intValue] == 1) {
            hasSingle = YES;
        } else {
            [tmpPlayTypes addObject:aPlayType];
        }
    }
    
    int lotteryAmount = [self mathTotalFreeType:betArray subCount:tmpPlayTypes];
    
    if (hasSingle) {
        int amount = 0;
        for (NSArray *betDetail in betArray) {
            for (int i = 0; i < [betDetail count] - 1; i++) {
                if ([[betDetail objectAtIndex:i] boolValue]) {
                    amount++;
                }
            }
        }
        
        lotteryAmount += amount;
    }
    
    return lotteryAmount;
}

+ (void)arrangeCards:(NSMutableArray *)array {
    for (int i=0; i<[array count]; i++) {
		for (int j=i+1; j<[array count]; j++) {
			NSString  *last = [array objectAtIndex:i];
			NSString  *next = [array objectAtIndex:j];
			
			if ([last doubleValue] > [next doubleValue]) {
				NSMutableString	 *tempString = [[NSMutableString alloc] init];
                
                [tempString setString:[array objectAtIndex:j]];
				
				[array replaceObjectAtIndex:j withObject:[array objectAtIndex:i]];
				
				[array replaceObjectAtIndex:i withObject:tempString];
				
				[tempString release]; tempString = nil;
				
			}
		}
	}
}

+ (void)arrangeCards:(NSMutableArray *)array_ arrayData:(NSArray *)arrayData_ isPositive:(BOOL)isPositive_ {
    for (int i=0; i<[array_ count]; i++) {
        for (int j=i+1; j<[array_ count]; j++) {
            NSString  *last = [array_ objectAtIndex:i];
            NSString  *next = [array_ objectAtIndex:j];
            if (!isPositive_ ? ([last doubleValue] > [next doubleValue]) : ([last doubleValue] < [next doubleValue])) {
                NSMutableString	 *tempString = [[NSMutableString alloc] init];
                [tempString setString:[array_ objectAtIndex:j]];
                [array_ replaceObjectAtIndex:j withObject:[array_ objectAtIndex:i]];
                [array_ replaceObjectAtIndex:i withObject:tempString];
                [tempString release]; tempString = nil;
                if (arrayData_ != nil) {
                    for (NSMutableArray *tempArray in arrayData_) {
                        id object = [[tempArray objectAtIndex:j] retain];
                        [tempArray replaceObjectAtIndex:j withObject:[tempArray objectAtIndex:i]];
                        [tempArray replaceObjectAtIndex:i withObject:object];
                        object = nil;
                    }
                }
            }
        }
    }
}

+ (void)arrangeCards:(NSMutableArray *)_array withOtherArray1:(NSMutableArray *)_otherArray1 withOtherArray2:(NSMutableArray *)_otherArray2 withOtherArray3:(NSMutableArray *)_otherArray3 withOtherArray4:(NSMutableArray *)_otherArray4 type:(BOOL)_type {
    if (_type) {
        for (int i=0; i<[_array count]; i++) {
            for (int j=i+1; j<[_array count]; j++) {
                NSString  *last = [_array objectAtIndex:i];
                NSString  *next = [_array objectAtIndex:j];
                
                if ([last doubleValue] > [next doubleValue]) {
                    NSMutableString	 *tempString = [[NSMutableString alloc] init];
                    [tempString setString:[_array objectAtIndex:j]];
                    [_array replaceObjectAtIndex:j withObject:[_array objectAtIndex:i]];
                    [_array replaceObjectAtIndex:i withObject:tempString];
                    [tempString release]; tempString = nil;
                    
                    if (_otherArray1 != nil) {
//                        id object1;
//                        object1 = [_otherArray1 objectAtIndex:j];
//                        [_otherArray1 replaceObjectAtIndex:j withObject:[_otherArray1 objectAtIndex:i]];
//                        [_otherArray1 replaceObjectAtIndex:i withObject:object1];
//                        object1 = nil;
                        NSMutableString	 *tempString = [[NSMutableString alloc] init];
                        [tempString setString:[_otherArray1 objectAtIndex:j]];
                        [_otherArray1 replaceObjectAtIndex:j withObject:[_otherArray1 objectAtIndex:i]];
                        [_otherArray1 replaceObjectAtIndex:i withObject:tempString];
                        [tempString release]; tempString = nil;
                    }
                    
                    if (_otherArray2 != nil) {
                        NSMutableString	 *tempString = [[NSMutableString alloc] init];
                        [tempString setString:[_otherArray2 objectAtIndex:j]];
                        [_otherArray2 replaceObjectAtIndex:j withObject:[_otherArray2 objectAtIndex:i]];
                        [_otherArray2 replaceObjectAtIndex:i withObject:tempString];
                        [tempString release]; tempString = nil;
                    }
                    
                    if (_otherArray3 != nil) {
                        NSMutableString	 *tempString = [[NSMutableString alloc] init];
                        [tempString setString:[_otherArray3 objectAtIndex:j]];
                        [_otherArray3 replaceObjectAtIndex:j withObject:[_otherArray3 objectAtIndex:i]];
                        [_otherArray3 replaceObjectAtIndex:i withObject:tempString];
                        [tempString release]; tempString = nil;
                    }
                    
                    if (_otherArray4 != nil) {
                        NSMutableString	 *tempString = [[NSMutableString alloc] init];
                        [tempString setString:[_otherArray4 objectAtIndex:j]];
                        [_otherArray4 replaceObjectAtIndex:j withObject:[_otherArray4 objectAtIndex:i]];
                        [_otherArray4 replaceObjectAtIndex:i withObject:tempString];
                        [tempString release]; tempString = nil;
                    }
                }
            }
        }
    } else {
        for (int i=0; i<[_array count]; i++) {
            for (int j=i+1; j<[_array count]; j++) {
                NSString  *last = [_array objectAtIndex:i];
                NSString  *next = [_array objectAtIndex:j];
                
                if ([last doubleValue] < [next doubleValue]) {
                    NSMutableString	 *tempString = [[NSMutableString alloc] init];
                    [tempString setString:[_array objectAtIndex:j]];
                    [_array replaceObjectAtIndex:j withObject:[_array objectAtIndex:i]];
                    [_array replaceObjectAtIndex:i withObject:tempString];
                    [tempString release]; tempString = nil;
                    
                    if (_otherArray1 != nil) {
//                        id object1;
//                        object1 = [_otherArray1 objectAtIndex:j];
//                        [_otherArray1 replaceObjectAtIndex:j withObject:[_otherArray1 objectAtIndex:i]];
//                        [_otherArray1 replaceObjectAtIndex:i withObject:object1];
//                        object1 = nil;
                        
                        NSMutableString	 *tempString = [[NSMutableString alloc] init];
                        [tempString setString:[_otherArray1 objectAtIndex:j]];
                        [_otherArray1 replaceObjectAtIndex:j withObject:[_otherArray1 objectAtIndex:i]];
                        [_otherArray1 replaceObjectAtIndex:i withObject:tempString];
                        [tempString release]; tempString = nil;
                    }
                    
                    if (_otherArray2 != nil) {
//                        id object2;
//                        object2 = [_otherArray2 objectAtIndex:j];
//                        [_otherArray2 replaceObjectAtIndex:j withObject:[_otherArray2 objectAtIndex:i]];
//                        [_otherArray2 replaceObjectAtIndex:i withObject:object2];
//                        object2 = nil;
                        
                        NSMutableString	 *tempString = [[NSMutableString alloc] init];
                        [tempString setString:[_otherArray2 objectAtIndex:j]];
                        [_otherArray2 replaceObjectAtIndex:j withObject:[_otherArray2 objectAtIndex:i]];
                        [_otherArray2 replaceObjectAtIndex:i withObject:tempString];
                        [tempString release]; tempString = nil;
                    }
                    
                    if (_otherArray3 != nil) {
                        NSMutableString	 *tempString = [[NSMutableString alloc] init];
                        [tempString setString:[_otherArray3 objectAtIndex:j]];
                        [_otherArray3 replaceObjectAtIndex:j withObject:[_otherArray3 objectAtIndex:i]];
                        [_otherArray3 replaceObjectAtIndex:i withObject:tempString];
                        [tempString release]; tempString = nil;
                    }
                    
                    if (_otherArray4 != nil) {
                        NSMutableString	 *tempString = [[NSMutableString alloc] init];
                        [tempString setString:[_otherArray4 objectAtIndex:j]];
                        [_otherArray4 replaceObjectAtIndex:j withObject:[_otherArray4 objectAtIndex:i]];
                        [_otherArray4 replaceObjectAtIndex:i withObject:tempString];
                        [tempString release]; tempString = nil;
                    }
                }
            }
        }
    }
    
}

+ (void)arrangeCards:(NSMutableArray *)_array withOtherArray1:(NSMutableArray *)_otherArray1 withOtherArray2:(NSMutableArray *)_otherArray2 {
    for (int i=0; i<[_array count]; i++) {
		for (int j=i+1; j<[_array count]; j++) {
			NSString  *last = [_array objectAtIndex:i];
			NSString  *next = [_array objectAtIndex:j];
			
			if ([last doubleValue] < [next doubleValue]) {
				NSMutableString	 *tempString = [[NSMutableString alloc] init];
                [tempString setString:[_array objectAtIndex:j]];
				[_array replaceObjectAtIndex:j withObject:[_array objectAtIndex:i]];
				[_array replaceObjectAtIndex:i withObject:tempString];
				[tempString release]; tempString = nil;
                
                if (_otherArray1 != nil) {
//                    id object1;
//                    object1 = [_otherArray1 objectAtIndex:j];
//                    [_otherArray1 replaceObjectAtIndex:j withObject:[_otherArray1 objectAtIndex:i]];
//                    [_otherArray1 replaceObjectAtIndex:i withObject:object1];
//                    object1 = nil;
                    
                    NSMutableString	 *tempString = [[NSMutableString alloc] init];
                    [tempString setString:[_otherArray1 objectAtIndex:j]];
                    [_otherArray1 replaceObjectAtIndex:j withObject:[_otherArray1 objectAtIndex:i]];
                    [_otherArray1 replaceObjectAtIndex:i withObject:tempString];
                    [tempString release]; tempString = nil;
                }
                if (_otherArray2 != nil) {
//                    id object2;
//                    object2 = [_otherArray2 objectAtIndex:j];
//                    [_otherArray2 replaceObjectAtIndex:j withObject:[_otherArray2 objectAtIndex:i]];
//                    [_otherArray2 replaceObjectAtIndex:i withObject:object2];
//                    object2 = nil;
                    
                    NSMutableString	 *tempString = [[NSMutableString alloc] init];
                    [tempString setString:[_otherArray2 objectAtIndex:j]];
                    [_otherArray2 replaceObjectAtIndex:j withObject:[_otherArray2 objectAtIndex:i]];
                    [_otherArray2 replaceObjectAtIndex:i withObject:tempString];
                    [tempString release]; tempString = nil;
                }
			}
		}
	}
    
    for (int i = 0; i < [_array count]; i++) {
        for (int j=i+1; j<[_array count]; j++) {
            NSString  *last = [_array objectAtIndex:i];
			NSString  *next = [_array objectAtIndex:j];
            if ([last doubleValue] == [next doubleValue]) {
                if ([last doubleValue] * [[_otherArray2 objectAtIndex:i] doubleValue] > [next doubleValue] * [[_otherArray2 objectAtIndex:j] doubleValue]) {
                    NSMutableString	 *tempString = [[NSMutableString alloc] init];
                    [tempString setString:[_array objectAtIndex:j]];
                    [_array replaceObjectAtIndex:j withObject:[_array objectAtIndex:i]];
                    [_array replaceObjectAtIndex:i withObject:tempString];
                    [tempString release]; tempString = nil;
                    
                    if (_otherArray1 != nil) {
//                        id object1;
//                        object1 = [_otherArray1 objectAtIndex:j];
//                        [_otherArray1 replaceObjectAtIndex:j withObject:[_otherArray1 objectAtIndex:i]];
//                        [_otherArray1 replaceObjectAtIndex:i withObject:object1];
//                        object1 = nil;
                        
                        NSMutableString	 *tempString = [[NSMutableString alloc] init];
                        [tempString setString:[_otherArray1 objectAtIndex:j]];
                        [_otherArray1 replaceObjectAtIndex:j withObject:[_otherArray1 objectAtIndex:i]];
                        [_otherArray1 replaceObjectAtIndex:i withObject:tempString];
                        [tempString release]; tempString = nil;
                    }
                    if (_otherArray2 != nil) {
//                        id object2;
//                        object2 = [_otherArray2 objectAtIndex:j];
//                        [_otherArray2 replaceObjectAtIndex:j withObject:[_otherArray2 objectAtIndex:i]];
//                        [_otherArray2 replaceObjectAtIndex:i withObject:object2];
//                        object2 = nil;
                        
                        NSMutableString	 *tempString = [[NSMutableString alloc] init];
                        [tempString setString:[_otherArray2 objectAtIndex:j]];
                        [_otherArray2 replaceObjectAtIndex:j withObject:[_otherArray2 objectAtIndex:i]];
                        [_otherArray2 replaceObjectAtIndex:i withObject:tempString];
                        [tempString release]; tempString = nil;
                    }
                }
            } else {
                break;
            }
        }
    }
}

+ (int)MathCombinationWithNoSameNumber:(NSMutableArray *)_array {
    int totalCount = 1;
    int deleteCount = 0;
    BOOL isHaveSameNumaber = NO;
    for (int i = 0; i < [_array count]; i++) {
        totalCount *= [(NSArray *)[_array objectAtIndex:i] count];
    }
    for (int i = 0; i < [_array count]; i++) {
        for (int y = 1; y < [_array count]; y++) {
            if (i + y < [_array count]) {
                for (int j = 0; j < [(NSArray *)[_array objectAtIndex:i] count]; j++) {
                    int same = 1;
                    isHaveSameNumaber = NO;
                    for (NSInteger k = 0; k < [(NSArray *)[_array objectAtIndex:y+i] count]; k++) {
                        if ([[[_array objectAtIndex:i] objectAtIndex:j] isEqualToString:[[_array objectAtIndex:y+i] objectAtIndex:k]]) {
                            for (int z = 0; z < [_array count]; z++) {
                                if (z != i && z != (y+i)) {
                                    same *= [(NSArray *)[_array objectAtIndex:z] count];
                                }
                            }
                            isHaveSameNumaber = YES;
                            k = [(NSArray *)[_array objectAtIndex:y+i] count];
                        }
                    }
                    if (isHaveSameNumaber) {
                        deleteCount += same;
                    }
                }
            }
        }
    }
    
    int mathSameCount = 0;
    BOOL isHaveSame = NO;
    BOOL isSingleSame = NO;
    for (int i = 0; i < [(NSArray *)[_array objectAtIndex:0] count]; i++) {
        for (NSInteger j = 1; j < [_array count]; j++) {
            isSingleSame = NO;
            if ([(NSArray *)[_array objectAtIndex:j] count] > 0) {
                for (NSInteger k = 0; k < [(NSArray *)[_array objectAtIndex:j] count]; k++) {
                    if ([[[_array objectAtIndex:0] objectAtIndex:i] isEqualToString:[[_array objectAtIndex:j] objectAtIndex:k]]) {
                        k = [(NSArray *)[_array objectAtIndex:j] count];
                        isSingleSame = YES;
                    }
                    if (isSingleSame) {
                        isHaveSame = YES;
                    } else {
                        isHaveSame = NO;
                    }
                }
                if (!isHaveSame) {
                    j = [_array count];
                }
            } else {
                isHaveSame = NO;
            }
        }
        if (isHaveSame) {
            mathSameCount++;
        }
    }
    return totalCount - deleteCount + (mathSameCount*((int)[MathFunction MathCombination:[_array count] :2] - 1));
}
@end
