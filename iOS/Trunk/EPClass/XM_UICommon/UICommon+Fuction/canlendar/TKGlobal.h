//
//  Created by dengfang on 11-11-08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TKBUNDLE(_URL) [TKGlobal fullBundlePath:_URL]

@interface TKGlobal : NSObject {

}


+ (NSString*) fullBundlePath:(NSString*)bundlePath;


@end
