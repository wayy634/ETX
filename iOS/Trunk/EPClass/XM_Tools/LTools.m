//
//  LTools.m
//  LeHeCai
//
//  Created by HXG on 11-9-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LTools.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>
#include <mach/mach.h>
#import "KeychainItemWrapper.h"
#import "LCRKAPITaskManager.h"
#import "MathFunction.h"
#import "KCommon.h"
#import "LAppConfig.h"
#import "UIAlertView+Block.h"
#import "LCRKAPITask.h"

#import "LCAPIResult.h"
#import "LCRKMappingData.h"

#import "LCWebViewVC.h"
#import "XMNavigationProcessC.h"

#define K_NETWORKSHOW_TAG_IMAGEVIEW 100000
#define K_NETWORKSHOW_TAG_LABEL 100001

static NSMutableArray      *kAllQueue; //唯一网络队列
static NSMutableArray      *kAllUnfinishedRequest; //所有的未完成的request
static NSMutableArray      *kUnfinishedRequestForBecame; //所有的未完成的request
static UIView              *kCoverView; //遮罩view
static NSMutableArray      *kAppDataArray;
static KeychainItemWrapper *kkeychainItemWrapper;
static NSMutableDictionary *kWholeDic;

XMBottomMenuV              *kBottomMenuV;

//static NSOperationQueue    *fileDownLoadQueue;
//static NSMutableDictionary *kAllMappingDictionary; //存储model的数组

double                      kDelayTime = 0;
BOOL                        kIsShow = NO;
BOOL                        kUpdataShow = NO;

@implementation LTools
#pragma mark -
#pragma mark Save system default file
//MARK: 可用内存
+ (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),HOST_VM_INFO,(host_info_t)&vmStats,&infoCount);
    if(kernReturn != KERN_SUCCESS) 
    {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}


//MARK: 已使用内存
+ (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

+ (void)setSecretObjectFromSystem:(id)object key:(NSString *)key {
    if (!kkeychainItemWrapper) {
        kkeychainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Account Number" accessGroup:nil];
    }
    [kkeychainItemWrapper setObject:object forKey:key];
}

+ (id)getSecretObjectFromSystemKey:(NSString *)key {
    if (!kkeychainItemWrapper) {
        kkeychainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Account Number" accessGroup:nil];
    }
	return [kkeychainItemWrapper objectForKey:key];
}

+ (void)setObjectFromSystem:(id)object key:(NSString *)key {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:object forKey:key];
	[defaults synchronize];
}

+ (id)getObjectFromSystemKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setClassSystem:(id)class key:(NSString*)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:class];
	[defaults setObject:data forKey:key];
	[defaults synchronize];
}

+ (id)getClassFromSystem:(NSString*)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)setWholeDicValue:(id)object key:(NSString*)key {
    if (!kWholeDic) {
        kWholeDic = [[NSMutableDictionary alloc] init];
    }
    [kWholeDic setObject:object forKey:key];
}

+ (id)getWholeDicForKey:(NSString*)key {
    if (!kWholeDic) {
        kWholeDic = [[NSMutableDictionary alloc] init];
    }
    return [kWholeDic objectForKey:key];
}
#pragma mark -
#pragma mark Save file
+ (void)writeFileWithContent:(NSString *)text
                    fileName:(NSString *)fileName
                     isCover:(BOOL)isCover {
	// file
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
	BOOL isExist = YES;
	if (![fileManager fileExistsAtPath:path]) {
		isExist = NO;
		[fileManager createFileAtPath:path contents:nil attributes:nil];
	}
	
	// write
	NSMutableData *writer = [[NSMutableData alloc] init];
	if (!isCover && isExist) {
		[writer appendData:[NSData dataWithContentsOfFile:path]];
	}
	[writer appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
	[writer writeToFile:path atomically:NO];
	[writer release];
	writer = nil;
}

+ (NSString *)readFileFromFileName:(NSString *)fileName {
	// file
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
	if (![fileManager fileExistsAtPath:path]) {
		return @"";
	}
	
	// read
	NSData *reader = [NSData dataWithContentsOfFile:path];
	NSString *str = [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
	return [str autorelease];
}

+ (NSMutableArray *)getAppData {
    if (!kAppDataArray) {
        kAppDataArray = [[NSMutableArray alloc] init];
    }
    return kAppDataArray;
}

#pragma mark -
#pragma mark Methods
+ (NSData*) base64Decode:(NSString *)string{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil) {
        return [NSData data];
    }
    
    ixtext = 0;
    tempcstring = (const unsigned char *)[string UTF8String];
    lentext = [string length];
    theData = [NSMutableData dataWithCapacity: lentext];
    ixinbuf = 0;
    
    while (true) {
        if (ixtext >= lentext){
            break;
        }
        
        ch = tempcstring [ixtext++];
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                } else {
                    ctcharsinbuf = 2;
                }
                ixinbuf = 3;
                flbreak = true;
            }
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                } 
            }
            
            if (flbreak) {
                break;
            } 
        }
    }
    return theData;
    
}



+ (NSString*) base64Encode:(NSData *)data

{
    
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
        
    };
    
    NSInteger length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    
    NSMutableString *result;
    lentext = [data length];
    
    if (lentext < 1)
        return @"";
    
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) 
            break;        
        for (i = 0; i < 3; i++) { 
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
            
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        
        switch (ctremaining) {
            case 1: 
                ctcopy = 2; 
                break;
                
            case 2: 
                ctcopy = 3; 
                break;
                
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        
        
        ixtext += 3;
        charsonline += 4;
        
        
        if ((length > 0) && (charsonline >= length))
            
            charsonline = 0;
        
    }     
    
    return result;
    
}
+ (NSString *)encodingString:(NSString *)text {
    NSArray *array = [[NSArray alloc] initWithObjects:
                      @"!", @",", @".", @";", @":", @"?", @"(", @")", @"[", @"]", @"~", @"&", @"@", @"#", @"$", @"%", @"^"
                      @"！", @"，", @"。", @"；", @"：", @"？", @"（", @"）,", @"【", @"】", @"～", @"￥", @"……", 
                      @"-", @"—", @"+", @"\\", @"{", @"}", @"/", @"|", @"<", @">", @"《", @"》", @"'", @"\"",
                      @"’", @"‘", @"“", @"”", @"_", @"€", @"£", @"¥", @"·", @"*", @"=",
                      nil];
    for (int i = 0; i < [array count]; i++) {
        if ([text rangeOfString:[array objectAtIndex:i]].location != NSNotFound) {
            NSString *string = [NSString stringWithFormat:@"%@@", [array objectAtIndex:i]];
            text = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                       (CFStringRef)text,
                                                                       NULL,
                                                                       (CFStringRef)string,
                                                                       kCFStringEncodingUTF8);
        }
    }
    [array release];
    return text;
}

+ (NSMutableString *)deleteString:(NSString *)text {
    NSArray *array = [[NSArray alloc] initWithObjects:
                      @"!", @",", @".", @";", @":", @"?", @"(", @")", @"[", @"]", @"~", @"&", @"@", @"#", @"$", @"%", @"^"
                      @"！", @"，", @"。", @"；", @"：", @"？", @"（", @"）,", @"【", @"】", @"～", @"￥", @"……", 
                      @"-", @"—", @"+", @"\\", @"{", @"}", @"/", @"|", @"<", @">", @"《", @"》", @"'", @"\"",
                      @"’", @"‘", @"“", @"”", @"_", @"€", @"£", @"¥", @"·", @"*", @"=",
                      nil];
    NSMutableString *str = [[[NSMutableString alloc] initWithString:text] autorelease];
    for (int i = 0; i < [array count]; i++) {
        if ([str rangeOfString:[array objectAtIndex:i]].location != NSNotFound) {
            NSMutableString *temp = [[NSMutableString alloc] init];
            
            [temp setString:[str substringToIndex:([str rangeOfString:[array objectAtIndex:i]].location)]];
            [temp appendString:[str substringFromIndex:([str rangeOfString:[array objectAtIndex:i]].location
                                                        + [str rangeOfString:[array objectAtIndex:i]].length)]];
            
            [str setString:temp];
            [temp release];
        }
    }
    [array release];
    return str;
}

+ (void)arrange:(NSMutableArray *)indexArray objectArray:(NSMutableArray *)objectArray {
    NSString *tempString;
    NSString *leftCompare;
    NSString *rightCompare;
    id        object0;
    id        object1;
    id        object2;
    for (int i = 0; i < [indexArray count]; i++) {
        for (int j = 0; j < [indexArray count]; j++) {
            leftCompare = [indexArray objectAtIndex:i];
            rightCompare = [indexArray objectAtIndex:j];
            object1 = [objectArray objectAtIndex:i];
            object2 = [objectArray objectAtIndex:j];
            if ([leftCompare intValue] < [rightCompare intValue]) {
                tempString = [indexArray objectAtIndex:i];
                object0 = [objectArray objectAtIndex:i];
                [indexArray replaceObjectAtIndex:i withObject:rightCompare];
                [indexArray replaceObjectAtIndex:j withObject:tempString];
                [objectArray replaceObjectAtIndex:i withObject:object2];
                [objectArray replaceObjectAtIndex:j withObject:object0];
            }
        }
    }
}

+ (void)MPArrange:(NSMutableArray *)data count:(int)arrayCount {
    int i=0;
    int j=0;
    int flag = 0;
    id temp0;
    id temp1;
    for(i=0;i< arrayCount - 1 ;i++)   /*外循环控制排序的总趟数*/
    {
        flag = 0;   /*本趟排序开始前，交换标志应为假*/
        for(j=arrayCount-1;j > i;j--) /*内循环控制一趟排序的进行*/
        {
            if([[data objectAtIndex:j] intValue] > [[data objectAtIndex:j-1] intValue]) /*相邻元素进行比较，若逆序就交换*/
            {
                temp0 = [data objectAtIndex:j];
                temp1 = [data objectAtIndex:j-1];
                [data replaceObjectAtIndex:j withObject:temp1];
                [data replaceObjectAtIndex:j-1 withObject:temp0];
                flag = 1;                  /*发生了交换，故将交换标志置为真*/
            }
            
        }
        if (flag == 0)  /*本趟排序未发生交换，提前终止算法*/
            break;
    }
}

+ (void)MPArrangeFromBigToSmall:(NSMutableArray *)data count:(NSInteger)arrayCount {
    int i=0;
    NSInteger j=0;
    int flag = 0;
    id temp0;
    id temp1;
    for(i=0;i< arrayCount - 1 ;i++)   /*外循环控制排序的总趟数*/
    {
        flag = 0;   /*本趟排序开始前，交换标志应为假*/
        for(j=arrayCount-1;j > i;j--) /*内循环控制一趟排序的进行*/
        {
            if([[data objectAtIndex:j] intValue] < [[data objectAtIndex:j-1] intValue]) /*相邻元素进行比较，若逆序就交换*/
            {
                temp0 = [data objectAtIndex:j];
                temp1 = [data objectAtIndex:j-1];
                [data replaceObjectAtIndex:j withObject:temp1];
                [data replaceObjectAtIndex:j-1 withObject:temp0];
                flag = 1;                  /*发生了交换，故将交换标志置为真*/
            }
            
        }
        if (flag == 0)  /*本趟排序未发生交换，提前终止算法*/
            break;
    }
}

+ (void)updateApp:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    exit(0);
}

+ (void)checkLocationImgAndRemove {
    NSString *AppPath=[NSHomeDirectory() stringByAppendingString:@"/Documents/Images/PermanentStore/"];
	NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:AppPath]) {
        NSArray *locationImgArray = [manager contentsOfDirectoryAtPath:AppPath error:nil];
        if ([locationImgArray count] > K_LOCATION_IMG_COUNT) {
            [manager removeItemAtPath:AppPath error:nil];
        }  
    }
}

+ (BOOL)isCorrectInputText:(NSString *)text regExp:(NSString *)regExp {
    BOOL isCorrect = NO;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    text = [text stringByTrimmingCharactersInSet:whitespace];
    
    if ([[NSPredicate predicateWithFormat:regExp] evaluateWithObject:text]) {
        isCorrect = YES;
    }
    return isCorrect;
}

+ (NSString *)trim:(NSString *)string {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    return [string stringByTrimmingCharactersInSet:whitespace];
}
+ (NSString *)trimManual:(NSString *)string {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    NSArray *array = [string componentsSeparatedByCharactersInSet:whitespace];
    
    return [array componentsJoinedByString:@""];
    
}
+ (NSString *)oldStrings:(NSString *)string addString:(NSString *)addString{
    NSMutableString *tempString = [NSMutableString stringWithFormat:@"%@",string];
    [tempString appendString:addString];
    
//    NSMutableString *tempString = [[NSMutableString alloc] initWithString:string];
//    [tempString appendString:addString];
//    return tempString;
    return tempString;
}

+ (BOOL)getImageFromLocal:(NSString*)name {
    NSString *appPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/Images/PermanentStore/"];
	NSFileManager *manager = [NSFileManager defaultManager];
	NSString *path = [NSString stringWithFormat:@"%@%@", appPath, name];
    return [manager fileExistsAtPath:path];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {  
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 - 8 characters
    if ([cString length] < 6) return nil;
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return nil;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark -
#pragma mark UI
+ (void)showLoadingVOnTargetView:(UIView *)targetView_ isLock:(BOOL)isLock_ animation:(BOOL)animation_ {
    [MBProgressHUD showHUDAddedTo:targetView_ isLock:isLock_ animated:animation_];
}

+ (void)hideLoadingVOnTargetView:(UIView *)targetView_ animation:(BOOL)animation_ {
    [MBProgressHUD hideHUDForView:targetView_ animated:animation_];
}

+ (void)animationEaseInEaseOut:(CALayer *)layer {
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setType:kCATransitionFade];
    [layer addAnimation:animation forKey:@"SEffect"];
}

+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:STRING(@"s_ok")
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    });
}

+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg baseController:(UIViewController *)baseController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (baseController && NSClassFromString(@"UIAlertController")) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:STRING(@"s_ok") style:UIAlertActionStyleCancel handler:NULL]];
            [baseController presentViewController:alertController animated:YES completion:NULL];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:STRING(@"s_ok")
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    });
}

+ (void)showAlertWithMessage:(NSString *)message completionBlock:(void(^)(NSInteger btnIndex))block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView showWithCompleteBlock:^(NSInteger btnIndex) {
            if (block != NULL) {
                block(btnIndex);
            }
        }];
        
        [alertView release];
    });
}


+ (void)setButton:(UIButton *)button
	  normalColor:(UIColor *)normalColor
 highlightedColor:(UIColor *)highlightColor {
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highlightColor forState:UIControlStateHighlighted];
}

+ (void)setButton:(UIButton *)button
	  normalImage:(NSString *)normalImageName
 HighlightedImage:(NSString *)HighlightedImage
	 pressedImage:(NSString *)pressedImageName {
	[button setBackgroundColor:[UIColor clearColor]];
	[button setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:HighlightedImage]  forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:pressedImageName]  forState:UIControlStateSelected];
}

+ (void)setButton:(UIButton *)button
	  normalImage:(NSString *)normalImageName
	 pressedImage:(NSString *)pressedImageName {
    [button setBackgroundColor:[UIColor clearColor]];
	[button setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:pressedImageName]  forState:UIControlStateHighlighted];
}


+ (void)setButton:(UIButton *)button
   normalImageMem:(UIImage *)normalImageName
  pressedImageMem:(UIImage *)pressedImageName {
    [button setBackgroundColor:[UIColor clearColor]];
	[button setBackgroundImage:normalImageName forState:UIControlStateNormal];
	[button setBackgroundImage:pressedImageName  forState:UIControlStateHighlighted];
}

+ (void)roundedRectangleView:(UIView *)view corner:(float)_corner width:(float)_width color:(UIColor *)_color {
    CALayer *layer = [view layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:_corner];
    [layer setBorderWidth:_width];
    [layer setBorderColor:[_color CGColor]];
}

+ (void)roundedRectangleView:(UIView *)view corner:(float)_corner color:(UIColor *)_color {
    CALayer *layer = [view layer];
//    [layer setMasksToBounds:YES];
    [layer setCornerRadius:_corner];
    [layer setBorderWidth:0.5];
    [layer setBorderColor:[_color CGColor]];
}

+ (void)roundedRectangleView:(UIView *)view {
	CALayer *layer = [view layer];
	[layer setMasksToBounds:YES];
    [layer setCornerRadius:8.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor grayColor] CGColor]];
}

+ (void)roundedRectangleView:(UIView *)_view  color:(UIColor *)_color {
	CALayer *layer = [_view layer];
    //	[layer setMasksToBounds:YES];
    [layer setCornerRadius:4.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[_color CGColor]];
}

+ (void)roundedRectangleView:(UIView *)_view  color:(UIColor *)_color radius:(float)_radius {
	CALayer *layer = [_view layer];
    //	[layer setMasksToBounds:YES];
    [layer setCornerRadius:_radius];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[_color CGColor]];
    layer.shadowColor = [[UIColor redColor] CGColor];
}
+ (void)roundedRectangleViewWithShadow:(UIView *)view {
    CALayer *layer = [view layer];
    [layer setMasksToBounds:NO];
    [layer setCornerRadius:8.0]; 
    [layer setShadowColor:[[UIColor blackColor] CGColor]];  
    [layer setShadowOffset:CGSizeMake(0, -1)];  
    [layer setShadowOpacity:1.0];  
    [layer setShadowRadius:1.0]; 
}

+ (void)animationView:(UIView *)aView fromFrame:(CGRect)fromFrame
			  toFrame:(CGRect)toFrame
				delay:(float)delayTime
			 duration:(float)durationTime {
	
	[aView setFrame:fromFrame];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		// UIViewAnimationCurveEaseOut:  slow at end
	[UIView setAnimationDelay:delayTime];						// delay Animation
	[UIView setAnimationDuration:durationTime];
	[aView setFrame:toFrame];
	[UIView commitAnimations];
}

+ (void)animationView:(UIView *)aView
				fromY:(float)fromY
				  toY:(float)toY
			 duration:(float)durationTime {
	
	[aView setFrame:CGRectMake(aView.frame.origin.x, fromY, aView.frame.size.width, aView.frame.size.height)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		// UIViewAnimationCurveEaseOut:  slow at end
	[UIView setAnimationDelay:0.0f];                            // delay Animation
	[UIView setAnimationDuration:durationTime];
	[aView setFrame:CGRectMake(aView.frame.origin.x, toY, aView.frame.size.width, aView.frame.size.height)];
	[UIView commitAnimations];
}

+ (void)animationView:(UIView *)aView
				fromX:(float)fromX
				fromY:(float)fromY
				  toX:(float)toX
				  toY:(float)toY
				delay:(float)delayTime
			 duration:(float)durationTime {
	
	[aView setFrame:CGRectMake(fromX, fromY, aView.frame.size.width, aView.frame.size.height)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];		// UIViewAnimationCurveEaseOut:  slow at end
	[UIView setAnimationDelay:delayTime];						// delay Animation
	[UIView setAnimationDuration:durationTime];
	[aView setFrame:CGRectMake(toX, toY, aView.frame.size.width, aView.frame.size.height)];
	[UIView commitAnimations];
}

+ (void)animationView:(UIView *)aView
				fromX:(float)fromX
				fromY:(float)fromY
				  toX:(float)toX
				  toY:(float)toY
              toScale:(float)toScale  
              toAlpha:(float)toAlpha
				delay:(float)delayTime
			 duration:(float)durationTime {
	[aView setFrame:CGRectMake(fromX, fromY, aView.frame.size.width, aView.frame.size.height)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];		// UIViewAnimationCurveEaseOut:  slow at end
	[UIView setAnimationDelay:delayTime];						// delay Animation
	[UIView setAnimationDuration:durationTime];
	[aView setFrame:CGRectMake(toX, toY, aView.frame.size.width, aView.frame.size.height)];
    aView.transform = CGAffineTransformMakeScale(toScale, toScale);
    aView.alpha = toAlpha;
	[UIView commitAnimations];
}

+ (UIView *)getCoverView {
    if (kCoverView != nil) {
        return kCoverView;
    }
    return nil;
}

#pragma mark -
#pragma mark HTTP
+ (void)startAsynchronousUrl:(NSString *)_url parameter:(NSMutableDictionary *)_parameter method:(NSString *)_method delegate:(id)_delegate allowCancel:(BOOL)_allowCancel mappingName:(NSString *)_mappingName urlCacheMode:(BOOL)_urlCacheMode finishSelector:(SEL)_finishSEL failSelector:(SEL)_failSEL timeOutSelector:(SEL)_timeOutSEL {
    
    LCRKHttpMethod httpMethod = LCRKHttpMethodGET;
    if ([_method isEqualToString:@"POST"]) {
        httpMethod = LCRKHttpMethodPOST;
    } else if ([_method isEqualToString:@"PUT"]) {
        httpMethod = LCRKHttpMethodPUT;
    } else if ([_method isEqualToString:@"POSTBODY"]) {
        httpMethod = LCRKHttpMethodPostBody;
    }
    
    [LCRKAPITask runTaskWithURI:_url
                         params:_parameter
                         method:httpMethod
                       delegate:_delegate
                    allowCancel:_allowCancel
              resultMappingName:_mappingName
                   urlCacheMode:_urlCacheMode
               finishedSelector:_finishSEL
                 failedSelector:_failSEL
                timeoutSelector:_timeOutSEL
                 cancelSelector:nil];
}

+ (ASINetworkQueue *)getNetWorkQueue {
    if ([kAllQueue objectAtIndex:0] != nil || [[(ASINetworkQueue *)[kAllQueue objectAtIndex:0] operations] count] != 0) {
        return [kAllQueue objectAtIndex:0];
    }
    return nil;
}

//default
+ (UIImage *)getImage:(NSString *)imageName defaultImageName:(NSString *)defaultImageName {
    if ([LTools getImageFromLocal:imageName]) {
        NSString *appPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/Images/PermanentStore/"];
        NSString *path = [NSString stringWithFormat:@"%@%@", appPath, imageName];
        return [UIImage imageWithContentsOfFile:path];
        
    } else {
        return [UIImage imageNamed:defaultImageName];
    }
}

+ (UIImage *)setRespondView:(UIView *)theView defaultImageName:(NSString *)defaultImageName imageName:(NSString *)name {
    if ([LTools getImageFromLocal:name]) {
        for (UIView *temp in theView.subviews) {
            if (temp.tag == 99) {
                [((UIActivityIndicatorView *)temp) stopAnimating];
                [((UIActivityIndicatorView *)temp) removeFromSuperview];
                if ([((UIActivityIndicatorView *)temp) retainCount] > 0) {
                    [((UIActivityIndicatorView *)temp) release];
                }
            }
        }
        NSString *appPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/Images/PermanentStore/"];
        NSString *path = [NSString stringWithFormat:@"%@%@", appPath, name];
        return [UIImage imageWithContentsOfFile:path];
    } else {
        for (UIView *temp in theView.subviews) {
            if (temp.tag == 99) {
                return nil;
            }
        }
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicatorView.tag = 99;
        CGRect rect = theView.frame;
		rect.origin.x = (rect.size.width - 37) / 2;
		rect.origin.y = (rect.size.height - 37) / 2;
		rect.size.width = 37;
		rect.size.height = 37;
		[activityIndicatorView setFrame:rect];
		activityIndicatorView.hidden = NO;
		[activityIndicatorView startAnimating];
        [theView addSubview:activityIndicatorView];
        return [UIImage imageNamed:defaultImageName];
    }
}

+ (NSMutableArray *)getUnfinishedUrequest {
    if (!kAllUnfinishedRequest) {
        kAllUnfinishedRequest = [[NSMutableArray alloc] init];
    }
    return kAllUnfinishedRequest;
}

+ (NSMutableArray *)getUnfinishedUrequestForBecame {
    if (!kUnfinishedRequestForBecame) {
        kUnfinishedRequestForBecame = [[NSMutableArray alloc] init];
    }
    return kUnfinishedRequestForBecame;
}

+ (void)startAsynchronous:(URequest *)request {
    [[request getRequest] startAsynchronous];
}

+ (void)startAsynchronous:(URequest *)request withController:(UIViewController *)controller {
    [request setuDelegate:controller];
    [request setShowActivityIndicatorView:controller.view];
	[LTools startAsynchronous:request];
}

+ (void)startAsynchronous:(URequest *)request withController:(id)controller withView:(UIView *)view {
    [request setuDelegate:controller];
    [request setRespondImageView:view];
    [request setShowActivityIndicatorView:view];
	[LTools startAsynchronous:request];
}

+ (void)beCameStartAsynchronous:(URequest *)request withController:(id)controller {
    [request setuDelegate:controller];
    [[request getRequest] startAsynchronous];
}

+ (void)cancelRequest:(URequest *)request {
    [[request getRequest] clearDelegatesAndCancel];
}

+ (void)cancelUnfinishedRequest {
    [[LCRKAPITaskManager sharedAPITaskManager] cancelAllTasks];
    [[LTools getUnfinishedUrequest] removeAllObjects];
}

+ (void)cancelUnfinishedRequestForBecame {
    if ([[LTools getUnfinishedUrequestForBecame] count] > 0) {
		for (int i = 0; i < [[LTools getUnfinishedUrequestForBecame] count]; i++) {
			URequest *tempRequest = [[LTools getUnfinishedUrequestForBecame] objectAtIndex:i];
			if ([tempRequest getRrequestType] == RequestTypeText) {
                [tempRequest removeUIActivityIndicatorView];
                [LTools cancelRequest:tempRequest];
                
            }
		}	
    }
    [[LTools getUnfinishedUrequestForBecame] removeAllObjects];
}

+ (void)startQueue:(NSMutableArray *)array 
       setMaxCount:(int)count
    withController:(id)controller 
setCancelAllOnFail:(BOOL)isUse {
    ASINetworkQueue *tempQueue = [ASINetworkQueue queue];
    [tempQueue setShouldCancelAllRequestsOnFailure:isUse];
    [tempQueue setMaxConcurrentOperationCount:count];
    for (int i = 0; i < [array count]; i++){
        URequest *tempURequest = (URequest *)[array objectAtIndex:i];
        [tempURequest setuDelegate:controller];
        [[LTools getUnfinishedUrequest] addObject:tempURequest];
        [tempQueue addOperation:[tempURequest getRequest]];
    }
    [[LTools getQueueArray] addObject:tempQueue];
    [tempQueue go];
}

+ (NSMutableArray *)getQueueArray {
    if (!kAllQueue) {
		kAllQueue = [[NSMutableArray alloc] init];
	}
	return kAllQueue;
}

+ (BOOL)isAPIJsonError:(LCAPIResult*)_object {
    BOOL isError = NO;
    if (_object == nil || [_object isEqual:[NSNull null]]) {
        isError = YES;
    } else {
        isError = (_object.success == 0) ? NO : YES;
    }
    return isError;
}

+ (NSString *)checkAPIJsonIsError:(LCAPIResult *)root {
	if (root == nil || [root isEqual:[NSNull null]]) {
        return @"服务器错误";
	} else {
        if (root.code == 0) {
            return nil;
            
        } else {
            return root.msg;
        }
	}
}

+ (BOOL)isJsonError:(NSDictionary *)root {
    BOOL isError = NO;
    if (root == nil || [root isEqual:[NSNull null]]) {
        isError = YES;
    } else {
        int status = [[root objectForKey:@"code"] intValue];
        isError = (status == 0) ? NO : YES;
    }
    return isError;
    
}

+ (NSString *)checkJsonIsError:(NSDictionary *)root {
	if (root == nil || [root isEqual:[NSNull null]]) {
        return @"服务器错误";
		//return [NSString stringWithString:@"服务器错误"];
	} else {
        int code = [[root objectForKey:@"code"] intValue];
        if (code == 0) {
            return nil;
            
        } else {
            return [root objectForKey:@"message"];
        }
	}
}

#pragma mark -
#pragma mark MD5 | Sign | time stamp
+ (NSString *)md5:(NSString *)source {  
	const char *cStr = [source UTF8String];  
	unsigned char result[CC_MD5_DIGEST_LENGTH];  
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	
	NSMutableString *hash = [NSMutableString string];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[hash appendFormat:@"%02X",result[i]];
	}
	return [hash lowercaseString];
}

+ (void)mathTimeDelay:(double)_serverTime {
    NSDate *localTime = [NSDate date];
//    NSDateFormatter *tempDateFormatter = [[NSDateFormatter alloc] init];
//    [tempDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [tempDateFormatter setTimeZone:timeZone];
    kDelayTime = _serverTime - ([localTime timeIntervalSince1970]*1000);
    [LTools setObjectFromSystem:[NSString stringWithFormat:@"%f",kDelayTime] key:K_KEY_DELAY_TIME];
}

+ (NSString *)timeStamp {
	NSDate *now = [NSDate date];
    kDelayTime = [[LTools getObjectFromSystemKey:K_KEY_DELAY_TIME] doubleValue];
	NSString *timeStamp = [NSString stringWithFormat:@"%.f", ((double)[now timeIntervalSince1970]*1000 + kDelayTime)];
	return timeStamp;
}

+ (NSString *)signString:(NSString *)source {
//	NSString *timeStamp = [LTools timeStamp];
////    NSString *userPassword = [LTools getObjectFromSystemKey:K_KEY_LOGIN_PASSWD]; // 其他项目中需要修改
////    NSString *appsecret = [LTools md5:[NSString stringWithFormat:@"%@%@", userPassword, timeStamp]];
//    //    DLog(@"appsecret:%@",appsecret);
//    
//	NSString *sortString = [NSString stringWithFormat:@"appsecret=%@&%@&timestamp=%@",
//                            appsecret,
//                            source,
//                            timeStamp];
//	NSArray *sortArray = [[sortString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
//	NSMutableString *kvString = [NSMutableString stringWithCapacity:10];
//	for (NSString *string in sortArray) {
//        if([kvString isEqualToString:@""]) {
//            [kvString appendFormat:@"%@",string];
//        } else {
//            [kvString appendFormat:@"&%@",string];
//        }
//	}
//	NSString *signString = [[LTools md5:kvString] uppercaseString];
//	
//	NSString *postStr = [NSString stringWithFormat:@"sign=%@&%@&timestamp=%@", signString, source, timeStamp];
	return @"";
}

+ (NSString *)upperMD5ForImg:(NSString *)source {
    const char *cStr = [source UTF8String];  
	unsigned char result[CC_MD5_DIGEST_LENGTH];  
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	
	NSMutableString *hash = [NSMutableString string];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[hash appendFormat:@"%02X",result[i]];
	}
    [hash uppercaseString];
    NSString *tempString = [NSString stringWithFormat:@"%@",[LTools oldStrings:hash addString:@".png"]];
	return tempString;
}

+ (NSString *)upperMD5ForImgNoSuffix:(NSString *)source {
    const char *cStr = [source UTF8String];  
	unsigned char result[CC_MD5_DIGEST_LENGTH];  
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	
	NSMutableString *hash = [NSMutableString string];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[hash appendFormat:@"%02X",result[i]];
	}
    [hash uppercaseString];
    NSString *tempString = [NSString stringWithFormat:@"%@",[LTools oldStrings:hash addString:@""]];
	return tempString;
}

+ (NSString *)macAddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    // NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X", 
    //                       *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

#pragma mark -
#pragma mark Application data
+ (void)popController {
    [self popControllerAnimated:YES];
}

+ (void)popControllerAnimated:(BOOL)animated {
    [APP_DELEGATE.mNavigationController popViewControllerAnimated:animated];
}

+ (void)popToRootViewControllerAnimated:(BOOL)animated {
    [APP_DELEGATE.mNavigationController popToRootViewControllerAnimated:animated];
}

+ (void)pushController:(UIViewController *)controller animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [APP_DELEGATE.mNavigationController pushViewController:controller animated:animated];
    });
}

+ (void)pushControllerFromURLScheme:(UIViewController *)controller animated:(BOOL)animated {
    UIViewController *topController = [APP_DELEGATE.mNavigationController topViewController];
    if ([NSStringFromClass([topController class]) isEqualToString:NSStringFromClass([controller class])]) {
        return;
    }
    [self pushController:controller animated:animated];
}
+ (CGSize)sizeForText:(UILabel *)label_ isLabelWidth:(BOOL)_isLabelWidth {
//    if ([NSString instancesRespondToSelector:@selector(sizeWithAttributes:)]) {
//        CGRect textRect = CGRectZero;
//        NSRange range = NSMakeRange(0, label_.attributedText.length);
//        NSDictionary *dic = [label_.attributedText attributesAtIndex:0 effectiveRange:&range];
//        textRect = [[label_ text] boundingRectWithSize:CGSizeMake(label_.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];//[[label_ text] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label_.font,NSFontAttributeName, nil]];
//        return CGSizeMake(textRect.size.width, ceilf(textRect.size.height));
//    } else {
        CGSize textSize = CGSizeZero;
    textSize = [[label_ text] sizeWithFont:label_.font constrainedToSize:CGSizeMake(_isLabelWidth ? label_.width : CGFLOAT_MAX, CGFLOAT_MAX)];
        textSize.height = ceilf(textSize.height);
        return textSize;
//    }
//    return CGSizeZero;
}

+ (BOOL)isGreatherThanIOS7 {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        return YES;
    }
    return NO;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image_ scaledToSize:(CGSize)newSize_ {
    UIGraphicsBeginImageContext(newSize_);
    [image_ drawInRect:CGRectMake(0,0,newSize_.width,newSize_.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)changeTimeType:(NSString *)type_ time:(long)time_ {
    NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [inputFormatter setDateFormat:(type_ ?  type_ : @"yyyy-MM-dd HH:mm:ss")];
    return [inputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time_]];
}

+ (void)showNetWorkFail:(UIView *)view_ image:(NSString *)image_ msg:(NSString *)msg_ {
    UIImage *image = [UIImage imageNamed:image_ ? image_ : @"Icon_Network_Fail.png"];
    UIImageView *backGroundImageV = [[[UIImageView alloc] initWithImage:image] autorelease];
    [backGroundImageV setBackgroundColor:[UIColor clearColor]];
    backGroundImageV.userInteractionEnabled = NO;
    [backGroundImageV setFrame:CGRectMake((view_.width - image.size.width)/2, 100, image.size.width, image.size.height)];
    UILabel *msgLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, backGroundImageV.bottom + 10, view_.width, 20)] autorelease];
    msgLabel.userInteractionEnabled = NO;
    [msgLabel setBackgroundColor:[UIColor clearColor]];
    [msgLabel setText:msg_];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    [msgLabel setTextColor:K_COLOR_MAIN_FONT];
    [msgLabel setFont:K_FONT_SIZE(14)];
    backGroundImageV.tag = K_NETWORKSHOW_TAG_IMAGEVIEW;
    msgLabel.tag = K_NETWORKSHOW_TAG_LABEL;
    [view_ addSubview:backGroundImageV];
    [view_ addSubview:msgLabel];
}

+ (void)disappearNetWorkFail:(UIView *)view_ {
    UIView *tempImageV = [view_ viewWithTag:K_NETWORKSHOW_TAG_IMAGEVIEW];
    UIView *tempLabel = [view_ viewWithTag:K_NETWORKSHOW_TAG_LABEL];
    if (tempImageV && tempLabel) {
        [tempImageV removeFromSuperview];
        [tempLabel removeFromSuperview];
    }
}

+ (void)setKisShow:(BOOL)_isShow {
    kIsShow = _isShow;
}

+ (BOOL)getKIsShow {
    return kIsShow;
}

+ (void)setUpdataShow:(BOOL)updataShow_ {
    kUpdataShow = updataShow_;
}

+ (BOOL)getKUpdataShow {
    return kUpdataShow;
}

+ (NSString *)getURL:(NSString *)_url {
    NSMutableString *url = [[NSMutableString alloc] initWithString:_url];
    NSMutableString *returnURL = [[[NSMutableString alloc] init] autorelease];
    if ([url rangeOfString:@"#"].location != NSNotFound) {
        if ([[[url componentsSeparatedByString:@"#"] objectAtIndex:0] rangeOfString:@"?"].location != NSNotFound) {
            [returnURL appendString:[[url componentsSeparatedByString:@"#"] objectAtIndex:0]];
            [returnURL appendString:[NSString stringWithFormat:@"&backURL=%@#",K_BACK_URL]];
            for (int i = 1; i < [[url componentsSeparatedByString:@"#"] count]; i++) {
                [returnURL appendString:[[url componentsSeparatedByString:@"#"] objectAtIndex:i]];
                [returnURL appendString:@"#"];
            }
            [returnURL deleteCharactersInRange:NSMakeRange(returnURL.length - 1, 1)];
        } else {
            [returnURL appendString:[[url componentsSeparatedByString:@"#"] objectAtIndex:0]];
            [returnURL appendString:[NSString stringWithFormat:@"?backURL=%@#",K_BACK_URL]];
            for (int i = 1; i < [[url componentsSeparatedByString:@"#"] count]; i++) {
                [returnURL appendString:[[url componentsSeparatedByString:@"#"] objectAtIndex:i]];
                [returnURL appendString:@"#"];
            }
            [returnURL deleteCharactersInRange:NSMakeRange(returnURL.length - 1, 1)];
        }
    } else {
        [returnURL appendString:url];
        if ([url rangeOfString:@"?"].location != NSNotFound) {
            [returnURL appendString:[NSString stringWithFormat:@"&backURL=%@#",K_BACK_URL]];
        } else {
            [returnURL appendString:[NSString stringWithFormat:@"?backURL=%@#",K_BACK_URL]];
        }
        [returnURL deleteCharactersInRange:NSMakeRange(returnURL.length - 1, 1)];
    }
    [url release] , url = nil;
    return returnURL;
}
@end