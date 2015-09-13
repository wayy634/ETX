//
//  RKMappingResult.h
//  LeCai
//
//  Created by HXG on 9/24/14.
//
//

#import <Foundation/Foundation.h>

@interface RKMappingResult : NSObject

@property (nonatomic, strong) id firstObject;

- (instancetype)initWithFirstObject:(id)aObject;
+ (instancetype)resultWithFirstObject:(id)aObject;

@end
