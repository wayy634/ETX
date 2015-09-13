//
//  LCAnalysisManager.m
//  LeCai
//
//  Created by WangHui on 1/4/15.
//
//

#import "LCAnalysisManager.h"
#import "MobClick.h"
@implementation LCAnalysisManager

+ (void)event:(NSString *)eventId
{
    [MobClick event:eventId];
    NSLog(@"----------统计事件：%@", eventId);
}

+ (void)event:(NSString *)eventId label:(NSString *)label
{
    [MobClick event:eventId label:label];
    NSLog(@"----------统计事件：%@ ---标签：%@", eventId, label);
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)counter
{
    [MobClick event:eventId attributes:attributes counter:counter];
    NSLog(@"==================计算事件：%@ ===属性：%@ ===数量：%d", eventId, [self attributesDesc:attributes], counter);
}

+ (NSString *)attributesDesc:(NSDictionary *)attributes
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    if ([attributes count] > 0) {
        [attributes enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            [tmpArray addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }];
    }
    return [NSString stringWithFormat:@"(%@)", [tmpArray componentsJoinedByString:@" | "]];
}



@end
