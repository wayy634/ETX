//
//  XMThreadCountDownManager.m
//  XiaoMai
//
//  Created by Jeanne on 15/5/4.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMThreadCountDownManager.h"
@interface XMThreadCountDownManager () {
    NSMutableArray *mCountDownArray;
    BOOL            mIsRun;
}
@end

@implementation XMThreadCountDownManager
+ (XMThreadCountDownManager *)sharedXMThreadCountDownManager {
    static XMThreadCountDownManager *sharedXMThreadCountDownManager = nil;
    static dispatch_once_t threadOnceToken;
    dispatch_once(&threadOnceToken, ^{
        sharedXMThreadCountDownManager = [[XMThreadCountDownManager alloc] init];
    });
    return sharedXMThreadCountDownManager;
}

- (NSMutableArray *)mCountDownArray {
    if (!mCountDownArray) {
        mCountDownArray = [[NSMutableArray alloc] init];
    }
    return mCountDownArray;
}

- (void)eachOneFuction {
    for (int i = 0; i < [self mCountDownArray].count; i++) {
        NSArray *objectArray = [[self mCountDownArray] objectAtIndex:i];
//        if ([objectArray objectAtIndex:0] == nil || ((NSObject *)[objectArray objectAtIndex:0]).retainCount == 0) {
//            [[self mCountDownArray] removeObjectAtIndex:i];
//            i--;
//            continue;
//        }
        if ([objectArray objectAtIndex:0] != nil && [[objectArray objectAtIndex:0] respondsToSelector:NSSelectorFromString([objectArray lastObject])]) {
            [[objectArray objectAtIndex:0] performSelector:NSSelectorFromString([objectArray lastObject])];
        }
    }
//    for (NSArray *object in [self mCountDownArray]) {
//    }
}

- (void)addToThread:(id)class_ fuction:(SEL)sel_ {
    [[self mCountDownArray] addObject:@[class_,NSStringFromSelector(sel_)]];
    [self resumeThread];
}

- (void)addCheckToThread:(id)class_ fuction:(SEL)sel_ {
    for (int i = 0; i < [self mCountDownArray].count; i++) {
        if ([[[self mCountDownArray] objectAtIndex:i] objectAtIndex:0] == class_ && [NSStringFromSelector(sel_) isEqualToString:[[[self mCountDownArray] objectAtIndex:i] lastObject]]) {
            return;
        }
    }
    [self addToThread:class_ fuction:sel_];
}

- (void)removeFromThread:(id)class_ fuction:(SEL)sel_ {
    
    if ([[self mCountDownArray] containsObject:@[class_,NSStringFromSelector(sel_)]]) {
        [[self mCountDownArray] removeObject:@[class_,NSStringFromSelector(sel_)]];
        if ([[self mCountDownArray] count] == 0) {
            [self suspendThread];
        }
    }
}

- (void)removeAll {
    [[self mCountDownArray] removeAllObjects];
//    dispatch_release(self.mQueue);
//    dispatch_release(self.mTimer);
    [self suspendThread];
}

- (void)runThread {
    self.mQueue = dispatch_queue_create("countDown", NULL);
    self.mTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.mQueue);
    dispatch_source_set_timer(self.mTimer, dispatch_walltime(DISPATCH_TIME_NOW, 0), 1*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.mTimer, ^{
        [self eachOneFuction];
    });
}

- (void)resumeThread {
    if ([[self mCountDownArray] count] > 0 && !mIsRun) {
        dispatch_resume(self.mTimer);
        mIsRun = YES;
    }
}

- (void)suspendThread {
    if (mIsRun) {
        dispatch_suspend(self.mTimer);
        mIsRun = NO;
    }
}
@end
