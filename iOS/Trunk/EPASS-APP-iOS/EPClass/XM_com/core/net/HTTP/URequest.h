//
//  URequest.h
//  ASIHTTPRequestDemo
//
//  Created by HXG on 11-8-8.
//  Copyright 2011 MyCompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URequestFailedDelegate.h"
#import "URequestFinishedDelegate.h"
#import "URequestTimeOutDelegate.h"
#import "URequestCallBackFuctionDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define UREQUEST_TIME_OUT_SECONDS 10 
#define UREQUEST_ANIMATION_IMAGE @"requestloading.png"

@class ASIDownloadCache;
@class FlowCoverView;
@interface URequest : NSObject <UIAlertViewDelegate>{
	UIActivityIndicatorView         *mActivityIndicatorView;// loading动画插件
    UIImageView                     *mLoadingImageView;     // 加载时的动画图片
	ASIDownloadCache                *mCache;                // 缓存设置
	ASIFormDataRequest              *mRequest;              // 第三方网络框架对象
	id<URequestFailedDelegate>      requestFailedDelegate;  // 网络请求错误回调方法
	id<URequestFinishedDelegate>    requestFinishedDelegate;// 网络请求完成回调方法
	id<URequestTimeOutDelegate>     requestTimeOutDelegate; // 网络请求超时回调方法
    id<URequestCallBackFuctionDelegate> requestCallBackDelegate; // 网络请求额外的回调方法
	SEL                             mDidFinishedSelector;   // 网络请求完成自定义方法
	SEL                             mDidFailedSelector;     // 网络请求失败自定义方法
	SEL                             mDidTimeOutSelector;    // 网络请求超时自定义方法
    SEL                             mDidCallBackSelector;    // 网络请求额外自定义方法
    UIView                          *mShowActivityIndicatorView; // 显示loading动画插件的接收view
    UIView                          *respondImageView;  // 只限RequestType = RequestTypeImage,mRequestTypeVideo 接收完成监控的view
    int                             mRequestType;        // request的type
    NSMutableString                 *mUpdateURL;        //升级URL 
    BOOL                            mIsReLink;          //重连
    BOOL                            mIsNeedPrompt;      //是否需要提示
    NSString                        *mAddress;          //url地址
    NSString                        *mParam;            //postdata参数
    NSMutableString                 *mPrompt;           //异常和提示语
}

typedef enum {
	RequestTypeText    = 0,
	RequestTypeImage   = 1,
	RequestTypeVideo   = 2
} RequestType; //request类型,分文本,图片,视频

// 初始化request的url，包含HTTPBody参数param
- (id)initWithAddress:(NSString *)address param:(NSString *)param;

// 初始化request的url，包含HTTPBody参数param和request类型
- (id)initWithAddress:(NSString *)address param:(NSString *)param requestType:(RequestType)type;

// 初始化request的url，无需参数，只有类型，一般用于下载图片和视频
- (id)initWithAddress:(NSString *)address requestType:(RequestType)type;

- (void)addHeaderKey:(NSString *)header_ value:(NSString *)value_;

// 设置request的method
- (void)setMethod:(NSString *)method;

// 当前request的进度百分比
- (int)getCurrentPercent;

// 设置request超时时间
- (void)setuOverTimeSeconds:(NSTimeInterval)seconds;

// 设置委托对象
- (void)setuDelegate:(id)delegate;

// 设置重链
- (void)setRelink:(BOOL)isLink;

// 设置自定义网络请求完成回调方法和委托对象
- (void)setuDidFinishSelector:(SEL)sel delegate:(id)delegate;

// 设置自定义网络请求错误回调方法和委托对象
- (void)setuDidFailSelector:(SEL)sel delegate:(id)delegate;

// 设置自定义网络请求超时回调方法和委托对象
- (void)setuDidTimeOutSelector:(SEL)sel delegate:(id)delegate;

// 设置自定义网络请求额外回调方法和委托对象
- (void)setuCallBackSelector:(SEL)sel delegate:(id)delegate;

// 设置网络请求错误委托对象，使用默认回调方法
- (void)setuRequestFailedDelegate:(id)delegate;

// 设置网络请求完成委托对象，使用默认回调方法
- (void)setuRequestFinishedDelegate:(id)delegate;

// 设置网络请求超时委托对象，使用默认回调方法
- (void)setuRequestTimeOutDelegate:(id)delegate;

// 设置网络请求额外委托对象，使用默认回调方法
- (void)setuRequestCallBackDelegate:(id)delegate;

// 设置监控响应view赋值
- (void)setRespondImageView:(UIView *)imageView;

// 获取request的类型
- (int)getRrequestType;

// 设置request的类型
- (void)setRequestType:(RequestType)type;

// 获取第三方网络连接对象
- (ASIHTTPRequest *)getRequest;

// 获取loading动画对象
- (UIActivityIndicatorView *)getActivityIndicatorView;

// 获取缓存对象
- (ASIDownloadCache *)getCache;

// 设置loading动画接收的view
- (void)setShowActivityIndicatorView:(UIView *)view;

//删除菊花
- (void)removeUIActivityIndicatorView; 

//释放
- (void)releaseSelf;

@property (retain,nonatomic) UIActivityIndicatorView         *mActivityIndicatorView;
@property (retain,nonatomic) NSString                        *mPrompt;
@property (assign)           BOOL                            mIsNeedPrompt;
@property (retain,nonatomic) id<URequestFailedDelegate>      requestFailedDelegate;       // 网络请求错误回调方法
@property (retain,nonatomic) id<URequestFinishedDelegate>    requestFinishedDelegate;   // 网络请求完成回调方法
@property (retain,nonatomic) id<URequestTimeOutDelegate>     requestTimeOutDelegate;
@property (retain,nonatomic) id<URequestCallBackFuctionDelegate> requestCallBackDelegate;
@end
