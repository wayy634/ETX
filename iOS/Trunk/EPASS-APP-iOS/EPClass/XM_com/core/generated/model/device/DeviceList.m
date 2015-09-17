//
//  DeviceList.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "DeviceList.h"

@implementation DeviceList

@synthesize deviceList;

- (void)dealloc {
    [deviceList release] , deviceList = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.deviceList = [decoder decodeObjectForKey:@"deviceList"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.deviceList forKey:@"deviceList"];
}

@end
