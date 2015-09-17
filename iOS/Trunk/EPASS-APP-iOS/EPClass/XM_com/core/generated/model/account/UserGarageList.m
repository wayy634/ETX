//
//  UserGarageList.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "UserGarageList.h"

@implementation UserGarageList

@synthesize userGarageList;

- (void)dealloc {
    [userGarageList release] , userGarageList = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.userGarageList = [decoder decodeObjectForKey:@"userGarageList"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userGarageList forKey:@"userGarageList"];
}

@end
