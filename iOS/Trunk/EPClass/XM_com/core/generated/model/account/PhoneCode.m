//
//  phoneCode.m
//  EPASS-APP-iOS
//
//  Created by zhanghan on 15/9/18.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "PhoneCode.h"
@implementation PhoneCode
@synthesize checkcode;
- (void)dealloc {
    [checkcode release],checkcode = nil;
    [super dealloc];
}

- (NSMutableString *)checkcode {
    if (checkcode == nil || [checkcode isEqualToString:@"null"]) {
        checkcode = [[NSMutableString alloc] initWithString:@""];
    }
    return checkcode;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.checkcode = [decoder decodeObjectForKey:@"checkcode"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.checkcode forKey:@"checkcode"];
}

@end
