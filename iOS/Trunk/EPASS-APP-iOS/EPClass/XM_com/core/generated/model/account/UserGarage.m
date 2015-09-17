//
//  UserGarage.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "UserGarage.h"

@implementation UserGarage

@synthesize addtime,area,dataid,estate,isrent,location,rentfee,type,uid;

- (void)dealloc {
    [estate release], estate = nil;
    [location release], location = nil;
    [rentfee release], rentfee = nil;
    [super dealloc];
}

- (NSMutableString *)estate {
    if (estate == nil || [estate isEqualToString:@"null"]) {
        estate = [[NSMutableString alloc] initWithString:@""];
    }
    return estate;
}

- (NSMutableString *)location {
    if (location == nil || [location isEqualToString:@"null"]) {
        location = [[NSMutableString alloc] initWithString:@""];
    }
    return location;
}

- (NSMutableString *)rentfee {
    if (rentfee == nil || [rentfee isEqualToString:@"null"]) {
        rentfee = [[NSMutableString alloc] initWithString:@""];
    }
    return rentfee;
}

//addtime: 1442284696,
//area: 1,
//dataid: 1,
//estate: "0435854",
//isrent: 1,
//location: "海淀",
//rentfee: "98RMB",
//type: 1,
//uid: 1


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.addtime = (long)[decoder decodeInt64ForKey:@"addtime"];
    self.area = (long)[decoder decodeInt64ForKey:@"area"];
    self.dataid = (long)[decoder decodeInt64ForKey:@"dataid"];
    self.isrent = [decoder decodeInt32ForKey:@"isrent"];
    self.estate = [decoder decodeObjectForKey:@"estate"];
    self.location = [decoder decodeObjectForKey:@"location"];
    self.rentfee = [decoder decodeObjectForKey:@"rentfee"];
    self.type = [decoder decodeInt32ForKey:@"type"];
    self.uid = (long)[decoder decodeInt64ForKey:@"uid"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeInt64:self.addtime forKey:@"addtime"];
    [encoder encodeInt64:self.area forKey:@"area"];
    [encoder encodeInt64:self.dataid forKey:@"dataid"];
    [encoder encodeInt32:self.isrent forKey:@"isrent"];
    [encoder encodeObject:self.estate forKey:@"estate"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.rentfee forKey:@"rentfee"];
    [encoder encodeInt32:self.type forKey:@"type"];
    [encoder encodeInt64:self.uid forKey:@"uid"];
}


@end
