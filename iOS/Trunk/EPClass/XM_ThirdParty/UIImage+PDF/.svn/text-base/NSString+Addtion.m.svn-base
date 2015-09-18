//
//  NSString+Addtion.m
//  PDFIMageTEST
//
//  Created by Jeanne on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "NSString+Addtion.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Addtion)
- (NSString *)MD5 {
    const char *cStr = [((NSString *)self) UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *hash = [NSMutableString string];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash lowercaseString];
}
@end
