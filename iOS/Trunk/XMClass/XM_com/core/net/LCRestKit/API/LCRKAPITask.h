//
//  LCRKAPITask.h
//  LCRestKit
//
//  Created by HXG on 9/22/14.
//  Copyright (c) 2014 LeCai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LCRKHttpMethodGET,
    LCRKHttpMethodPOST,
    LCRKHttpMethodPUT,
    LCRKHttpMethodPostBody
} LCRKHttpMethod;

extern NSString * const LCRKAPITaskException;

@interface LCRKAPITask : NSObject

/**
 *  是否使用URL缓存
 *  老版本同时也是将该值用来判断加密算法是否需要密码的标准 （虽然传递到加密算法里了，但是没有实际使用）
 *  默认值为NO
 */
@property (nonatomic, assign, getter=isUrlCacheMode) BOOL urlCacheMode;

/**
 *  当该请求发起时是否取消其他的任务， 默认值为YES, 
 */
@property (nonatomic, assign, readonly) BOOL shouldCancelOtherTask;

/**
 *  是否应该将来任务加入到可取消任务的列表中， 默认值为YES
 */
@property (nonatomic, assign, readonly) BOOL shouldAddToCancellationTaskQueue;

/**
 *  进行HTTP请求的方法，默认使用GET方法
 */
@property (nonatomic, assign) LCRKHttpMethod httpRequestMethod;

/**
 *  进行HTTP请求的URI，去除掉前方域名的公共部分（http://proxyapi.lecai.com）
 */
@property (nonatomic, strong) NSString *apiRequestURI;

/**
 *  进行HTTP请求所需要的参数定义列表
 */
@property (nonatomic, strong) NSDictionary *params;

/**
 *  对HTTP响应的结果进行对象的映射所需要的配置对应的名字
 */
@property (nonatomic, strong) NSString *resultMappingName;

/**
 *  回调消息的接收体
 */
@property (nonatomic, retain) id  delegate;

/**
 *  本次请求是否允许被其他的请求cancel
 */
@property (assign) BOOL  isAllowCancel;

/**
 *  四个回调方法
 *  成功，失败，超时，取消
 */
@property (nonatomic, assign) SEL finishedSelector;
@property (nonatomic, assign) SEL failedSelector;
@property (nonatomic, assign) SEL timeoutSelector;
@property (nonatomic, assign) SEL cancelSelector;

- (void)cancelTask;

+ (void)runTaskWithURI:(NSString *)apiRequestURI
                params:(NSDictionary *)params
                method:(LCRKHttpMethod)httpMethod
              delegate:(id)delegate
           allowCancel:(BOOL)allowCancel
     resultMappingName:(NSString *)mappingName
          urlCacheMode:(BOOL)urlCacheMode
      finishedSelector:(SEL)finishedSelector
        failedSelector:(SEL)failedSelector
       timeoutSelector:(SEL)timeoutSelector
        cancelSelector:(SEL)cancelSelector;

@end
