//
//  LCRKTools.m
//  LCRestKit
//
//  Created by HXG on 9/15/14.
//  Copyright (c) 2014 LeCai. All rights reserved.
//

#import "LCRKTools.h"
#import <objc/runtime.h>

#import "NSObject+LCRKAddition.h"
#import "LCRKDictionaryValueTransformer.h"

Class LCRKKeyValueCodingClassForObjCType(const char *type)
{
    if (type) {
        switch (type[0]) {
            case _C_ID: {
                char *openingQuoteLoc = strchr(type, '"');
                if (openingQuoteLoc) {
                    char *closingQuoteLoc = strchr(openingQuoteLoc+1, '"');
                    if (closingQuoteLoc) {
                        size_t classNameStrLen = closingQuoteLoc-openingQuoteLoc;
                        char className[classNameStrLen];
                        memcpy(className, openingQuoteLoc+1, classNameStrLen-1);
                        // Null-terminate the array to stringify
                        className[classNameStrLen-1] = '\0';
                        return objc_getClass(className);
                    }
                }
                // If there is no quoted class type (id), it can be used as-is.
                return nil;
            }
                
            case _C_CHR: // char
            case _C_UCHR: // unsigned char
            case _C_SHT: // short
            case _C_USHT: // unsigned short
            case _C_INT: // int
            case _C_UINT: // unsigned int
            case _C_LNG: // long
            case _C_ULNG: // unsigned long
            case _C_LNG_LNG: // long long
            case _C_ULNG_LNG: // unsigned long long
            case _C_FLT: // float
            case _C_DBL: // double
                return [NSNumber class];
                
            case _C_BOOL: // C++ bool or C99 _Bool
                return objc_getClass("NSCFBoolean")
                ?: objc_getClass("__NSCFBoolean")
                ?: [NSNumber class];
                
            case _C_STRUCT_B: // struct
            case _C_BFLD: // bitfield
            case _C_UNION_B: // union
                return [NSValue class];
                
            case _C_ARY_B: // c array
            case _C_PTR: // pointer
            case _C_VOID: // void
            case _C_CHARPTR: // char *
            case _C_CLASS: // Class
            case _C_SEL: // selector
            case _C_UNDEF: // unknown type (function pointer, etc)
            default:
                break;
        }
    }
    return nil;
}

Class LCRKKeyValueCodingClassFromPropertyAttributes(const char *attr)
{
    if (attr) {
        const char *typeIdentifierLoc = strchr(attr, 'T');
        if (typeIdentifierLoc) {
            return LCRKKeyValueCodingClassForObjCType(typeIdentifierLoc+1);
        }
    }
    return nil;
}

NSDictionary *LCRKFilteredKeyWithPrefixStringInDictionary(NSString *prefix, NSDictionary *aDict)
{
    if (aDict && [aDict count] > 0 && prefix.length > 0) {
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        NSString *prefixKey = [NSString stringWithFormat:@"%@.", prefix];
        [aDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if ([key hasPrefix:prefixKey]) {
                NSString *newKey = [key stringByReplacingCharactersInRange:[key rangeOfString:prefixKey] withString:@""];
                if (newKey.length > 0) {
                    [resultDict setObject:obj forKey:newKey];
                }
            }
        }];
        
        if ([resultDict count] > 0) {
            return resultDict;
        }
    }
    return nil;
}

id LCRKTransformValue(id obj, Class targetClass, id<LCRKValueTransformer> valueTransformer, NSDictionary *keyMapping, NSString *propertyName)
{
    if (!targetClass || !obj) {
        return nil;
    }
    
    id finalValue = nil;
    
    if (valueTransformer) {
        finalValue = [valueTransformer transformTargetValueFromOrigin:obj];
    } else {
        
        if (LCRKIsCollection(targetClass)) {
            
            if ([obj isKindOfClass:[NSArray class]] && [(NSArray *)obj count] > 0) {
                
                Class aClass = keyMapping[propertyName];
                id finalCollection = LCRKCreateCollection(targetClass);
                NSDictionary *tmpKeyMapping = LCRKFilteredKeyWithPrefixStringInDictionary(propertyName, keyMapping);

                [obj enumerateObjectsUsingBlock:^(id innerObj, NSUInteger idx, BOOL *innerStop) {
                    if ([innerObj isKindOfClass:[NSDictionary class]]) {
                        if (aClass) {
                            [finalCollection addObject:[aClass lcrkMappedObjectWithDictionary:innerObj extendMappingConfiguration:tmpKeyMapping]];
                        } else {
                            LCRKDictionaryValueTransformer *dictTransformer = [[LCRKDictionaryValueTransformer alloc] init];
                            [dictTransformer setExtendMappingConfiguration:tmpKeyMapping];
                            id parsedObj = [dictTransformer transformTargetValueFromOrigin:innerObj];
                            if (parsedObj) {
                                [finalCollection addObject:parsedObj];
                            }
                        }
                    } else {
                        [finalCollection addObject:innerObj];
                    }
                }];
                
                if ([targetClass isSubclassOfClass:[NSOrderedSet class]]) {
                    finalValue = [NSOrderedSet orderedSetWithArray:finalCollection];
                } else {
                    finalValue = finalCollection;
                }
            }

        } else if ([targetClass isSubclassOfClass:[NSDictionary class]]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                LCRKDictionaryValueTransformer *dictTransformer = [[LCRKDictionaryValueTransformer alloc] init];
                dictTransformer.extendMappingConfiguration = LCRKFilteredKeyWithPrefixStringInDictionary(propertyName, keyMapping);
                finalValue = [dictTransformer transformTargetValueFromOrigin:obj];
            }
        } else if ([obj isKindOfClass:targetClass]) {
            finalValue = obj;
        } else if ([obj isEqual:[NSNull null]]) {
            finalValue = nil;
        } else if ([targetClass isSubclassOfClass:[NSNumber class]]) {
            if ([obj isKindOfClass:[NSString class]]) {
                if ([obj isEqualToString:@"t"] || [obj isEqualToString:@"true"] || [obj isEqualToString:@"y"] || [obj isEqualToString:@"yes"]) {
                    finalValue = @YES;
                } else if ([obj isEqualToString:@"false"] || [obj isEqualToString:@"f"] || [obj isEqualToString:@"n"] || [obj isEqualToString:@"no"]) {
                    finalValue = @NO;
                } else {
                    if ([obj respondsToSelector:@selector(doubleValue)]) {
                        finalValue = [NSNumber numberWithDouble:[obj doubleValue]];
                    }
                }
            }
        } else if ([targetClass isSubclassOfClass:[NSDate class]]) {
            if ([obj isKindOfClass:[NSString class]] || [obj respondsToSelector:@selector(doubleValue)]) {
                finalValue = [NSDate dateWithTimeIntervalSince1970:[obj doubleValue]];
            }
        } else if ([targetClass isSubclassOfClass:[NSURL class]]) {
            if ([obj isKindOfClass:[NSString class]]) {
                finalValue = [NSURL URLWithString:obj];
            }
        } else if ([targetClass isSubclassOfClass:[NSString class]]) {
            if ([obj respondsToSelector:@selector(stringValue)]) {
                finalValue = [obj stringValue];
            } else {
                finalValue = [obj description];
            }
        } else if ([targetClass isSubclassOfClass:[NSValue class]] || [targetClass isSubclassOfClass:[UIImage class]] || [targetClass isSubclassOfClass:[NSData class]]) {
            /**
             *  not supported
             */
        } else {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                finalValue = [targetClass lcrkMappedObjectWithDictionary:obj
                                              extendMappingConfiguration:LCRKFilteredKeyWithPrefixStringInDictionary(propertyName, keyMapping)];
            }
        }
    }
    
    return finalValue;
}

id LCRKCreateCollection(Class aClass)
{
    if ([aClass isSubclassOfClass:[NSArray class]] || [aClass isSubclassOfClass:[NSOrderedSet class]]) {
        return [NSMutableArray array];
    } else if ([aClass isSubclassOfClass:[NSSet class]]) {
        return [NSMutableSet set];
    }
    
    return nil;
}

BOOL LCRKIsCollection(Class aClass)
{
    if ([aClass isSubclassOfClass:[NSArray class]] || [aClass isSubclassOfClass:[NSSet class]] || [aClass isSubclassOfClass:[NSOrderedSet class]]) {
        return YES;
    }
    return NO;
}

//BOOL LCRKIsBasicClass(Class aClass)
//{
//    NSArray *basicClasses = @[[NSString class], [NSNumber class], [NSValue class], [NSURL class], [NSData class], [NSArray class], [NSDictionary class]];
//    if ([basicClasses containsObject:aClass]) {
//        return YES;
//    }
//    return NO;
//}