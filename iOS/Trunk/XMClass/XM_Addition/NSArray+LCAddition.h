//
//  NSArray+LCAddition.h
//  LeCai
//
//  Created by HXG on 3/10/15.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (LCAddition)

- (id)safeObjectAtIndex:(NSUInteger)index_;

@end

@interface NSMutableArray (LCAddition)

- (void)replaceObjectAtIndexSafely:(NSUInteger)index_ withObject:(id)anObject_;

@end