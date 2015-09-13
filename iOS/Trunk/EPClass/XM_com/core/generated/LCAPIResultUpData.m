//
//  LCAPIResultUpData.m
//  LeCai
//
//  Created by lehecaiminib on 13-10-21.
//
//

#import "LCAPIResultUpData.h"

@implementation LCAPIResultUpData
@synthesize policy,newVersion,updateLog,downloadUrl;
- (void)dealloc {
    [newVersion release] , newVersion = nil;
    [updateLog release] , updateLog = nil;
    [downloadUrl release] , downloadUrl = nil;
    [super dealloc];
}

- (NSMutableString *)newVersion {
    if (newVersion == nil || [newVersion isEqualToString:@"null"]) {
        newVersion = [[NSMutableString alloc] initWithString:@""];
    }
    return newVersion;
}

- (NSMutableString *)updateLog {
    if (updateLog == nil || [updateLog isEqualToString:@"null"]) {
        updateLog = [[NSMutableString alloc] initWithString:@""];
    }
    return updateLog;
}

- (NSMutableString *)downloadUrl {
    if (downloadUrl == nil || [downloadUrl isEqualToString:@"null"]) {
        downloadUrl = [[NSMutableString alloc] initWithString:@""];
    }
    return downloadUrl;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.policy = [decoder decodeIntForKey:@"policy"];
    self.newVersion = [decoder decodeObjectForKey:@"newVersion"];
    self.updateLog = [decoder decodeObjectForKey:@"updateLog"];
    self.downloadUrl = [decoder decodeObjectForKey:@"downloadUrl"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.policy forKey:@"policy"];
    [encoder encodeObject:self.newVersion forKey:@"newVersion"];
    [encoder encodeObject:self.updateLog forKey:@"updateLog"];
    [encoder encodeObject:self.downloadUrl forKey:@"downloadUrl"];
}
@end
