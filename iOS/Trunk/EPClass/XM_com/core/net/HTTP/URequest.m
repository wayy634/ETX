//
//  URequest.m
//  ASIHTTPRequestDemo
//
//  Created by HXG on 11-8-8.
//  Copyright 2011 MyCompanyName. All rights reserved.
//

#import "URequest.h"
#import "ASIDownloadCache.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "LTools.h"
#import "KCommon.h"

@implementation URequest
@synthesize requestFailedDelegate;  
@synthesize requestFinishedDelegate;
@synthesize requestTimeOutDelegate;
@synthesize requestCallBackDelegate;
@synthesize mActivityIndicatorView;
@synthesize mPrompt;
@synthesize mIsNeedPrompt;
#pragma mark -
#pragma mark request初始化方法
- (id)initWithAddress:(NSString *)address param:(NSString *)param {
    [self setRequestType:RequestTypeText];
    mAddress = [[NSString alloc] initWithString:address];
    mParam = [[NSString alloc] initWithString:param];
    mPrompt = [[NSMutableString alloc] initWithFormat:STRING(@"s_network_error")];
    mIsReLink = NO;
    mIsNeedPrompt = YES;
    mUpdateURL = [[NSMutableString alloc] init];
//    NSString *composeUrl = [NSString stringWithFormat:@"%@%@%@&version=%@&device_id=%@", K_URL_ADDRESS, address ,[LTools getObjectFromSystemKey:@"appkey"],K_CLIENT_VERSION,[LTools getObjectFromSystemKey:K_KEY_DEVICE_ID]];
    NSString *composeUrl = [NSString stringWithFormat:@"%@%@", K_URL_REWARD_HOST, address];
    NSLog(@"url ====== %@", composeUrl);
	mRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:composeUrl]];
    [mRequest setRequestMethod:@"POST"];
	[mRequest setDelegate:self];
    [mRequest setTimeOutSeconds:UREQUEST_TIME_OUT_SECONDS];
    NSLog(@"param = %@",param);
    if (param != nil) {
        NSString *enCodeParam;
//        if ([param rangeOfString:@":"].location != NSNotFound) { //字符串中包含:符号
//            enCodeParam = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
//                                                                              (CFStringRef)param,
//                                                                              NULL,
//                                                                              (CFStringRef)@":@",
//                                                                              kCFStringEncodingUTF8);
//            
//        } else if ([param rangeOfString:@"@"].location != NSNotFound) { //字符串中包含@符号
//            enCodeParam = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
//                                                                              (CFStringRef)param,
//                                                                              NULL,
//                                                                              (CFStringRef)@"@@",
//                                                                              kCFStringEncodingUTF8);
//            
//        } else {
//            enCodeParam = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        }
        NSString *postData = param;//[LTools signString:enCodeParam];
        NSLog(@"postData = %@",postData);
        if (postData != nil) {
            NSArray *array = [postData componentsSeparatedByString:@"&"];
            if ([array count] > 0) {
                for (NSString *string in array) {
                    //得到=的索引
                    if ([string rangeOfString:@"="].location != NSNotFound) {
                        int index = [[NSNumber numberWithInteger:([string rangeOfString:@"="]).location] intValue]; 
                        NSString *key = [string substringToIndex:index];            // =前, key值
                        NSString *value = [string substringFromIndex:(index + 1)];  // =后, value
                        [mRequest setPostValue:value forKey:key];
                    }
                }
            }
        }
    }
    return self;
}

- (id)initWithAddress:(NSString *)address param:(NSString *)param requestType:(RequestType)type {
    [self initWithAddress:address param:param];
    [self setRequestType:type];
	if (type == RequestTypeImage) {
		[mRequest setRequestMethod:@"GET"];
		mCache = [[ASIDownloadCache alloc] init];
		[mCache setStoragePath:[NSHomeDirectory() stringByAppendingString:@"/Documents/Images/"]];
		[mRequest setDownloadCache:mCache];
		[mRequest setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
		[mRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	} else if (type == RequestTypeVideo) {
		[mRequest setRequestMethod:@"GET"];
		mCache = [[ASIDownloadCache alloc] init];
		[mCache setStoragePath:[NSHomeDirectory() stringByAppendingString:@"/Documents/Video/"]];
		[mRequest setDownloadCache:mCache];
		[mRequest setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
		[mRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	}
	return self;
}

- (id)initWithAddress:(NSString *)address requestType:(RequestType)type {
    [self setRequestType:type];
    mRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:address]];
    [mRequest setRequestMethod:@"POST"];
	[mRequest setDelegate:self];
    [mRequest setTimeOutSeconds:UREQUEST_TIME_OUT_SECONDS];
    if (type == RequestTypeImage) {
		[mRequest setRequestMethod:@"GET"];
		mCache = [[ASIDownloadCache alloc] init];
		[mCache setStoragePath:[NSHomeDirectory() stringByAppendingString:@"/Documents/Images/"]];
		[mRequest setDownloadCache:mCache];
		[mRequest setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
		[mRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	} else if (type == RequestTypeVideo) {
		[mRequest setRequestMethod:@"GET"];
		mCache = [[ASIDownloadCache alloc] init];
		[mCache setStoragePath:[NSHomeDirectory() stringByAppendingString:@"/Documents/Video/"]];
		[mRequest setDownloadCache:mCache];
		[mRequest setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
		[mRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	}
    return self;
}

- (void)addHeaderKey:(NSString *)header_ value:(NSString *)value_ {
    [mRequest addRequestHeader:header_ value:value_];
}

#pragma mark -
#pragma mark 设置request信息(委托对象和回调方法)
- (void)setMethod:(NSString *)method {
	[mRequest setRequestMethod:method];
}

- (void)setRelink:(BOOL)isLink {
    mIsReLink = isLink;
}

- (void)setuOverTimeSeconds:(NSTimeInterval)seconds {
	[mRequest setTimeOutSeconds:seconds];
}

- (void)setuDelegate:(id)delegate {
    [self setRequestFinishedDelegate:delegate];//  requestFinishedDelegate = delegate;
}

- (void)setuDidFinishSelector:(SEL)sel delegate:(id)delegate {
    [self setRequestFinishedDelegate:delegate];
	mDidFinishedSelector = sel;
}

- (void)setuDidFailSelector:(SEL)sel delegate:(id)delegate {
    [self setuRequestFailedDelegate:delegate];
	mDidFailedSelector = sel;
}

- (void)setuDidTimeOutSelector:(SEL)sel delegate:(id)delegate {
    [self setuRequestTimeOutDelegate:delegate];
    mDidTimeOutSelector = sel;
}

- (void)setuCallBackSelector:(SEL)sel delegate:(id)delegate {
    [self setuRequestCallBackDelegate:delegate];
    mDidCallBackSelector = sel;
}

- (void)setuRequestFailedDelegate:(id)delegate {
    self.requestFailedDelegate = delegate;
}

- (void)setuRequestFinishedDelegate:(id)delegate {
    self.requestFinishedDelegate = delegate;
}

- (void)setuRequestTimeOutDelegate:(id)delegate {
    self.requestTimeOutDelegate = delegate;
}

- (void)setuRequestCallBackDelegate:(id)delegate {
    self.requestCallBackDelegate = delegate;
}

- (void)setRespondImageView:(UIView *)imageView {
    respondImageView = imageView;
}

- (void)setShowActivityIndicatorView:(UIView *)view {
//    LeHeCaiAppDelegate *delegate = (id) [[UIApplication sharedApplication] delegate];
//    mActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    CGRect rect = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
//    rect.origin.x = (rect.size.width - 37) / 2;
//    rect.origin.y = (rect.size.height - 37) / 2;
//    rect.size.width = 37;
//    rect.size.height = 37;
//    [mActivityIndicatorView setFrame:rect];
//    mActivityIndicatorView.hidden = NO;
//    [mActivityIndicatorView startAnimating];
//    [delegate.mWindow addSubview:mActivityIndicatorView];
    
    AppDelegate *delegate = (id) [[UIApplication sharedApplication] delegate];
    mLoadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:UREQUEST_ANIMATION_IMAGE]];
    [mLoadingImageView setFrame:CGRectMake((K_SCREEN_WIDTH-mLoadingImageView.frame.size.width)/2,(K_SCREEN_HEIGHT - mLoadingImageView.frame.size.height)/2,
                                                 mLoadingImageView.frame.size.width,
                                                 mLoadingImageView.frame.size.height)];
    
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*UREQUEST_TIME_OUT_SECONDS*2];
    rotationAnimation.duration = UREQUEST_TIME_OUT_SECONDS*2.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [mLoadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [delegate.mWindow addSubview:mLoadingImageView];
}

- (void)setRequestType:(RequestType)type {
    mRequestType = type;
}

#pragma mark -
#pragma mark 获取request成员
- (int)getCurrentPercent {
	double totalBytesRead = [mRequest totalBytesRead];
	double contentLength = [mRequest contentLength];
	return contentLength / totalBytesRead * 100;
}

- (int)getRrequestType {
    return mRequestType;
}

- (ASIHTTPRequest *)getRequest {
    return mRequest;
}

- (UIActivityIndicatorView *)getActivityIndicatorView {
    return mActivityIndicatorView;
}

- (ASIDownloadCache *)getCache{
    return mCache;
}

#pragma mark -
#pragma mark 删除

- (void)removeUIActivityIndicatorView {
//    [mActivityIndicatorView removeFromSuperview];
//    mActivityIndicatorView.hidden = YES;
//    [mActivityIndicatorView stopAnimating];
//    [mActivityIndicatorView release];
//    mActivityIndicatorView = nil;
    [mLoadingImageView removeFromSuperview];
    [mLoadingImageView release] , mLoadingImageView = nil;
}

- (void)releaseSelf {
    [self release] , self = nil;
}

- (void)dealloc {
    [mAddress release] ,                  mAddress = nil;
//    if (mParam != nil) {
//        [mParam release] ,                    mParam = nil;
//    }
    
    [mCache release],                     mCache = nil;
    if (mPrompt != nil || [mPrompt retainCount] > 0) {
        [mPrompt release],                    mPrompt = nil;
    }
//	[mRequest release],                   mRequest = nil;
    [mShowActivityIndicatorView release], mShowActivityIndicatorView = nil;
    [respondImageView release] ,          respondImageView = nil;
    [mUpdateURL release] ,                mUpdateURL = nil;
    [requestFinishedDelegate release];   
    [requestFailedDelegate release];     
    [requestTimeOutDelegate release];
    [requestCallBackDelegate release];
    if (mUpdateURL != nil || [mUpdateURL retainCount] > 0) {
        [mUpdateURL release],             mUpdateURL = nil;
    }
    [super dealloc];
}

#pragma mark -
#pragma mark 第三方网络架构回调

- (void)requestStarted:(ASIHTTPRequest *)request {
//    if (mShowActivityIndicatorView != nil) {
//		mActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        CGRect rect = mShowActivityIndicatorView.frame;
//		rect.origin.x = (rect.size.width - 37) / 2;
//		rect.origin.y = (rect.size.height - 37) / 2;
//		rect.size.width = 37;
//		rect.size.height = 37;
//		[mActivityIndicatorView setFrame:rect];
//		mActivityIndicatorView.hidden = NO;
//		[mActivityIndicatorView startAnimating];
//        [mShowActivityIndicatorView addSubview:mActivityIndicatorView];
//	}
}

- (void)requestTimeOutCallBack:(ASIHTTPRequest *)request {
    
    
    
    
    [self removeUIActivityIndicatorView];
    if ([LTools getCoverView] != nil) {
        [[LTools getCoverView] removeFromSuperview];
    }
    
    if (mIsReLink) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重连", nil];
        alert.tag = 999;
        [alert show];
        [alert release];
        if (mDidTimeOutSelector != nil) {
            if (requestTimeOutDelegate && [requestTimeOutDelegate respondsToSelector:mDidTimeOutSelector]) {
                [requestTimeOutDelegate performSelector:mDidTimeOutSelector];
                return;
            }
        } else if (requestTimeOutDelegate != nil) {
            [requestTimeOutDelegate uRequestTimeOut];
            return;
        }
        return;
    }
    
    if (mDidTimeOutSelector != nil) {
		if (requestTimeOutDelegate && [requestTimeOutDelegate respondsToSelector:mDidTimeOutSelector]) {
			[requestTimeOutDelegate performSelector:mDidTimeOutSelector];
            [self releaseSelf];
            return;
		}
	} else if (requestTimeOutDelegate != nil) {
		[requestTimeOutDelegate uRequestTimeOut];
        [self releaseSelf];
        return;
	}
    if (mIsNeedPrompt) {
        [LTools alertWithTitle:STRING(@"s_prompt") msg:STRING(@"s_network_timeout")];
    }
    
    [self releaseSelf];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSLog(@"request = %@",request);
    
    if ([[LTools getUnfinishedUrequest] count] > 0) {
        for (URequest *uRequest in [LTools getUnfinishedUrequest]) {
            if ([uRequest getRequest] == request) {
                [[LTools getUnfinishedUrequest] removeObject:uRequest];
                break;
            }
        }
    }
    
    [self removeUIActivityIndicatorView];
    if ([LTools getCoverView] != nil) {
        [[LTools getCoverView] removeFromSuperview];
    }
    
    if ([self getRrequestType] == RequestTypeImage) {
		if ([requestFinishedDelegate retainCount] >0 && requestFinishedDelegate != nil && mDidFinishedSelector != nil) {
			if (requestFinishedDelegate  && [requestFinishedDelegate respondsToSelector:mDidFinishedSelector]) {
				[requestFinishedDelegate performSelector:mDidFinishedSelector withObject:request];
			}
		}
        [self releaseSelf];
        return;
        
        //        if (respondImageView == nil) {
        //            return;
        //        } else {
        //            [(UIImageView *)respondImageView setImage:[UIImage imageWithData:[request responseData]]];
        //        }
    } else if ([self getRrequestType] == RequestTypeVideo) {
        
    }
    
    NSString *receive = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSDictionary *root = [receive JSONValue];
    NSLog(@"root = %@",root);
    if (root == nil) {
        if (mDidFailedSelector != nil) {
            if (requestFailedDelegate && [requestFailedDelegate respondsToSelector:mDidFailedSelector]) {
                [requestFailedDelegate performSelector:mDidFailedSelector];
                return;
            }
        } else if (requestFailedDelegate != nil) {
            [requestFailedDelegate uRequestFail];
            return;
        }
    return;
    }
    [receive release] , receive = nil;
    
    if ([LTools isJsonError:root]) {
        if ([[root objectForKey:@"code"] intValue] == K_LOGIN_REQUIRE_SID) {
//            AppDelegate *delegate = (id) [[UIApplication sharedApplication] delegate];
//            isLocked = NO;
//            isSetMessageLock = NO;
//            mIsAlreadyDown= NO;
            
//            if ([[delegate.mNavigationController.viewControllers lastObject] isKindOfClass:[LCAcountInformationVC class]]) {
//                ((LCAcountInformationVC*)[delegate.mNavigationController.viewControllers lastObject]).isSetMessageLock = NO ;
//            }
//            else if ([[delegate.mNavigationController.viewControllers lastObject] isKindOfClass:[SupplementVC class]]) {
//                [(SupplementVC*)[delegate.mNavigationController.viewControllers lastObject] dismissAlertView];
//            } else if ([[delegate.mNavigationController.viewControllers lastObject] isKindOfClass:[FootballPayVC class]]) {
//                [(FootballPayVC*)[delegate.mNavigationController.viewControllers lastObject] dismissAlertView];
//            } else if ([[delegate.mNavigationController.viewControllers lastObject] isKindOfClass:[UnitedBillVC class]]) {
//                [(UnitedBillVC*)[delegate.mNavigationController.viewControllers lastObject] dismissAlertView];
//            } else if ([[delegate.mNavigationController.viewControllers lastObject] isKindOfClass:[TogetherDetailVC class]]) {
//                [(TogetherDetailVC*)[delegate.mNavigationController.viewControllers lastObject] dismissAlertView];
//            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为了您的账户安全，请重新登录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 100;
            [alert show];
            [alert release];
//            [[GlobalData sharedInstance] setSid:@""];
//            [[GlobalData sharedInstance] setNotPayOrderNum:@"0"];
            [LTools setObjectFromSystem:@"" key:K_KEY_SID];
            
            if (mDidCallBackSelector != nil) {
                if (requestCallBackDelegate && [requestCallBackDelegate respondsToSelector:mDidCallBackSelector]) {
                    [requestCallBackDelegate performSelector:mDidCallBackSelector];
                }
            } else {
                [requestCallBackDelegate uRequestCallBackFuction];
            }
            return;
        }
    }
    
//    [[LCCacheCenter defaultObject] cacheData:request param:mParam];
    
    if ([[[root objectForKey:@"app_control"] objectForKey:@"lottery_whitelist_enable"] intValue] != 0) {
//        [[LTools getWhiteList] removeAllObjects];
//        [[LTools getWhiteList] addObjectsFromArray:[[root objectForKey:@"app_control"] objectForKey:@"lottery_whitelist"]];
        [LTools setObjectFromSystem:[[root objectForKey:@"app_control"] objectForKey:@"lottery_whitelist"] key:@"whiteList"];
    }
    
    if ([root objectForKey:@"sid"] != [NSNull null] && ![[root objectForKey:@"sid"] isEqualToString:@""] && [[root objectForKey:@"code"] intValue] == 0) {
//        [[GlobalData sharedInstance] setSid:[root objectForKey:@"sid"]];
    }

    if ([self getRrequestType] == RequestTypeText) {
        if (mDidFinishedSelector != nil) {
            if (requestFinishedDelegate && [requestFinishedDelegate respondsToSelector:mDidFinishedSelector]) {
                [requestFinishedDelegate performSelector:mDidFinishedSelector withObject:root];
            }
        } else {
            [requestFinishedDelegate uRequestFinished:root];
        }
    }
    
//    if (3 == [[[root objectForKey:@"app_info"] objectForKey:@"policy"] intValue] && ![LTools getHavePrompt]) {
//        [mUpdateURL setString:[[root objectForKey:@"app_info"] objectForKey:@"url"]];
//        UIAlertView  *updateVersion = [[UIAlertView alloc] initWithTitle:@"提示" 
//                                                                 message:[[root objectForKey:@"app_info"] objectForKey:@"update_log"] 
//                                                                delegate:self 
//                                                       cancelButtonTitle:@"立即升级"
//                                                       otherButtonTitles:nil, nil];
//        updateVersion.tag = 300;
//        [updateVersion show];
//        [updateVersion release];
//        [LTools setHavePrompt:YES];
//        return;
//    }
//    if (2 == [[[root objectForKey:@"app_info"] objectForKey:@"policy"] intValue] && ![LTools getHavePrompt]) {
//        [mUpdateURL setString:[[root objectForKey:@"app_info"] objectForKey:@"url"]];
//        UIAlertView  *updateVersion = [[UIAlertView alloc] initWithTitle:@"提示" 
//                                                                 message:[[root objectForKey:@"app_info"] objectForKey:@"update_log"] 
//                                                                delegate:self 
//                                                       cancelButtonTitle:@"稍后再说" 
//                                                       otherButtonTitles:@"立即升级", nil];
//        updateVersion.tag = 200;
//        [updateVersion show];
//        [updateVersion release];
//        [LTools setHavePrompt:YES];
//        return;
//    }
    
    
    [self releaseSelf];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self removeUIActivityIndicatorView];
    [[LTools getUnfinishedUrequest] removeAllObjects]; 
    if ([LTools getCoverView] != nil) {
        [[LTools getCoverView] removeFromSuperview];
    }
    if (mIsReLink) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:mPrompt delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重连", nil];
        alert.tag = 999;
        [alert show];
        [alert release];
        if (mDidFailedSelector != nil) {
            if (requestFailedDelegate && [requestFailedDelegate respondsToSelector:mDidFailedSelector]) {
                [requestFailedDelegate performSelector:mDidFailedSelector];
                return;
            }
        } else if (requestFailedDelegate != nil) {
            [requestFailedDelegate uRequestFail];
            return;
        }
        return;
    }
    if ([self getRrequestType] != RequestTypeText) {
        [self releaseSelf];
        return;
    }
    
    if (mDidFailedSelector != nil) {
		if (requestFailedDelegate && [requestFailedDelegate respondsToSelector:mDidFailedSelector]) {
			[requestFailedDelegate performSelector:mDidFailedSelector];
//          [self releaseSelf];
            return;
		}
	} else if (requestFailedDelegate != nil) {
		[requestFailedDelegate uRequestFail];
        [self releaseSelf];
        return;
	}
    if (mIsNeedPrompt) {
        [LTools alertWithTitle:STRING(@"s_prompt") msg:STRING(@"s_network_error")];
    }
    [self releaseSelf];
}

#pragma mark -
#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((alertView.tag == 200 && buttonIndex == 1) || (300 == alertView.tag && 0 == buttonIndex)) {
        if ([mUpdateURL length] > 0) {
            [LTools updateApp:mUpdateURL];
        } 
    }
//    if (100 == alertView.tag) {
//        if (1 == buttonIndex) {
//            LCInputUNameAndPwdVC *inputUNameAndPwdVC = [[LCInputUNameAndPwdVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//            inputUNameAndPwdVC.mISLogin = YES;
//            [LTools pushController:inputUNameAndPwdVC animated:YES];
//            [inputUNameAndPwdVC release] , inputUNameAndPwdVC = nil;
//        }else {
//            [LTools setSecretObjectFromSystem:@"" key:K_NEW_KEY_LOGIN_PASSWD];
//            [LTools setObjectFromSystem:[NSNumber numberWithBool:NO] key:K_KEY_LOGIN_AUTO];
//            [LTools setObjectFromSystem:@"0" key:K_KEY_EMAIL_CHECKED];
//            [LTools setObjectFromSystem:@"0" key:K_KEY_PHONE_CHECKED];
//            [LTools setObjectFromSystem:@"" key:K_KEY_LOGIN_PHONE];
//            [LTools setObjectFromSystem:@"" key:K_KEY_LOGIN_EMAIL];
//            [[GlobalData sharedInstance] setSid:@""];
//            [LTools setObjectFromSystem:@"" key:K_KEY_SID];
//            [[GlobalData sharedInstance] setNotPayOrderNum:@"0"];
//        }
//    }
    
    if (999 == alertView.tag) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            URequest *request = [[URequest alloc] initWithAddress:mAddress param:mParam];
            request.mPrompt = self.mPrompt;
            [request setRelink:NO];
            if (mDidFinishedSelector != nil) {
                [request setuDidFinishSelector:mDidFinishedSelector delegate:requestFinishedDelegate];
            } else if (requestFinishedDelegate != nil) {
                [request setuRequestFinishedDelegate:requestFinishedDelegate];
            }
            
            if (mDidFailedSelector != nil) {
                [request setuDidFailSelector:mDidFailedSelector delegate:requestFailedDelegate];
            } else if (requestFailedDelegate != nil) {
                [request setuRequestFailedDelegate:requestFailedDelegate];
            }
            
            if (mDidTimeOutSelector != nil) {
                [request setuDidTimeOutSelector:mDidTimeOutSelector delegate:requestTimeOutDelegate];
            } else if (requestTimeOutDelegate != nil) {
                [request setuRequestTimeOutDelegate:requestTimeOutDelegate];
            }
            [LTools startAsynchronous:request withController:(UIViewController *)requestFinishedDelegate];
        }
    }
    [self releaseSelf];
}
@end
