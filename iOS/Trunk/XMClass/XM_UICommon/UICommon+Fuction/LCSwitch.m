//
//  LCSwitch.m
//  LeCai
//
//  Created by lehecaiminib on 15-3-11.
//
//

#import "LCSwitch.h"

@interface LCSwitch ()

@property (nonatomic, strong) UIImage *mOnImage;
@property (nonatomic, strong) UIImage *mOffImage;

@end

@implementation LCSwitch
@synthesize switchOn;

- (id)initWithPosition:(CGPoint)point_ onImage:(UIImage *)onImage_ offImage:(UIImage *)offImage_ backGroundImage:(UIImage *)backGroundImage_ delegate:(id)delegate_ {
    self = [super init];
    if (self) {
        mDelegate = delegate_;
        self.mOnImage = onImage_;
        self.mOffImage = offImage_;
        [self setFrame:CGRectMake(point_.x, point_.y, backGroundImage_.size.width, backGroundImage_.size.height)];
        mBackGroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
        [mBackGroundImageView setImage:backGroundImage_];
        [self addSubview:mBackGroundImageView];
        mActiveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, (self.height - offImage_.size.height)/2, offImage_.size.width, offImage_.size.height)];
        [mActiveImageView setImage:offImage_];
        [self addSubview:mActiveImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
    return self;
}

- (void)handleTap {
    [UIView animateWithDuration:0.2 animations:^{
        !self.switchOn ? (mActiveImageView.left = self.width - mActiveImageView.width - 1) : (mActiveImageView.left = 1);
    } completion:^(BOOL finished) {
        self.switchOn = !self.switchOn;
        self.switchOn ? [mActiveImageView setImage:self.mOnImage] : [mActiveImageView setImage:self.mOffImage];
        [mDelegate switchTap];
    }];
}

- (void)dealloc {
    [mBackGroundImageView release] , mBackGroundImageView = nil;
    [mActiveImageView release] , mActiveImageView = nil;
    self.mOnImage = nil;
    self.mOffImage = nil;
    [super dealloc];
}
@end
