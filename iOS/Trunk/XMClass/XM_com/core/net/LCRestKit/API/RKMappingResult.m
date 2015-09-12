//
//  RKMappingResult.m
//  LeCai
//
//  Created by HXG on 9/24/14.
//
//

#import "RKMappingResult.h"

@implementation RKMappingResult

- (instancetype)initWithFirstObject:(id)aObject
{
    self = [super init];
    if (self) {
        self.firstObject = aObject;
    }
    return self;
}

+ (instancetype)resultWithFirstObject:(id)aObject
{
    return [[[[self class] alloc] initWithFirstObject:aObject] autorelease];
}

- (void)dealloc
{
    self.firstObject = nil;
    [super dealloc];
}

@end
