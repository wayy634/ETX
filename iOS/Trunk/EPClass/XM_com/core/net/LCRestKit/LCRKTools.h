//
//  LCRKTools.h
//  LCRestKit
//
//  Created by HXG on 9/15/14.
//  Copyright (c) 2014 LeCai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCRKValueTransformer.h"

Class LCRKKeyValueCodingClassForObjCType(const char *type);
Class LCRKKeyValueCodingClassFromPropertyAttributes(const char *attr);

NSDictionary *LCRKFilteredKeyWithPrefixStringInDictionary(NSString *prefix, NSDictionary *aDict);

id LCRKTransformValue(id obj, Class targetClass, id<LCRKValueTransformer> valueTransformer, NSDictionary *keyMapping, NSString *propertyName);

id LCRKCreateCollection(Class aClass);

BOOL LCRKIsCollection(Class aClass);
//BOOL LCRKIsBasicClass(Class aClass);