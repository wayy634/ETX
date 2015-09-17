//
//  UserInfo.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize avatar,balance,etcdevice,dataid,isbind,mobile,nickname;

- (void)dealloc {
    [avatar release], avatar = nil;
    [balance release], balance = nil;
    [etcdevice release], etcdevice = nil;
    [mobile release], mobile = nil;
    [nickname release], nickname = nil;
    [super dealloc];
}

- (NSMutableString *)avatar {
    if (avatar == nil || [avatar isEqualToString:@"null"]) {
        avatar = [[NSMutableString alloc] initWithString:@""];
    }
    return avatar;
}

- (NSMutableString *)balance {
    if (balance == nil || [balance isEqualToString:@"null"]) {
        balance = [[NSMutableString alloc] initWithString:@""];
    }
    return balance;
}

- (NSMutableString *)etcdevice {
    if (etcdevice == nil || [etcdevice isEqualToString:@"null"]) {
        etcdevice = [[NSMutableString alloc] initWithString:@""];
    }
    return etcdevice;
}

- (NSMutableString *)mobile {
    if (mobile == nil || [mobile isEqualToString:@"null"]) {
        mobile = [[NSMutableString alloc] initWithString:@""];
    }
    return mobile;
}

- (NSMutableString *)nickname {
    if (nickname == nil || [nickname isEqualToString:@"null"]) {
        nickname = [[NSMutableString alloc] initWithString:@""];
    }
    return nickname;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.avatar = [decoder decodeObjectForKey:@"avatar"];
    self.balance = [decoder decodeObjectForKey:@"balance"];
    self.etcdevice = [decoder decodeObjectForKey:@"etcdevice"];
    self.dataid = (long)[decoder decodeInt64ForKey:@"dataid"];
    self.isbind = [decoder decodeBoolForKey:@"isbind"];
    self.mobile = [decoder decodeObjectForKey:@"mobile"];
    self.nickname = [decoder decodeObjectForKey:@"nickname"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.balance forKey:@"balance"];
    [encoder encodeObject:self.etcdevice forKey:@"etcdevice"];
    [encoder encodeInt64:self.dataid forKey:@"dataid"];
    [encoder encodeBool:self.isbind forKey:@"isbind"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
}


@end
