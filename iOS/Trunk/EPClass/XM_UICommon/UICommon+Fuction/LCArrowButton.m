//
//  LCArrowButton.m
//  LeCai
//
//  Created by HXG on 12/10/14.
//
//

#import "LCArrowButton.h"

@interface LCArrowButton ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;

@end

@implementation LCArrowButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)dealloc
{
    self.titleLabel = nil;
    self.arrowImageView = nil;
    [super dealloc];
}

#pragma mark - private
- (void)initUI
{
    _offset = 8.f;
    _selected = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.cornerRadius = 4.f;
    self.layer.borderColor = [LTools colorWithHexString:@"ff8f8f"].CGColor;
    self.layer.borderWidth = 1.f;
    self.clipsToBounds = YES;
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel = aLabel;
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.font = K_BOLD_FONT_SIZE(16);
    aLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:aLabel];
    [aLabel release];
    
    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 7)];
    aImageView.image = [UIImage imageNamed:@"togetherbuy_topArrowUp_baidu"];
    self.arrowImageView = aImageView;
    [self addSubview:aImageView];
    [aImageView release];
    
    [self setSelected:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate shouldSelectArrowButton:self]) {
        self.selected = !_selected;
        [self.delegate clickedAtArrowButton:self];
    }
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//}

- (void)recaculateLayout
{
    CGSize viewSize = self.bounds.size;
    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGRect tmpFrame = CGRectMake(_offset, 0, textSize.width, viewSize.height);
    self.titleLabel.frame = tmpFrame;
    tmpFrame = self.arrowImageView.frame;
    tmpFrame.origin.x = self.titleLabel.right + 5;
    tmpFrame.origin.y = (viewSize.height - tmpFrame.size.height) / 2.f;
    self.arrowImageView.frame = tmpFrame;
    
    tmpFrame = self.frame;
    tmpFrame.size.width = _arrowImageView.right + _offset;
    self.frame = tmpFrame;
}

#pragma mark - public
- (void)setOffset:(CGFloat)offset
{
    if (_offset != offset) {
        _offset = offset;
        [self recaculateLayout];
    }
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self recaculateLayout];
}

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        if (_selected) {
            self.arrowImageView.transform = CGAffineTransformIdentity;
        } else {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }
}

- (NSString *)currentTitle
{
    return self.titleLabel.text;
}

@end
