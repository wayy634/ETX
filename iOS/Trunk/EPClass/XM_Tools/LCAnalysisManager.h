//
//  LCAnalysisManager.h
//  LeCai
//
//  Created by WangHui on 1/4/15.
//
//

#import <Foundation/Foundation.h>

@interface LCAnalysisManager : NSObject

+ (void)event:(NSString *)eventId;
+ (void)event:(NSString *)eventId label:(NSString *)label;

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)counter;
@end
