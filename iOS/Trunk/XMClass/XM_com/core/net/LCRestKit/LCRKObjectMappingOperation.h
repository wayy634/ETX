//
//  LCRKObjectMappingOperation.h
//  LCRestKit
//
//  Created by HXG on 9/17/14.
//  Copyright (c) 2014 LeCai. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LCRKParseException;

typedef void (^LCRKMappingResultBlock)(BOOL success, id mappingResult);

typedef enum {
    LCRKParseRuleNone,
    LCRKParseRuleJSON,
    LCRKParseRuleXML,
} LCRKParseRule;

@interface LCRKObjectMappingOperation : NSOperation

/**
 *  此间会抛出LCRKParseException异常
 *
 *  @param originValue          待解析的源数组
 *  @param mappingConfiguration 待解析的源数组对应的Class配置
 *  @param resultBlock          解析完成后的回调
 */
+ (void)startObjectMappingFromArray:(NSArray *)originValue
                  withConfiguration:(NSArray *)mappingConfiguration
                extendConfiguration:(NSDictionary *)extendConfiguration
                        resultBlock:(LCRKMappingResultBlock)resultBlock;

/**
 *  此间会抛出LCRKParseException异常
 *
 *  @param originValue          待解析的源字典
 *  @param mappingConfiguration 待解析的源字典中key对应的Class配置
 *  @param resultBlock          解析完成后的回调
 */
+ (void)startObjectMappingFromDictionary:(NSDictionary *)originValue
                       withConfiguration:(id)mappingConfiguration
                     extendConfiguration:(NSDictionary *)extendConfiguration
                             resultBlock:(LCRKMappingResultBlock)resultBlock;


/**
 *  此间会抛出LCRKParseException异常
 *
 *  @param originValue          待解析的源字符串
 *  @param parseRule            解析字符串用到的解析规则，有JSON方式解析，XML方式解析，暂时只支持JSON解析
 *  @param mappingConfiguration 待解析数据的对象Class配置 （如果字符串解析后是字典，则该配置也需要是字典；如果字符串解析后是数组，则该配置也需要是数组）
 *  @param resultBlock          解析完成后的回调
 */
+ (void)startObjectMappingFromString:(NSString *)originValue
                           parseRule:(LCRKParseRule)parseRule
                   withConfiguration:(id)mappingConfiguration
                 extendConfiguration:(NSDictionary *)extendConfiguration
                         resultBlock:(LCRKMappingResultBlock)resultBlock;



@end
