//
//  XMCacheManager.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/6/29.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

#define K_CACHE_SHOPPINGCART                @"ShoppingCart"
#define K_CACHE_ACCOUNTINFO                 @"AccountInfo"
#define K_CACHE_CITY                        @"City"
#define K_CACHE_INVITATION_FRIEND           @"InvitationFriend"
#define K_CACHE_CATEGORY_ARRAY              @"CategoryArray"
#define K_CACHE_CATEGORYLIST_DIC            @"CategoryListDataDictinary"
#define K_CACHE_HOMEPAGE                    @"homePage"

typedef void(^getDataByCache)(id data);
typedef void(^refreshData)(void);

@interface XMCacheManager : NSObject

+ (XMCacheManager *)shareCacheManager;
//保存缓存对象
- (void)saveClassCache:(id)data_ key:(NSString *)key_;
//获取缓存对象并且控制页面的刷新
- (void)getClassCacheByKey:(NSString *)key_ autoRefresh:(BOOL)flag_ dataByCache:(getDataByCache)dataByCache_ refreshData:(refreshData)refreshData_;
//去缓存对象
- (id)getClassCache:(NSString *)_key;

- (void)saveObjectCache:(id)data_ key:(NSString *)key_;

- (id)getObjectCache:(NSString *)key_;

@end
