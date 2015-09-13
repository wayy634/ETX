//
//  OrderAddress.m
//  XiaoMai
//
//  Created by Jeanne on 15/7/28.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "OrderAddress.h"

@implementation OrderAddress
@synthesize addresses,addressType;

- (void)dealloc {
    [addressType release] , addressType = nil;
    [addresses release] , addresses = nil;
    [super dealloc];
}

- (NSMutableString *)addressType {
    if (addressType == nil || [addressType isEqualToString:@"null"]) {
        addressType = [[NSMutableString alloc] initWithString:@""];
    }
    return addressType;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.addressType = [decoder decodeObjectForKey:@"addressType"];
    self.addresses = [decoder decodeObjectForKey:@"addresses"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.addressType forKey:@"addressType"];
    [encoder encodeObject:self.addresses forKey:@"addresses"];
}
@end
