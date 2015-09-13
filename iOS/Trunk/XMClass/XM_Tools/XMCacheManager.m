//
//  XMCacheManager.m
//  XiaoMai
//
//  Created by chenzb on 15/6/29.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//


@implementation XMCacheManager

+ (XMCacheManager *)shareCacheManager {
    static XMCacheManager *_shareCacheManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareCacheManager = [[XMCacheManager alloc] init];
    });
    return _shareCacheManager;
}
//保存缓存对象
- (void)saveClassCache:(id)data_ key:(NSString *)key_ {
    [self setClassSystem:data_ key:key_];
}

- (void)getClassCacheByKey:(NSString *)key_ autoRefresh:(BOOL)flag_ dataByCache:(getDataByCache)dataByCache_ refreshData:(refreshData)refreshData_ {
    NSArray *array = [self getClassFromSystem:key_];
    if(array){
        dataByCache_(array);
        if (flag_) {
            refreshData_();
        }
    }else{
        refreshData_();
    }
}

- (id)getClassCache:(NSString *)_key{
    return [LTools getClassFromSystem:_key];
}

- (void)saveObjectCache:(id)data_ key:(NSString *)key_ {
    [self setObjectFromSystem:data_ key:key_];
}
- (id)getObjectCache:(NSString *)key_ {
    return [self getObjectFromSystemKey:key_];
}
#pragma NSUserDefaults 存储
- (void)setObjectFromSystem:(id)object key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

- (id)getObjectFromSystemKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
#pragma mark  对象的存储
- (void)setClassSystem:(id)class key:(NSString*)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:class];
    [defaults setObject:data forKey:key];
    [defaults synchronize];
}

- (id)getClassFromSystem:(NSString*)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
