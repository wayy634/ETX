//
//  LCUncaughtExceptionHandler.h
//  LeCai
//
//  Created by lehecaiminib on 13-3-27.
//
//

#import <Foundation/Foundation.h>

@interface LCUncaughtExceptionHandler : NSObject {
    
}
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler*)getHandler;
@end
