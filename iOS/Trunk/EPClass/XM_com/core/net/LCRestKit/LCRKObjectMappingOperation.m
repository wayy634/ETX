//
//  LCRKObjectMappingOperation.m
//  LCRestKit
//
//  Created by HXG on 9/17/14.
//  Copyright (c) 2014 LeCai. All rights reserved.
//

#import "LCRKObjectMappingOperation.h"
#import "NSObject+LCRKAddition.h"
#import "LCRKTools.h"

NSString * const LCRKParseException = @"LCRKParseException";

@interface LCRKObjectMappingOperation ()

@property (nonatomic, strong) LCRKMappingResultBlock resultBlock;
@property (nonatomic, strong) id originValue;
@property (nonatomic, strong) id mappingConfiguration;
@property (nonatomic, strong) NSDictionary *extendConfiguration;
@property (nonatomic, assign) LCRKParseRule parseRule;
@property (nonatomic, assign) BOOL originIsString;

@end

@implementation LCRKObjectMappingOperation

+ (NSOperationQueue *)sharedObjectMappingOperation
{
    static NSOperationQueue *_sharedObjectMappingOperationQueue = nil;
    
    static dispatch_once_t _sharedObjectMappingQueue;
    dispatch_once(&_sharedObjectMappingQueue, ^{
        _sharedObjectMappingOperationQueue = [[NSOperationQueue alloc] init];
    });
    
    return _sharedObjectMappingOperationQueue;
}

- (void)main
{
    if (self.originValue) {
        if (self.originIsString) {
            if ([self.originValue isKindOfClass:[NSString class]]) {
                if (self.parseRule == LCRKParseRuleJSON) {
                    NSError *aError = nil;
                    id parsedResult = [NSJSONSerialization JSONObjectWithData:[self.originValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&aError];
                    [self mappingObject:parsedResult withConfiguration:self.mappingConfiguration];
                } else {
                    [NSException raise:LCRKParseException format:@"not supported rule: %@", [self descriptionForParseRule:self.parseRule]];
                }
            } else {
                [NSException raise:LCRKParseException format:@"Parsed origin value not NSString with method startObjectMappingFromString:parseRule:withConfiguration:resultBlock:"];
            }
        } else {
            [self mappingObject:self.originValue withConfiguration:self.mappingConfiguration];
        }
    } else {
        [self generateResult:nil success:YES];
    }
}

- (NSString *)descriptionForParseRule:(LCRKParseRule)parseRule
{
    NSString *rDescription = nil;
    switch (parseRule) {
        case LCRKParseRuleXML:
            rDescription = @"XML";
            break;
        case LCRKParseRuleJSON:
            rDescription = @"JSON";
            break;
        case LCRKParseRuleNone:
            rDescription = @"Unknown";
            break;
        default:
            break;
    }
    
    return rDescription;
}

- (void)mappingObject:(id)originObject withConfiguration:(id)configuration
{
    
    __weak LCRKObjectMappingOperation *weakSelf = self;
    
    if ([originObject isKindOfClass:[NSDictionary class]]) {
        
        if ([configuration isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
            
            [originObject enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                Class aClass = [configuration objectForKey:key];
                id aObject = nil;
                if (aClass) {
                    aObject = [aClass lcrkMappedObjectWithDictionary:obj extendMappingConfiguration:LCRKFilteredKeyWithPrefixStringInDictionary(key, weakSelf.extendConfiguration)];
                    if (!aObject) {
                        aObject = obj;
                    }
                    [resultDict setObject:aObject forKey:key];
                }
            }];
            
            if ([resultDict count] > 0) {
                [self generateResult:resultDict success:YES];
            } else {
                [self generateResult:nil success:YES];
            }
        } else {
            if (configuration) {
                id aObject = [(Class)configuration lcrkMappedObjectWithDictionary:originObject extendMappingConfiguration:self.extendConfiguration];
                [self generateResult:aObject success:YES];
            } else {
                [self generateResult:nil success:NO];
            }
        }
    } else if ([originObject isKindOfClass:[NSArray class]] && [configuration isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *resultArray = [NSMutableArray array];
        
        NSInteger configAmount = [(NSArray *)configuration count];
        
        [originObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx < configAmount && idx > 0) {
                Class aClass = configuration[idx];
                id aObject = [aClass lcrkMappedObjectWithDictionary:originObject[idx] extendMappingConfiguration:weakSelf.extendConfiguration];
                if (!aObject) {
                    aObject = obj;
                }
                [resultArray addObject:aObject];
            } else {
                *stop = YES;
            }
        }];
        
        if ([resultArray count] > 0) {
            [self generateResult:resultArray success:YES];
        } else {
            [self generateResult:nil success:YES];
        }
        
    } else {
        [NSException raise:LCRKParseException format:@"Mapped object and configuration are not fulfilled basic requirement."];
    }
}

- (void)generateResult:(id)mappingResult success:(BOOL)success
{
    if (self.resultBlock) {
        self.resultBlock(success, mappingResult);
    }
}

- (void)dealloc
{
    self.resultBlock = nil;
    self.originValue = nil;
    self.mappingConfiguration = nil;
    self.extendConfiguration  = nil;
}

+ (void)startObjectMappingFromArray:(NSArray *)originValue
                  withConfiguration:(NSArray *)mappingConfiguration
                extendConfiguration:(NSDictionary *)extendConfiguration
                        resultBlock:(LCRKMappingResultBlock)resultBlock
{
    LCRKObjectMappingOperation *objectMappingOperation = [[LCRKObjectMappingOperation alloc] init];
    objectMappingOperation.resultBlock = resultBlock;
    objectMappingOperation.mappingConfiguration = mappingConfiguration;
    objectMappingOperation.extendConfiguration = extendConfiguration;
    objectMappingOperation.originValue = originValue;
    [[self sharedObjectMappingOperation] addOperation:objectMappingOperation];
}


+ (void)startObjectMappingFromDictionary:(NSDictionary *)originValue
                       withConfiguration:(id)mappingConfiguration
                     extendConfiguration:(NSDictionary *)extendConfiguration
                             resultBlock:(LCRKMappingResultBlock)resultBlock
{
    LCRKObjectMappingOperation *objectMappingOperation = [[LCRKObjectMappingOperation alloc] init];
    objectMappingOperation.resultBlock = resultBlock;
    objectMappingOperation.mappingConfiguration = mappingConfiguration;
    objectMappingOperation.originValue = originValue;
    objectMappingOperation.extendConfiguration = extendConfiguration;
    [[self sharedObjectMappingOperation] addOperation:objectMappingOperation];
}


+ (void)startObjectMappingFromString:(NSString *)originValue
                           parseRule:(LCRKParseRule)parseRule
                   withConfiguration:(id)mappingConfiguration
                 extendConfiguration:(NSDictionary *)extendConfiguration
                         resultBlock:(LCRKMappingResultBlock)resultBlock
{
    LCRKObjectMappingOperation *objectMappingOperation = [[LCRKObjectMappingOperation alloc] init];
    objectMappingOperation.resultBlock = resultBlock;
    objectMappingOperation.mappingConfiguration = mappingConfiguration;
    objectMappingOperation.originValue = originValue;
    objectMappingOperation.originIsString = YES;
    objectMappingOperation.extendConfiguration = extendConfiguration;
    [[self sharedObjectMappingOperation] addOperation:objectMappingOperation];
}


@end
