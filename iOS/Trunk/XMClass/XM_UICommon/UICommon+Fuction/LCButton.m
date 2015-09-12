//
//  LCButton.m
//  LeCai
//
//  Created by HXG on 1/31/15.
//
//

#import "LCButton.h"

@interface LCButton ()

@property (nonatomic, strong) UIView *topCoverView;

@end

@implementation LCButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDatas];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initDatas];
    }
    return self;
}

- (void)initDatas
{
    self.LCHighlightBgColor = [LTools colorWithHexString:@"e5e5e5"];
    self.highlightType = LCButtonHighlightTypeTopCover;
}

- (UIView *)topCoverView
{
    if (!_topCoverView) {
        self.topCoverView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    }
    return _topCoverView;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (_highlightType == LCButtonHighlightTypeBackground) {
        if (highlighted) {
            if (self.LCHighlightBgColor) {
                self.backgroundColor = self.LCHighlightBgColor;
            }
        } else {
            if (self.LCNormalBgColor) {
                self.backgroundColor = self.LCNormalBgColor;
            }
        }
    } else if (_highlightType == LCButtonHighlightTypeTopCover) {
        if (highlighted) {
            self.topCoverView.frame = self.bounds;
            [self addSubview:self.topCoverView];
        } else {
            [self.topCoverView removeFromSuperview];
        }
    }
    
    if ([self.buttonDelegate respondsToSelector:@selector(button:highlightStatusChanged:)]) {
        [self.buttonDelegate button:self highlightStatusChanged:highlighted];
    }
}

- (void)dealloc
{
    self.LCNormalBgColor = nil;
    self.LCHighlightBgColor = nil;
    self.topCoverView = nil;
    [super dealloc];
}

@end
