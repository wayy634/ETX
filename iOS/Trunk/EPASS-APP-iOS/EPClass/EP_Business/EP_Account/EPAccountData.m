//
//  EPAccountData.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/16.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPAccountData.h"

@implementation EPAccountData

@synthesize mUserToken;

- (NSMutableString *)mUserToken {
    if (mUserToken == nil || [mUserToken isEqualToString:@"null"]) {
        mUserToken = [[NSMutableString alloc] initWithString:@""];
    }
    return mUserToken;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.mUserToken = [decoder decodeObjectForKey:@"mUserToken"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.mUserToken forKey:@"mUserToken"];
}


- (void)dealloc {
    [mUserToken release] , mUserToken = nil;
    [super dealloc];
}

@end
