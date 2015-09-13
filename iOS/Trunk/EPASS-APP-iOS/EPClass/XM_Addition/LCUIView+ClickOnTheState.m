//
//  LCUIView+ClickOnTheState.m
//  LeCai
//
//  Created by lehecaiminib on 15-1-29.
//
//

#import "LCUIView+ClickOnTheState.h"
#import <objc/runtime.h>

static char UILCCoverV;

@implementation UIView (clickOnTheState)
@dynamic mCoverV;
- (void)addButtonClickState:(clickOnTheStateType)_type clickStateColor:(UIColor *)_color clickStateAlpha:(float)_alpha delegate:(id)_delegate {
    self.mCoverV = [[[LCCoverV alloc] initWithFrame:self.frame] autorelease];
    self.mCoverV.mCoverColor = _color;
    self.mCoverV.mCoverAlpha = _alpha;
    self.mCoverV.mRemeberAlpha = self.alpha;
    [self.mCoverV.layer setMasksToBounds:self.layer.masksToBounds];
    [self roundedRectangleView:self.mCoverV.layer corner:self.layer.cornerRadius width:self.layer.borderWidth color:self.layer.borderColor];
    self.userInteractionEnabled = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:_delegate action:NSSelectorFromString([[((UIButton *)self) actionsForTarget:_delegate forControlEvent:UIControlEventTouchUpInside] lastObject])];
    [self.mCoverV addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    
    switch (_type) {
        case clickOnTheStateTypeaBackGround:{
            [self.superview insertSubview:self.mCoverV belowSubview:self];
            self.mCoverV.mRemeberColor = self.backgroundColor;
            [self.mCoverV setBackgroundColor:self.backgroundColor];
            [self setBackgroundColor:[UIColor clearColor]];
            break;
        }
            
        case clickOnTheStateTypeCover:{
            [self.superview addSubview:self.mCoverV];
            self.mCoverV.mRemeberColor = [UIColor clearColor];
            [self.mCoverV setBackgroundColor:[UIColor clearColor]];
            break;
        }
    }
    
}

- (void)addClickState:(clickOnTheStateType)_type clickStateColor:(UIColor *)_color clickStateAlpha:(float)_alpha code:(void(^)(void))_complete {
    self.mCoverV = [[[LCCoverV alloc] initWithFrame:self.frame] autorelease];
    self.mCoverV.mCoverColor = _color;
    self.mCoverV.mCoverAlpha = _alpha;
    self.mCoverV.mRemeberAlpha = self.alpha;
    [self.mCoverV.layer setMasksToBounds:self.layer.masksToBounds];
    [self roundedRectangleView:self.mCoverV.layer corner:self.layer.cornerRadius width:self.layer.borderWidth color:self.layer.borderColor];
    if (_complete) {
        self.mCoverV.LCCoverVForTouchUp = _complete;
    }
    switch (_type) {
        case clickOnTheStateTypeaBackGround:{
            [self.superview insertSubview:self.mCoverV belowSubview:self];
            if ([self isKindOfClass:[UITableViewCell class]]) {
                [((UITableViewCell *)self) setBackgroundColor:[UIColor clearColor]];
                self.mCoverV.mRemeberColor = ((UITableViewCell *)self).contentView.backgroundColor;
                [self.mCoverV setBackgroundColor:((UITableViewCell *)self).contentView.backgroundColor];
                [((UITableViewCell *)self).contentView setBackgroundColor:[UIColor clearColor]];
            } else {
                self.mCoverV.mRemeberColor = self.backgroundColor;
                [self.mCoverV setBackgroundColor:self.backgroundColor];
                [self setBackgroundColor:[UIColor clearColor]];
            }
            self.userInteractionEnabled = NO;
            break;
        }
        case clickOnTheStateTypeCover:{
            [self.superview addSubview:self.mCoverV];
            self.mCoverV.mRemeberColor = [UIColor clearColor];
            [self.mCoverV setBackgroundColor:[UIColor clearColor]];
            break;
        }
    }
    if ([self.gestureRecognizers count] > 0) {
        self.mCoverV.gestureRecognizers = self.gestureRecognizers;
    }
}

- (void)setMCoverV:(LCCoverV *)_coverV {
    objc_setAssociatedObject(self, &UILCCoverV,
                             _coverV,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (LCCoverV *)mCoverV {
    return objc_getAssociatedObject(self, &UILCCoverV);
}

- (void)roundedRectangleView:(CALayer *)layer_ corner:(float)corner_ width:(float)width_ color:(CGColorRef)color_ {
    [layer_ setCornerRadius:corner_];
    [layer_ setBorderWidth:width_];
    [layer_ setBorderColor:color_];
}
@end

@implementation LCCoverV
@synthesize mCoverColor;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setAlpha:self.mCoverAlpha];
    [self setBackgroundColor:self.mCoverColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setAlpha:self.mRemeberAlpha];
    [self setBackgroundColor:self.mRemeberColor];
    if (self.LCCoverVForTouchUp) {
        self.LCCoverVForTouchUp();
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setAlpha:self.mRemeberAlpha];
    [self setBackgroundColor:self.mRemeberColor];
    if (self.LCCoverVForTouchUp) {
        self.LCCoverVForTouchUp();
    }
}

- (void)dealloc {
    self.mCoverColor = nil;
    self.mRemeberColor = nil;
    self.LCCoverVForTouchUp = nil;
    [super dealloc];
}
@end
