//
//  Device.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "Device.h"

//addtime: 1441849902,
//bindtime: 1441849902,
//dataid: 1,
//deviceid: "0435854",
//isbind: 0,
//status: 0,
//uid: 1

@implementation Device

@synthesize addtime,bindtime,dataid,deviceid,isbind,status,uid;

- (void)dealloc {
    [deviceid release], deviceid = nil;
    [super dealloc];
}

- (NSMutableString *)deviceid {
    if (deviceid == nil || [deviceid isEqualToString:@"null"]) {
        deviceid = [[NSMutableString alloc] initWithString:@""];
    }
    return deviceid;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.addtime = (long)[decoder decodeInt64ForKey:@"addtime"];
    self.bindtime = (long)[decoder decodeInt64ForKey:@"bindtime"];
    self.deviceid = [decoder decodeObjectForKey:@"deviceid"];
    self.dataid = (long)[decoder decodeInt64ForKey:@"dataid"];
    self.isbind = [decoder decodeInt32ForKey:@"isbind"];
    self.status = [decoder decodeInt32ForKey:@"status"];
    self.uid = (long)[decoder decodeInt64ForKey:@"uid"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeInt64:self.addtime forKey:@"addtime"];
    [encoder encodeInt64:self.bindtime forKey:@"bindtime"];
    [encoder encodeObject:self.deviceid forKey:@"deviceid"];
    [encoder encodeInt64:self.dataid forKey:@"dataid"];
    [encoder encodeInt32:self.isbind forKey:@"isbind"];
    [encoder encodeInt32:self.status forKey:@"status"];
    [encoder encodeInt64:self.uid forKey:@"uid"];
}


@end
