//
//  UserCarsList.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "UserCarsList.h"

@implementation UserCarsList

@synthesize userCarList;

- (void)dealloc {
    [userCarList release] , userCarList = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.userCarList = [decoder decodeObjectForKey:@"userCarList"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userCarList forKey:@"userCarList"];
}

@end
