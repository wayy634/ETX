//
//  LCRKAPITaskManager.h
//  LeCai
//
//  Created by HXG on 9/23/14.
//
//

#import <Foundation/Foundation.h>

@class LCRKAPITask;
@interface LCRKAPITaskManager : NSObject

+ (LCRKAPITaskManager *)sharedAPITaskManager;

- (void)addTask:(LCRKAPITask *)apiTask;
- (void)removeTask:(LCRKAPITask *)apiTask;
- (void)cancelAllTasks;

- (void)runTask:(LCRKAPITask *)apiTask;

@end
