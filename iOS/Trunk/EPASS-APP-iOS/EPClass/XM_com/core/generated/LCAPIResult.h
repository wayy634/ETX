//
//  LCAPIResult.h
//  LeCai
//
//  Created by lehecaiminib on 13-9-16.
//
//

#import <Foundation/Foundation.h>
#import "LCAPIResultData.h"
#import "LCAPIResultUpData.h"

@interface LCAPIResult : NSObject <NSCoding>
@property(nonatomic,strong)NSMutableString     *serverTime;
@property(nonatomic,strong)NSMutableString     *msg;
@property(nonatomic,assign)long                code;
@property(nonatomic,strong)LCAPIResultData     *data;
@property(nonatomic,assign)BOOL                success;
@property(nonatomic,strong)NSMutableString     *token;

@end
