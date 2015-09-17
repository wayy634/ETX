//
//  UserCar.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/15.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "UserCar.h"


//addtime: 1441849831,
//boughttime: "2015年9月12日",
//brand: "一汽大众迈腾",
//dataid: 1,
//engineid: "246467K",
//licenceid: "340104198704141510",
//licencename: "杨海",
//lpn: "京P-S3551",
//uid: 1


@implementation UserCar

@synthesize addtime,boughttime,brand,dataid,engineid,licenceid,licencename,lpn,uid;

- (void)dealloc {
    [boughttime release], boughttime = nil;
    [brand release], brand = nil;
    [engineid release], engineid = nil;
    [licenceid release], licenceid = nil;
    [licencename release], licencename = nil;
    [lpn release],lpn = nil;
    [super dealloc];
}

- (NSMutableString *)boughttime {
    if (boughttime == nil || [boughttime isEqualToString:@"null"]) {
        boughttime = [[NSMutableString alloc] initWithString:@""];
    }
    return boughttime;
}

- (NSMutableString *)brand {
    if (brand == nil || [brand isEqualToString:@"null"]) {
        brand = [[NSMutableString alloc] initWithString:@""];
    }
    return brand;
}

- (NSMutableString *)engineid {
    if (engineid == nil || [engineid isEqualToString:@"null"]) {
        engineid = [[NSMutableString alloc] initWithString:@""];
    }
    return engineid;
}

- (NSMutableString *)licenceid {
    if (licenceid == nil || [licenceid isEqualToString:@"null"]) {
        licenceid = [[NSMutableString alloc] initWithString:@""];
    }
    return licenceid;
}

- (NSMutableString *)licencename {
    if (licencename == nil || [licencename isEqualToString:@"null"]) {
        licencename = [[NSMutableString alloc] initWithString:@""];
    }
    return licencename;
}

- (NSMutableString *)lpn {
    if (lpn == nil || [lpn isEqualToString:@"null"]) {
        lpn = [[NSMutableString alloc] initWithString:@""];
    }
    return lpn;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.addtime = (long)[decoder decodeInt64ForKey:@"addtime"];
    self.boughttime = [decoder decodeObjectForKey:@"boughttime"];
    self.brand = [decoder decodeObjectForKey:@"brand"];
    self.dataid = (long)[decoder decodeInt64ForKey:@"dataid"];
    self.engineid = [decoder decodeObjectForKey:@"engineid"];
    self.licencename = [decoder decodeObjectForKey:@"licencename"];
    self.lpn = [decoder decodeObjectForKey:@"lpn"];
    self.uid = (long)[decoder decodeInt64ForKey:@"uid"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeInt64:self.addtime forKey:@"addtime"];
    [encoder encodeObject:self.boughttime forKey:@"boughttime"];
    [encoder encodeObject:self.brand forKey:@"brand"];
    [encoder encodeInt64:self.dataid forKey:@"dataid"];
    [encoder encodeObject:self.engineid forKey:@"engineid"];
    [encoder encodeObject:self.licencename forKey:@"licencename"];
    [encoder encodeObject:self.lpn forKey:@"lpn"];
    [encoder encodeInt64:self.uid forKey:@"uid"];
}

@end
