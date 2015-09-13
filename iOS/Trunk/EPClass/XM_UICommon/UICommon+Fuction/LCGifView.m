//
//  LCGifView.m
//  LeCai
//
//  Created by lehecaiminib on 14-12-19.
//
//

#import "LCGifView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LCGifView

- (id)initWithFrame:(CGRect)frame filePathName:(NSString *)filePathName {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *alphaV = [[UIView alloc] initWithFrame:self.frame];
        [alphaV setBackgroundColor:[UIColor whiteColor]];
        [alphaV setAlpha:0.8];
        [self addSubview:alphaV];
        [alphaV release] , alphaV = nil;
        
        contentV = [[UIView alloc] initWithFrame:CGRectMake(0,0,K_SCREEN_WIDTH,K_SCREEN_HEIGHT)];
        [self addSubview:contentV];
        
        UILabel *prompt = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 100)/2, contentV.bottom + 10, 100, 20)];
        [prompt setTextAlignment:NSTextAlignmentCenter];
        [prompt setFont:K_FONT_SIZE(12)];
        [prompt setText:@"加载中..."];
        [prompt setTextColor:[UIColor blackColor]];
        [self addSubview:prompt];
        [prompt release] , prompt = nil;
        
        NSDictionary *gifLoopCount = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
        gifProperties = [[NSDictionary dictionaryWithObject:gifLoopCount forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
        NSString *path = [[NSBundle mainBundle] pathForResource:filePathName ofType:@"gif"];
        gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], (CFDictionaryRef)gifProperties);
        count =CGImageSourceGetCount(gif);
        
    }
    [self setHidden:YES];
    return self;
}

+ (LCGifView *)gifViewOnSuperView:(UIView *)parentView gifName:(NSString *)gifName
{
    LCGifView *gifView = [[LCGifView alloc] initWithFrame:parentView.bounds filePathName:gifName];
    [parentView addSubview:gifView];
    [gifView playGif];
    return [gifView autorelease];
}

- (void)playGif {
    [self setHidden:NO];
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(playGif) userInfo:nil repeats:YES];
        [timer fire];
    }
    index = index%count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
    contentV.layer.contents = (id)ref;
    CFRelease(ref);
    index ++;
}

- (void)dealloc {
    CFRelease(gif);
    [gifProperties release];
    [contentV release] , contentV = nil;
    [super dealloc];
}

- (void)stopGif {
    [self setHidden:YES];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
    [self stopGif];
}

@end
