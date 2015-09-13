//
//  Created by dengfang on 11-11-08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TKGlobal.h"


@implementation TKGlobal


+ (NSString*) fullBundlePath:(NSString*)bundlePath{
	return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundlePath];
}



@end
