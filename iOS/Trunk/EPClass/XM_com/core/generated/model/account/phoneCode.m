//
//  phoneCode.m
//  EPASS-APP-iOS
//
//  Created by zhanghan on 15/9/18.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "phoneCode.h"
@implementation phoneCode
@synthesize verifyCode;
- (void)dealloc {
    [verifyCode release],verifyCode = nil;
    [super dealloc];
}

- (NSMutableString *)verifyCode {
    if (verifyCode == nil || [verifyCode isEqualToString:@"null"]) {
        verifyCode = [[NSMutableString alloc] initWithString:@""];
    }
    return verifyCode;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.verifyCode = [decoder decodeObjectForKey:@"verifyCode"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.verifyCode forKey:@"verifyCode"];
}

@end
