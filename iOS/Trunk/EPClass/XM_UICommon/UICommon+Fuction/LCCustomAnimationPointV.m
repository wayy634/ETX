//
//  LCCustomAnimationPointV.m
//  LeCai
//
//  Created by lehecaiminib on 14-12-23.
//
//

#import "LCCustomAnimationPointV.h"
#import <QuartzCore/QuartzCore.h>

@implementation LCCustomAnimationPointV
@synthesize animationBlock;

- (id)initCustomKeyAnimation:(UIImage *)_image {
    if ((self = [super initWithFrame:CGRectMake(0, 0, _image.size.width, _image.size.height)])) {
        mAnimationImageV = [[UIImageView alloc] initWithImage:_image];
        [mAnimationImageV setFrame:self.frame];
        [self addSubview:mAnimationImageV];
    }
    return self;
}
/*  example for point
LCCustomAnimationPointV *temp = [[LCCustomAnimationPointV alloc] initCustomKeyAnimation:[UIImage imageNamed:@"icn_gamelive_football.png"] durationTime:3.0];
[self.contentView addSubview:temp];
[temp startPointAniamtionpointFrame:@[[NSValue valueWithCGPoint:CGPointMake(50, 120)],[NSValue valueWithCGPoint:CGPointMake(80, 170)],[NSValue valueWithCGPoint:CGPointMake(30, 100)],[NSValue valueWithCGPoint:CGPointMake(100, 190)],[NSValue valueWithCGPoint:CGPointMake(200, 10)]] success:^{
    [temp removeFromSuperview];
    [temp release];
}];
*/

- (void)startPointAniamtionPointFrame:(NSArray *)_pointArray durationTime:(float)_durationTime success:(AnimationSuccess)_completion {
    self.animationBlock = _completion;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setValues:_pointArray];
    [animation setDuration:_durationTime];
//    [animation setAutoreverses:YES];
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:NULL];
    
}
/* example for path
CGMutablePathRef path = CGPathCreateMutable();
CGPathMoveToPoint(path,NULL,50.0,120.0);
CGPathAddLineToPoint(path, NULL, 60, 130);
CGPathAddLineToPoint(path,NULL, 70, 140);
CGPathAddLineToPoint(path,NULL, 80, 150);
CGPathAddLineToPoint(path, NULL, 90, 160);
CGPathAddLineToPoint(path,NULL, 100, 170);
CGPathAddCurveToPoint(path,NULL,50.0,275.0,150.0,275.0,70.0,120.0);
CGPathAddCurveToPoint(path,NULL,150.0,275.0,250.0,275.0,90.0,120.0);
CGPathAddCurveToPoint(path,NULL,250.0,275.0,350.0,275.0,110.0,120.0);
CGPathAddCurveToPoint(path,NULL,350.0,275.0,450.0,275.0,130.0,120.0);

LCCustomAnimationPointV *temp = [[LCCustomAnimationPointV alloc] initCustomKeyAnimation:[UIImage imageNamed:@"icn_gamelive_football.png"] durationTime:3.0];
[self.contentView addSubview:temp];
[temp startPathAnimationpathFrame:path success:^{
    [temp removeFromSuperview];
    [temp release];
}];
 */

- (void)startPathAnimationPathFrame:(CGMutablePathRef)_PathRef durationTime:(float)_durationTime success:(AnimationSuccess)_completion {
    self.animationBlock = _completion;
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation1 setPath:_PathRef];
    [animation1 setDuration:_durationTime];
//    [animation setAutoreverses:YES];
    animation1.delegate = self;
    CFRelease(_PathRef);
    [self.layer addAnimation:animation1 forKey:NULL];
}

- (void)startBaiduChooseBallPathAnimationpathFrame:(CGMutablePathRef)_PathRef success:(AnimationSuccess)_completion {
    self.animationBlock = _completion;
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation1 setPath:_PathRef];
    CFRelease(_PathRef);

    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation2.values   = @[@(0.8), @(1.0), @(1.0), @(1.0),@(1.0), @(0.5)];
    animation2.keyTimes = @[@(0.0), @(0.1), @(0.2), @(0.3),@(0.4), @(0.5)];
    animation2.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:animation1 ,animation2, nil];
    group.duration = 0.5;
    group.delegate = self;
    [self.layer addAnimation:group forKey:nil];
}

+ (void)startAnimation:(UIView *)_view animationGroupArray:(NSArray *)_array durationTime:(float)_durationTime {
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.animations = _array;
    group.duration = _durationTime;
    [_view.layer addAnimation:group forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animationBlock && flag) {
        self.animationBlock(nil);
        self.animationBlock = nil;
    }
}

- (void)dealloc {
    [mAnimationImageV release] , mAnimationImageV = nil;
    [super dealloc];
}
@end
