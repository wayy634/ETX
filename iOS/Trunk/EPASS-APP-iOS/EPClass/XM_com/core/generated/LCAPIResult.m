//
//  LCAPIResult.m
//  LeCai
//
//  Created by lehecaiminib on 13-9-16.
//
//

#import "LCAPIResult.h"

@implementation LCAPIResult

@synthesize serverTime,msg,code,data,success,token;
- (void)dealloc {
    
    [serverTime release] , serverTime = nil;
    [data release] , data = nil;
    [msg release] , msg = nil;
    [token release] , token = nil;
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

- (NSMutableString *)token {
    if (token == nil) {
        token = [[NSMutableString alloc] initWithString:@""];
    } else if ([token isEqualToString:@"null"]) {
        [token setString:@""];
    } else {
        return token;
    }
    return nil;
}

- (NSMutableString *)msg {
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
    
    self.code = (long)[decoder decodeInt64ForKey:@"code"];
    self.serverTime = [decoder decodeObjectForKey:@"serverTime"];
    self.data = [decoder decodeObjectForKey:@"data"];
    self.msg = [decoder decodeObjectForKey:@"msg"];
    self.success = [decoder decodeBoolForKey:@"success"];
    self.token = [decoder decodeObjectForKey:@"token"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {

    [encoder encodeInt64:self.code forKey:@"code"];
    [encoder encodeObject:self.serverTime forKey:@"serverTime"];
    [encoder encodeObject:self.msg forKey:@"msg"];
    [encoder encodeObject:self.data forKey:@"data"];
    [encoder encodeBool:self.success forKey:@"success"];
    [encoder encodeObject:self.token forKey:@"token"];
}
@end
