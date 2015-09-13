//
//  LCRKDictionaryValueTransformer.m
//  LCRestKit
//
//  Created by HXG on 9/15/14.
//  Copyright (c) 2014 LeCai. All rights reserved.
//

#import "LCRKDictionaryValueTransformer.h"
#import "NSObject+LCRKAddition.h"
#import "LCRKTools.h"

@implementation LCRKDictionaryValueTransformer

- (id)transformTargetValueFromOrigin:(id)originValue
{
    if (originValue) {
        
        NSDictionary *extendConfiguration = [self extendMappingConfiguration];
        
        if ([extendConfiguration count] > 0) {
            NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
//            __weak LCRKDictionaryValueTransformer *weakSelf = self;
            [originValue enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                    Class keyClass = [extendConfiguration objectForKey:key];
                    if (keyClass) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            id finalValue = [keyClass lcrkMappedObjectWithDictionary:obj extendMappingConfiguration:LCRKFilteredKeyWithPrefixStringInDictionary(key, extendConfiguration)];
                            if (finalValue) {
                                [aDict setObject:finalValue forKey:key];
                            }
                        } else {
                            NSMutableArray *finalArray = [NSMutableArray array];
                            [obj enumerateObjectsUsingBlock:^(id innerObj, NSUInteger idx, BOOL *stop) {
                                if ([innerObj isKindOfClass:[NSDictionary class]]) {
                                    id finalValue = [keyClass lcrkMappedObjectWithDictionary:innerObj extendMappingConfiguration:LCRKFilteredKeyWithPrefixStringInDictionary(key, extendConfiguration)];
                                    if (finalValue) {
                                        [finalArray addObject:finalValue];
                                    }
                                }
                            }];
                            [aDict setObject:finalArray forKey:key];
                        }
                    } else {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            LCRKDictionaryValueTransformer *dictTransformer = [[LCRKDictionaryValueTransformer alloc] init];
                            dictTransformer.extendMappingConfiguration = LCRKFilteredKeyWithPrefixStringInDictionary(key, extendConfiguration);
                            id finalValue = [dictTransformer transformTargetValueFromOrigin:obj];
                            if (finalValue) {
                                [aDict setObject:finalValue forKey:key];
                            }
                        } else {
                            [aDict setObject:obj forKey:key];
                        }
                    }
                } else {
                    [aDict setObject:obj forKey:key];
                }
            }];
            
            return aDict;
        } else {
            return originValue;
        }
    }
    return nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
