//
//  XMDrawLineLabel.m
//  XiaoMai
//
//  Created by Jeanne on 15/5/9.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMDrawLineLabel.h"

@interface XMDrawLineLabel ()

@property (nonatomic, assign)BOOL           mIsStrikeThrough;
@property (nonatomic, strong)UIColor        *mStrikeThroughColor;
@property (nonatomic, assign)XMDrawLineType mDrawLineType;

@end

@implementation XMDrawLineLabel

- (id)initWithFrame:(CGRect)frame_ lineType:(XMDrawLineType)lineType_ lineColor:(UIColor *)lineColor_ {
    self = [super initWithFrame:frame_];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.mIsStrikeThrough = YES;
        self.mDrawLineType = lineType_;
        self.mStrikeThroughColor = lineColor_;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:rect];
    CGSize textSize = [[self text] sizeWithFont:[self font]];
//    NSLog(@"______textSize = %@ , ______rect = %@",NSStringFromCGSize(textSize),NSStringFromCGRect(rect));
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    
    switch (self.mDrawLineType) {
        case XMDrawLineTypeTop:{
            if ([self textAlignment] == NSTextAlignmentRight) {
                lineRect = CGRectMake(rect.size.width - strikeWidth, 0, strikeWidth, 1);
            } else if ([self textAlignment] == NSTextAlignmentCenter) {
                lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, 0, strikeWidth, 1);
            } else {
                lineRect = CGRectMake(0, 0, strikeWidth, 1);
            }
            break;
        }
        case XMDrawLineTypeMid:{
            if ([self textAlignment] == NSTextAlignmentRight) {
                lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2, strikeWidth, 1);
            } else if ([self textAlignment] == NSTextAlignmentCenter) {
                lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2, strikeWidth, 1);
            } else {
                lineRect = CGRectMake(0, rect.size.height/2, strikeWidth, 1);
            }
            break;
        }
        case XMDrawLineTypeDown:{
            if ([self textAlignment] == NSTextAlignmentRight) {
                lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
            } else if ([self textAlignment] == NSTextAlignmentCenter) {
                lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
            } else {
                lineRect = CGRectMake(0, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
            }
            break;
        }
    }
    
    if (self.mIsStrikeThrough) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,self.mStrikeThroughColor.CGColor);
        CGContextFillRect(context, lineRect);
    }
}

- (void)dealloc {
    self.mStrikeThroughColor = nil;
    [super dealloc];
}
@end
