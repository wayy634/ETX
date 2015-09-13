//
//  NSObject+LCRKAddition.m
//  LCRestKit
//
//  Created by HXG on 9/15/14.
//  Copyright (c) 2014 LeCai. All rights reserved.
//

#import "NSObject+LCRKAddition.h"
#import <objc/runtime.h>

#import "LCRKValueTransformer.h"
#import "LCRKTools.h"
#import "LCRKDictionaryValueTransformer.h"

NSString * const LCRKExtendMappingConfigurationKey = @"LCRKExtendMappingConfigurationKey";

@implementation NSObject (LCRKAddition)

#pragma mark - public
+ (instancetype)lcrkMappedObjectWithDictionary:(NSDictionary *)aDictionary
{
    return [self lcrkMappedObjectWithDictionary:aDictionary extendMappingConfiguration:nil];
}

+ (instancetype)lcrkMappedObjectWithDictionary:(NSDictionary *)aDictionary
                    extendMappingConfiguration:(NSDictionary *)configuration
{
    id mappedObject = nil;
    //字典不为nil则转换为对象
    if (aDictionary) {
        mappedObject = [[self class] new];
        [mappedObject setExtendMappingConfiguration:configuration];
        [mappedObject lcrkParseDatasInDictioary:aDictionary];
    }
    return mappedObject;
}

- (void)setExtendMappingConfiguration:(NSDictionary *)extendMappingConfiguration
{
    objc_setAssociatedObject(self, &LCRKExtendMappingConfigurationKey, extendMappingConfiguration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)extendMappingConfiguration
{
    return objc_getAssociatedObject(self, &LCRKExtendMappingConfigurationKey);
}

- (NSDictionary *)lcrkMappingConfiguration
{
    return nil;
}

- (NSDictionary *)lcrkCollectionClassMapping
{
    return nil;
}

- (NSDictionary *)lcrkValueTransformersMapping
{
    return nil;
}

#pragma mark - parse dictionary
- (void)lcrkParseDatasInDictioary:(NSDictionary *)aDictionary
{
    __weak id weakSelf = self;
    [aDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if (obj && ![obj isKindOfClass:[NSNull class]]) {
            NSString *propertyName = [weakSelf lcrkMappedPropertyNameForKey:key];
            if (propertyName.length > 0) {
                
                const char *proName = propertyName.UTF8String;
                objc_property_t aProperty = class_getProperty([weakSelf class], proName);
            
                if (aProperty) {
                    id<LCRKValueTransformer> transformer = [weakSelf lcrkValueTransformerForPropertyName:propertyName];
                    Class targetClass = LCRKKeyValueCodingClassFromPropertyAttributes(property_getAttributes(aProperty));
                    id finalValue = LCRKTransformValue(obj, targetClass, transformer, [self lcrkFinalCollectionClassMapping], propertyName);
                    if (finalValue) {
                        [weakSelf setValue:finalValue forKey:propertyName];
                    }
                }
            }
        }
    }];
}

#pragma mark - private
- (NSString *)lcrkMappedPropertyNameForKey:(NSString *)key
{
    NSString *propertyName = nil;
    if (key.length > 0) {
        propertyName = [self lcrkMappingConfiguration][key];
        if (!propertyName) {
            propertyName = key;
        }
    }
    return propertyName;
}

//- (Class)lcrkMappedCollectionClassForPropertName:(NSString *)propertyName
//{
//    if (propertyName.length > 0) {
//        Class aClass = [self lcrkCollectionClassMapping][propertyName];
//        if (aClass) {
//            return aClass;
//        }
//    }
//    
//    return nil;
//}

- (id<LCRKValueTransformer>)lcrkValueTransformerForPropertyName:(NSString *)propertyName
{
    if (propertyName.length > 0) {
        Class transformerClass = [self lcrkValueTransformersMapping][propertyName];
        if (transformerClass && [transformerClass conformsToProtocol:@protocol(LCRKValueTransformer)]) {
            return [[transformerClass alloc] init];
        }
    }
    
    return nil;
}

- (NSDictionary *)lcrkFinalCollectionClassMapping
{
    NSMutableDictionary *finalClassMapping = [NSMutableDictionary dictionary];
    
    [finalClassMapping addEntriesFromDictionary:[self lcrkCollectionClassMapping]];
    
    if ([self extendMappingConfiguration]) {
        [finalClassMapping addEntriesFromDictionary:[self extendMappingConfiguration]];
    }
    
    NSDictionary *arrayMapping = [[self class] LCRKCaculateArrayMapping];
    
    [arrayMapping enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![finalClassMapping objectForKey:key]) {
            finalClassMapping[key] = obj;
        }
    }];
    
    if ([finalClassMapping count] > 0) {
        return finalClassMapping;
    }
    
    return nil;
}

+ (NSDictionary *)LCRKCaculateArrayMapping
{
    NSMutableDictionary *resultMappingDict = [NSMutableDictionary dictionary];
    unsigned int propertiesAmount = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &propertiesAmount);
    
    if (propertiesAmount > 0) {
        for (int i = 0; i < propertiesAmount; i ++) {
            objc_property_t aProperty = properties[i];
            const char *propertyName = property_getName(aProperty);
            
            NSString *tmpPropertyName = [NSString stringWithUTF8String:propertyName];
            if (![resultMappingDict objectForKey:tmpPropertyName]) {
                Class targetClass = LCRKKeyValueCodingClassFromPropertyAttributes(property_getAttributes(aProperty));
                if (targetClass && (targetClass == [NSArray class] || targetClass == [NSMutableArray class])) {
                    objc_property_t flagProperty = class_getProperty([self class], [[NSString stringWithFormat:@"%sArray", propertyName] UTF8String]);
                    if (flagProperty) {
                        Class flagClass = LCRKKeyValueCodingClassFromPropertyAttributes(property_getAttributes(flagProperty));
                        if (flagClass) {
                            [resultMappingDict setObject:flagClass forKey:tmpPropertyName];
                        }
                    }
                }
            }
        }
    }
    
    if (properties != NULL) {
        free(properties);
    }
    
    if ([self superclass] != [NSObject class]) {
        NSDictionary *tmpDict = [[self superclass] LCRKCaculateArrayMapping];
        [tmpDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (![resultMappingDict objectForKey:key]) {
                [resultMappingDict setObject:obj forKey:key];
            }
        }];
    }
    return resultMappingDict;
}

@end
