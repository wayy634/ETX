//
//  NSObject+LCRKAddition.h
//  LCRestKit
//
//  Created by HXG on 9/15/14.
//  Copyright (c) 2014 LeCai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (LCRKAddition)

@property (nonatomic, strong) NSDictionary *extendMappingConfiguration;

/**
 *  通过字典中的数据自动生成对象
 *
 *  @param aDictionary 字典数据
 *
 *  @return 实例化后的对象
 */
//+ (instancetype)lcrkMappedObjectWithDictionary:(NSDictionary *)aDictionary;
+ (instancetype)lcrkMappedObjectWithDictionary:(NSDictionary *)aDictionary
                    extendMappingConfiguration:(NSDictionary *)configuration;

//- (void)lcrkParseDatasInDictioary:(NSDictionary *)aDictionary;


/**
 *  JSON key和对象属性之间的对应关系，如果JSON key中的值和属性的名字完全相同则无需配置
 *
 *  @return 配置表
 */
- (NSDictionary *)lcrkMappingConfiguration;

/**
 *  当对象中属性的类为集合类的时候，比如Array，Set的时候，定义集合中单个对象的类
 *
 *  @return 对象属性名字和类名对应的配置表
 */
- (NSDictionary *)lcrkCollectionClassMapping;

/**
 *  对一些特殊的数据进行自定义的处理方式，比如将double类型的数据转换为NSDate
 *
 *  @return 对象属性名字和实现LCRKValueTransformer的类名对应的配置表
 */
- (NSDictionary *)lcrkValueTransformersMapping;

//- (void)lcrkParseDatasInDictioary:(NSDictionary *)aDictionary;

@end
