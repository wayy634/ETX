//
//  LCRKAPITask.m
//  LCRestKit
//
//  Created by HXG on 9/22/14.
//  Copyright (c) 2014 LeCai. All rights reserved.
//

#import "LCRKAPITask.h"

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "LTools.h"

#import "LCRKAPITaskManager.h"
#import "LCRestKit.h"
#import "LCRKTools.h"
#import "LCRKMappingData.h"
#import "RKMappingResult.h"

#import "LCAPIResult.h"

#import "AppDelegate.h"
#import "UIAlertView+Block.h"
#import "UIWindow+LCAddition.h"

NSString * const LCRKAPITaskException = @"LCRKAPITaskException";

//为了去掉警告
@protocol LCRKAPITaskPrivateDelegate <NSObject>

- (void)modelRequestFailed:(NSError *)aError;
- (void)modelRequestFinished:(RKMappingResult *)mappintResult;
- (void)modelRequestTimeOut:(id)aObject;

@end

@interface LCRKAPITask ()

@property (nonatomic, strong) ASIFormDataRequest *dataRequest;
@property (nonatomic, assign) BOOL shouldCancelOtherTask;
@property (nonatomic, assign) BOOL shouldAddToCancellationTaskQueue;

@end

@implementation LCRKAPITask

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.urlCacheMode = NO;
        self.shouldAddToCancellationTaskQueue = YES;
        self.shouldCancelOtherTask = YES;
        self.httpRequestMethod = LCRKHttpMethodGET;
    }
    return self;
}

- (void)dealloc
{
    self.dataRequest = nil;
    self.apiRequestURI = nil;
    self.params = nil;
    self.resultMappingName = nil;
    self.delegate = nil;
    [super dealloc];
}

//- (BOOL)isUrlCacheMode
//{
//    return NO;
//}
//
//- (BOOL)shouldCancelOtherTask
//{
//    return YES;
//}
//
//- (BOOL)shouldAddToCancellationTaskQueue
//{
//    return YES;
//}
//
//- (LCRKHttpMethod)httpRequestMethod
//{
//    return LCRKHttpMethodGET;
//}
//
//- (NSString *)apiRequestURI
//{
//    [NSException raise:LCRKAPITaskException format:@"You must ovrride this method %s in child class", __func__];
//    return nil;
//}

#pragma mark - private
- (void)run
{
    NSString *requestURLStr = self.apiRequestURI;
    ASIFormDataRequest *dataRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestURLStr]];
    
    if (_httpRequestMethod == LCRKHttpMethodPOST) {
        dataRequest.requestMethod = @"POST";
    } else if (_httpRequestMethod == LCRKHttpMethodPUT) {
        dataRequest.requestMethod = @"PUT";
    }  else if (_httpRequestMethod == LCRKHttpMethodPostBody) {
        dataRequest.requestMethod = @"POST";
    } else {
        dataRequest.requestMethod = @"GET";
    }
    NSLog(@"<<<<<<<< url: %@ http method: %@", self.apiRequestURI, dataRequest.requestMethod);
    
    NSMutableDictionary *allParams = [self configureParams];
    
    if (_httpRequestMethod == LCRKHttpMethodGET) {
        NSMutableArray *tmpParams = [NSMutableArray array];
        [allParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [tmpParams addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }];
        requestURLStr = [NSString stringWithFormat:@"%@?%@", requestURLStr, [tmpParams componentsJoinedByString:@"&"]];
        dataRequest.url = [NSURL URLWithString:requestURLStr];
        NSLog(@"<<<<<<<< dataRequest.url: %@", dataRequest.url);
        NSLog(@"<<<<<<<< url: %@ params: %@", self.apiRequestURI, allParams);
    } else if (_httpRequestMethod == LCRKHttpMethodPostBody) {
        if ([NSJSONSerialization isValidJSONObject:allParams]) {
            NSData *postDatas = [NSJSONSerialization dataWithJSONObject:allParams options:NSJSONWritingPrettyPrinted error:nil];
            [dataRequest setPostBody:(NSMutableData *)postDatas];
            postDatas = nil;
            NSLog(@"<<<<<<<< url: %@ params: %@", self.apiRequestURI, dataRequest.postBody);
        }
        NSLog(@"allParams = %@", allParams);
    } else {
        [allParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [dataRequest addPostValue:obj forKey:key];
        }];
        NSLog(@"<<<<<<<< url: %@ params: %@", self.apiRequestURI, allParams);
    }
    __block LCRKAPITask *weakSelf = self;
    [dataRequest setStartedBlock:^{
        [weakSelf requestStarted:dataRequest];
    }];
    
    [dataRequest setCompletionBlock:^{
        [weakSelf requestFinished:dataRequest];
    }];
    
    [dataRequest setFailedBlock:^{
        [weakSelf requestFailed:dataRequest];
    }];
    
    [dataRequest startAsynchronous];
    self.dataRequest = dataRequest;
    [dataRequest release];
}

- (NSMutableDictionary *)configureParams
{
    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] init];
    
    if (self.params) {
        [aDictionary addEntriesFromDictionary:self.params];
    }
    [aDictionary setObject:[LTools timeStamp] forKey:@"timestamp"];
        NSString *deviceToken = [LTools getObjectFromSystemKey:K_KEY_DEVICE_TOKEN];
        if (!deviceToken) {
            deviceToken = @"";
        }
    [aDictionary setObject:deviceToken forKey:@"devicetoken"];
    [aDictionary setObject:@"ios" forKey:@"deviceType"];
    
    return [aDictionary autorelease];
}

- (void)failedWithError:(NSError *)aError
{
    if (self.delegate) {
        
        if (_failedSelector) {
            if ([self.delegate respondsToSelector:_failedSelector]) {
                [self.delegate performSelector:_failedSelector withObject:aError];
            }
        } else {
            [[UIWindow lcCurrentTopWindow] makeToastAtCustomPosition:@"网络连接失败"];
            if ([self.delegate respondsToSelector:@selector(modelRequestFailed:)]) {
                [self.delegate performSelector:@selector(modelRequestFailed:) withObject:aError];
            }
        }
    }
}

- (void)timeoutWithError:(NSError *)aError
{
    if (self.delegate) {
        if (self.timeoutSelector) {
            if ([self.delegate respondsToSelector:self.timeoutSelector]) {
                [self.delegate performSelector:self.timeoutSelector withObject:aError];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(modelRequestTimeOut:)]) {
                [self.delegate performSelector:@selector(modelRequestTimeOut:) withObject:aError];
            }
        }
    }
}

- (void)cancelWithError:(NSError *)aError
{
    if (self.delegate) {
        if (self.cancelSelector && [self.delegate respondsToSelector:self.cancelSelector]) {
            [self.delegate performSelector:self.cancelSelector withObject:nil];
        }
    }
}

- (void)finishedWithResult:(RKMappingResult *)mappingResult
{
    if (self.delegate) {
        if (self.finishedSelector) {
            if ([self.delegate respondsToSelector:self.finishedSelector]) {
                [self.delegate performSelector:self.finishedSelector withObject:mappingResult];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(modelRequestFinished:)]) {
                [self.delegate performSelector:@selector(modelRequestFinished:) withObject:mappingResult];
            }
        }
    }
}

- (BOOL)shouldAddToCancellationTaskQueue
{
    NSArray *unableCancelledURIs = @[
//                                     @"/push/deviceregisterconfig",
//                                     @"/lottery/coolhotlostlist/search/findByLotteryTypeAndPlayType",
//                                     @"/adv/adv/search/findByIdList",
//                                     @"/deploy/initconfig/search/findByFirstStart"
                                     ];
    
//    if (![unableCancelledURIs containsObject:self.apiRequestURI]) {
//        return YES;
//    }
    for (NSString *temp in unableCancelledURIs) {
        if ([self.apiRequestURI rangeOfString:temp].location != NSNotFound) {
            return NO;
        }
    }
    
    if (!self.isAllowCancel) {
        return NO;
    }
    
    return YES;
}

- (BOOL)shouldCancelOtherTask
{
    NSArray *URIs = @[
//                      @"/push/deviceregisterconfig",
//                      @"/lottery/coolhotlostlist/search/findByLotteryTypeAndPlayType",
//                      @"/adv/adv/search/findByIdList",
//                      @"/adv/adv/search/findLoadAdvByScreenWAndScreenH",
//                      @"/deploy/initconfig/search/findByFirstStart"
                      ];
//    if (![URIs containsObject:self.apiRequestURI]) {
//        return YES;
//    }
    
    for (NSString *temp in URIs) {
        if ([self.apiRequestURI rangeOfString:temp].location != NSNotFound) {
            return NO;
        }
    }
    
    if (!self.isAllowCancel) {
        return NO;
    }
    
    return YES;
}

- (void)runTask
{
    if ([self shouldCancelOtherTask]) {
        [[LCRKAPITaskManager sharedAPITaskManager] cancelAllTasks];
    }
    
    if ([self shouldAddToCancellationTaskQueue]) {
        [[LCRKAPITaskManager sharedAPITaskManager] addTask:self];
    }
    
    [self run];
}

- (NSDictionary *)nestedFuciton:(NSDictionary *)data_ {
    NSMutableDictionary *markDictionary = [NSMutableDictionary dictionary];
    
    for (NSString *key in [data_ allKeys]) {
        if ([key isEqualToString:@"data"]) {
            NSMutableDictionary *markDic = [NSMutableDictionary dictionary];
            [markDic setObject:[NSArray arrayWithObject:[data_ objectForKey:@"data"]] forKey:@"modelList"];
            [markDictionary setObject:markDic forKey:key];
        } else {
            [markDictionary setObject:[data_ objectForKey:key] forKey:key];
        }
    }
    return markDictionary;
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
//    NSLog(@"=================== request started: %@", [request.url absoluteString]);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSLog(@"------------------------------: %@", request.responseString);
    
    NSError *aError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&aError];
    NSLog(@"****** response: %@", jsonObject);
    
    LCAPIResult *apiResult = [LCAPIResult lcrkMappedObjectWithDictionary:[self nestedFuciton:jsonObject] extendMappingConfiguration:LCRKModuleListMappingConfigurationForKey(self.resultMappingName)];
//
    RKMappingResult *mappingResult = [RKMappingResult resultWithFirstObject:apiResult];
    
//    [[LCRKAPITaskManager sharedAPITaskManager] removeTask:self];
//    
//    [self autorelease];
    [self finishedWithResult:mappingResult];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"*************** api: %@ ************ failed: %@", request.url, request.error);
    [[LCRKAPITaskManager sharedAPITaskManager] removeTask:self];
    if (self.delegate) {
        NSError *aError = request.error;
        if (aError.code == ASIRequestCancelledErrorType) {
            [self cancelWithError:aError];
        } else if (aError.code == ASIRequestTimedOutErrorType) {
            [self timeoutWithError:aError];
        } else {
            [self failedWithError:aError];
        }
    }

    [self release];
}

#pragma mark - encrypt request parameters

- (NSString *)encryptParams:(NSDictionary *)params_ {
    
    NSMutableDictionary *signData = [[NSMutableDictionary alloc] initWithDictionary:params_];
    
    NSString *signKey = [LTools getObjectFromSystemKey:K_KEY_SIGN_ID];
    
    NSString *signSecret = nil;
    NSString *paramTimestamp = signData[@"timestamp"];
    
    if (signKey && ![signKey isEqualToString:@""]) {
        signSecret = [LTools md5:signKey];
    } else {
        double targetTimestamp  = [paramTimestamp doubleValue];
        double baseTimestamp    = 1379845206000;
        signSecret = [LTools md5:[LTools md5:[NSString stringWithFormat:@"%.f", (targetTimestamp - baseTimestamp)]]];
    }
    
    signData[@"secret"] = signSecret;
    
    NSInteger lastItemInTimestamp = [[paramTimestamp substringWithRange:NSMakeRange(paramTimestamp.length - 1, 1)] integerValue];
    
    NSUInteger paramAmount = [signData count];
    NSMutableArray *paramAndValues = [[NSMutableArray alloc] initWithCapacity:paramAmount];
    
    NSString *nameValueSplit = @"|||";
    [signData enumerateKeysAndObjectsUsingBlock:^(NSString *paramName, NSString *paramValue, BOOL *stop) {
        [paramAndValues addObject:[NSString stringWithFormat:@"%@", paramName]];
    }];
    
    [paramAndValues sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableArray *sortedParamNames = [[NSMutableArray alloc] initWithCapacity:paramAmount];
    
    for (NSString *tmpNameAndValue in paramAndValues) {
        NSString *paramName = [tmpNameAndValue componentsSeparatedByString:nameValueSplit][0];
        if (paramName) {
            [sortedParamNames addObject:paramName];
        }
    }
    
    if (lastItemInTimestamp >= paramAmount) {
        lastItemInTimestamp = paramAmount - 1;
    }
    
    [paramAndValues removeAllObjects];
    
    [sortedParamNames enumerateObjectsUsingBlock:^(NSString *paramName, NSUInteger idx, BOOL *stop) {
        if (idx == lastItemInTimestamp) {
            [paramAndValues addObject:[NSString stringWithFormat:@"%@?*%@", paramName, signData[paramName]]];
        } else {
            [paramAndValues addObject:[NSString stringWithFormat:@"%@*%@", paramName, signData[paramName]]];
        }
    }];
    
//    NSLog(@"--------  encrypt params: %@", [paramAndValues componentsJoinedByString:@"?"]);
    
    NSString *signedResult = [[LTools md5:[paramAndValues componentsJoinedByString:@"?"]] uppercaseString];
    
//    NSLog(@"************** signedResult: %@", signedResult);
    
    [paramAndValues release];
    [sortedParamNames release];
    
    return signedResult;
}

#pragma mark - public
- (void)cancelTask
{
    [self.dataRequest cancel];
}

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
        cancelSelector:(SEL)cancelSelector
{
    LCRKAPITask *apiTask = [[LCRKAPITask alloc] init];
    apiTask.apiRequestURI = apiRequestURI;
    apiTask.params = params;
    apiTask.httpRequestMethod = httpMethod;
    apiTask.delegate = delegate;
    apiTask.isAllowCancel = allowCancel;
    apiTask.finishedSelector = finishedSelector;
    apiTask.failedSelector  = failedSelector;
    apiTask.cancelSelector  = cancelSelector;
    apiTask.timeoutSelector = timeoutSelector;
    apiTask.resultMappingName = mappingName;
    apiTask.urlCacheMode = urlCacheMode;
    [apiTask runTask];
}

@end
