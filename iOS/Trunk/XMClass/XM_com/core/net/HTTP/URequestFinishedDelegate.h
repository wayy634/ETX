//
//  URequestFinishedDelegate.h
//  ASIHTTPRequestDemo
//
//  Created by HXG on 11-8-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol URequestFinishedDelegate <NSObject>

- (void)uRequestFinished:(NSDictionary *)_root;
@end
