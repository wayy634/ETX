//
//  LCAPIResultData.m
//  LeCai
//
//  Created by lehecaiminib on 13-9-16.
//
//

#import "LCAPIResultData.h"

@implementation LCAPIResultData
@synthesize modelList;
- (void)dealloc {
    [modelList release] , modelList = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.modelList = [decoder decodeObjectForKey:@"modelList"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.modelList forKey:@"modelList"];
}
@end
