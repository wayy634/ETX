//
//  LCRKAPITaskManager.m
//  LeCai
//
//  Created by HXG on 9/23/14.
//
//

#import "LCRKAPITaskManager.h"
#import "LCRKAPITask.h"

@interface LCRKAPITask (LCRKAPITaskPrivate)

- (void)run;

@end

@interface LCRKAPITaskManager ()

@property (nonatomic, strong) NSMutableArray *cachedTasks;

@end

@implementation LCRKAPITaskManager

+ (LCRKAPITaskManager *)sharedAPITaskManager
{
    static LCRKAPITaskManager *_sharedAPITaskManager = nil;
    static dispatch_once_t apiTaskOnceToken;
    dispatch_once(&apiTaskOnceToken, ^{
        _sharedAPITaskManager = [[LCRKAPITaskManager alloc] init];
    });
    return _sharedAPITaskManager;
}

- (void)dealloc
{
    [self cancelAllTasks];
    self.cachedTasks = nil;
    [super dealloc];
}

- (NSMutableArray *)cachedTasks
{
    if (!_cachedTasks) {
        self.cachedTasks = [NSMutableArray array];
    }
    
    return _cachedTasks;
}

- (void)addTask:(LCRKAPITask *)apiTask
{
    if (apiTask) {
        [self.cachedTasks addObject:apiTask];
    }
}

- (void)removeTask:(LCRKAPITask *)apiTask
{
    [self.cachedTasks removeObject:apiTask];
}

- (void)removeAllTasks
{
    [self.cachedTasks removeAllObjects];
}

- (void)cancelAllTasks
{
    for (LCRKAPITask *apiTask in self.cachedTasks) {
        [apiTask cancelTask];
    }
    
    [self removeAllTasks];
}

- (void)runTask:(LCRKAPITask *)apiTask
{
    if ([apiTask shouldCancelOtherTask]) {
        [self cancelAllTasks];
    }
    
    if ([apiTask shouldAddToCancellationTaskQueue]) {
        [self addTask:apiTask];
    }
    
    [apiTask run];
}

@end
