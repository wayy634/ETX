//
//  Created by dengfang on 11-11-08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TKCategory)



- (UIImage *) imageCroppedToRect:(CGRect)rect;
- (UIImage *) squareImage;


- (void) drawInRect:(CGRect)rect withImageMask:(UIImage*)mask;

- (void) drawMaskedColorInRect:(CGRect)rect withColor:(UIColor*)color;
- (void) drawMaskedGradientInRect:(CGRect)rect withColors:(NSArray*)colors;


+ (UIImage*) imageNamedTK:(NSString*)path;

@end

