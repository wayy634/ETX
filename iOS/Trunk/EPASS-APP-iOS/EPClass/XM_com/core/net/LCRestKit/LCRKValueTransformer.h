//
//  LCRKValueTransformer.h
//  LCRestKit
//
//  Created by HXG on 9/15/14.
//  Copyright (c) 2014 LeCai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LCRKValueTransformer <NSObject>

@required
- (id)transformTargetValueFromOrigin:(id)originValue;

@end
