//
//  HCTapGestureRecognizer.m
//  HCToolKit
//
//  Created by HXG on 1/13/15.
//  Copyright (c) 2015 Wang Hui. All rights reserved.
//

#import "HCTapGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation HCTapGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.tapDelegate = nil;
    [self cancelRecognizeGesture];
    [super dealloc];
}

- (void)recognizeGestureAfterDelay
{
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
        self.highlighted = YES;
    }
}

- (void)cancelRecognizeGesture
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recognizeGestureAfterDelay) object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self performSelector:@selector(recognizeGestureAfterDelay) withObject:nil afterDelay:0.05];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStatePossible) {
        [self cancelRecognizeGesture];
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self cancelRecognizeGesture];
    [self checkTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self cancelRecognizeGesture];
    [self checkTouches:touches];
}

- (void)checkTouches:(NSSet *)touches
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view.superview];
    self.highlighted = NO;
    if (CGRectContainsPoint(self.view.frame, touchPoint)) {
        self.state = UIGestureRecognizerStateEnded;
        if ([self.tapDelegate respondsToSelector:@selector(touchUpInsideGesture:)]) {
            [self.tapDelegate touchUpInsideGesture:self];
        }
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (_highlighted != highlighted) {
        _highlighted = highlighted;
        if ([self.tapDelegate respondsToSelector:@selector(highlightedChangedInGesture:)]) {
            [self.tapDelegate highlightedChangedInGesture:self];
        }
    }
}

- (void)setState:(UIGestureRecognizerState)state
{
    [super setState:state];
    if (state == UIGestureRecognizerStateEnded ||
        state == UIGestureRecognizerStateFailed ||
        state == UIGestureRecognizerStateCancelled) {
        self.highlighted = NO;
    }
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    return YES;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return YES;
}

@end
