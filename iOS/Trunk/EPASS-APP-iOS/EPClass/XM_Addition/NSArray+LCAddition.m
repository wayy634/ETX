//
//  NSArray+LCAddition.m
//  LeCai
//
//  Created by HXG on 3/10/15.
//
//

#import "NSArray+LCAddition.h"

@implementation NSArray (LCAddition)

- (id)safeObjectAtIndex:(NSUInteger)index_ {
    if (index_ < [self count]) {
        return [self objectAtIndex:index_];
    }
    return nil;
}

@end

@implementation NSMutableArray (LCAddition)

- (void)replaceObjectAtIndexSafely:(NSUInteger)index_ withObject:(id)anObject_ {
    if (index_ < [self count] && anObject_) {
        [self replaceObjectAtIndex:index_ withObject:anObject_];
    }
}

@end
