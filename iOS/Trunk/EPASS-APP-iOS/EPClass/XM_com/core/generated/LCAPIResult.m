//
//  LCAPIResult.m
//  LeCai
//
//  Created by lehecaiminib on 13-9-16.
//
//

#import "LCAPIResult.h"

@implementation LCAPIResult
//@synthesize whiteList,blackList,serverTime,serverTimeMillis,message,data,code,updateInfo;
@synthesize serverTime,msg,code,data;
- (void)dealloc {
//    [whiteList release] , whiteList = nil;
//    [blackList release] , blackList = nil;
    [serverTime release] , serverTime = nil;
//    [message release] , message = nil;
    [data release] , data = nil;
//    [updateInfo release] , updateInfo = nil;
    [msg release] , msg = nil;
    [super dealloc];
}

- (NSMutableString *)serverTime {
    if (serverTime == nil) {
        serverTime = [[NSMutableString alloc] initWithString:@""];
    } else if ([serverTime isEqualToString:@"null"]) {
        [serverTime setString:@""];
    } else {
        return serverTime;
    }
    return nil;
}

//- (double)serverTimeMillis {
//    if (serverTimeMillis == 0) {
//        NSDate *localTime = [NSDate date];
//        return (double)[localTime timeIntervalSince1970]*1000;
//    } else {
//        return serverTimeMillis;
//    }
//}

- (NSMutableString *)message {
    if (msg == nil) {
        msg = [[NSMutableString alloc] initWithString:@""];
    } else if ([msg isEqualToString:@"null"]) {
        [msg setString:@""];
    } else {
        return msg;
    }
    return nil;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
//    self.whiteList = [decoder decodeObjectForKey:@"whiteList"];
//    self.blackList = [decoder decodeObjectForKey:@"blackList"];
    self.code = (long)[decoder decodeInt64ForKey:@"code"];
    self.serverTime = [decoder decodeObjectForKey:@"serverTime"];
//    self.serverTimeMillis = [decoder decodeDoubleForKey:@"serverTimeMillis"];
//    self.message = [decoder decodeObjectForKey:@"message"];
    self.data = [decoder decodeObjectForKey:@"data"];
//    self.updateInfo = [decoder decodeObjectForKey:@"updateInfo"];
    self.msg = [decoder decodeObjectForKey:@"msg"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
//    [encoder encodeObject:self.whiteList forKey:@"whiteList"];
//    [encoder encodeObject:self.blackList forKey:@"blackList"];
    [encoder encodeInt64:self.code forKey:@"code"];
    [encoder encodeObject:self.serverTime forKey:@"serverTime"];
//    [encoder encodeDouble:self.serverTimeMillis forKey:@"serverTimeMillis"];
    [encoder encodeObject:self.msg forKey:@"msg"];
    [encoder encodeObject:self.data forKey:@"data"];
//    [encoder encodeObject:self.updateInfo forKey:@"updateInfo"];
}
@end
