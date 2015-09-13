//
//  LCLoadingTipView.m
//  LeCai
//
//  Created by HXG on 9/5/14.
//
//

#import "LCLoadingTipView.h"

#define K_LCLoadingTipView_View_Width   300
#define K_LCLoadingTipView_Label_Width  260
#define K_LCLoadingTipView_Label_Space  5
#define K_LCLoadingTipView_Top_Margin   15
//#define K_LCLoadingTipView_Animation_Duration 0.2f
#define K_LCLoadingTipView_Animation_Duration 0.f

@interface LCLoadingTipView ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL shouldShowIndicator;

@property (nonatomic, strong) UIWindow *currentWindow;

@property (nonatomic, assign) BOOL visible;

@end

@implementation LCLoadingTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message withIndicator:(BOOL)shouldShowIndicator
{
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.shouldShowIndicator = shouldShowIndicator;
    }
    return self;
}

- (void)show
{
    self.visible = YES;
    [self retain];
    self.backgroundColor = [UIColor clearColor];
    
    self.frame = self.currentWindow.bounds;
    
    [self createDimView];
    [self createContainerView];

    self.dimView.alpha = 0.f;
    self.containerView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [self.currentWindow addSubview:self];
    [self.currentWindow makeKeyAndVisible];
    
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:K_LCLoadingTipView_Animation_Duration
                     animations:^{
                         self.dimView.alpha = 1.f;
                         self.containerView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                         if (self.loadingView) {
                             [self.loadingView startAnimating];
                         }
                     }];
//    [self autorelease];
}

- (void)dismiss
{
    if (self.loadingView) {
        [self.loadingView stopAnimating];
    }
    [UIView animateWithDuration:K_LCLoadingTipView_Animation_Duration
                     animations:^{
                         self.dimView.alpha = 0.f;
                         self.containerView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
                     } completion:^(BOOL finished) {
//                         self.currentWindow.alpha = 0.f;
                         self.visible = NO;
                         self.currentWindow = nil;
                         [self removeFromSuperview];
                         [self release];
                     }];
}

- (void)enableTapDismiss:(BOOL)enabled
{
    NSArray *gestures = [self gestureRecognizers];
    for (UIGestureRecognizer *aGesture in gestures) {
        [self removeGestureRecognizer:aGesture];
    }
    
    if (enabled) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        tapGesture = nil;
    }
}

- (void)dealloc
{
    self.dimView = nil;
    self.containerView = nil;
    self.title = nil;
    self.message = nil;
    self.loadingView = nil;
    self.titleLabel = nil;
    self.messageLabel = nil;
    [super dealloc];
}

#pragma mark - private

- (void)createDimView
{
    UIView *dimView = [[UIView alloc] initWithFrame:self.bounds];
    self.dimView = dimView;
    dimView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    dimView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:dimView];
    [dimView release];
    dimView = nil;
}

- (void)createContainerView
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, K_LCLoadingTipView_View_Width, 0)];
    containerView.backgroundColor = [UIColor clearColor];
    self.containerView = containerView;
    
    CGFloat originX = (K_LCLoadingTipView_View_Width - K_LCLoadingTipView_Label_Width) / 2.f;
    CGFloat originY = K_LCLoadingTipView_Top_Margin;
    
    if (self.title.length > 0) {
        UIFont *titleFont = K_BOLD_FONT_SIZE(18);
        CGSize textSize = [self.title sizeWithFont:titleFont constrainedToSize:CGSizeMake(K_LCLoadingTipView_Label_Width, CGFLOAT_MAX)];
        textSize.height = ceilf(textSize.height);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, K_LCLoadingTipView_Label_Width, textSize.height)];
        titleLabel.font     = titleFont;
        titleLabel.textAlignment    = NSTextAlignmentCenter;
        titleLabel.backgroundColor  = [UIColor clearColor];
        titleLabel.text = self.title;
        self.titleLabel = titleLabel;
        [titleLabel release];
        titleLabel = nil;
        originY += textSize.height + K_LCLoadingTipView_Label_Space;
    }
    
    if (self.message.length > 0) {
        UIFont *messageFont = K_FONT_SIZE(16);
        CGSize textSize = [self.message sizeWithFont:messageFont constrainedToSize:CGSizeMake(K_LCLoadingTipView_Label_Width, CGFLOAT_MAX)];
        textSize.height = ceilf(textSize.height);
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, K_LCLoadingTipView_Label_Width, textSize.height)];
        messageLabel.font     = messageFont;
        messageLabel.textAlignment    = NSTextAlignmentCenter;
        messageLabel.backgroundColor  = [UIColor clearColor];
        messageLabel.text = self.message;
        self.messageLabel = messageLabel;
        [messageLabel release];
        messageLabel = nil;
        originY += textSize.height + K_LCLoadingTipView_Label_Space;
    }
    
    if (self.shouldShowIndicator) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect tmpFrame = loadingView.frame;
        tmpFrame.origin.x = (K_LCLoadingTipView_View_Width - tmpFrame.size.width) / 2.f;
        tmpFrame.origin.y = originY;
        loadingView.frame = tmpFrame;
        self.loadingView = loadingView;
        [loadingView release];
        loadingView = nil;
        
        originY += tmpFrame.size.height;
    }
    
    originY += K_LCLoadingTipView_Top_Margin;
    
    CGRect tmpFrame = self.containerView.frame;
    tmpFrame.size.height = originY;
    tmpFrame.origin.x = (self.bounds.size.width - tmpFrame.size.width) / 2.f;
    tmpFrame.origin.y = (self.bounds.size.height - tmpFrame.size.height) / 2.f;
    self.containerView.frame = tmpFrame;
    
    if (self.titleLabel) {
        [self.containerView addSubview:self.titleLabel];
    }
    
    if (self.messageLabel) {
        [self.containerView addSubview:self.messageLabel];
    }
    
    if (self.loadingView) {
        [self.containerView addSubview:self.loadingView];
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = containerView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       nil];
    
    CGFloat cornerRadius = 7.f;
    gradient.cornerRadius = cornerRadius;
    [containerView.layer insertSublayer:gradient atIndex:0];

    containerView.layer.cornerRadius    = cornerRadius;
    containerView.layer.borderColor     = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
    containerView.layer.borderWidth     = 1;
    containerView.layer.shadowRadius    = cornerRadius + 5;
    containerView.layer.shadowOpacity   = 0.1f;
    containerView.layer.shadowOffset    = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    containerView.layer.shadowColor     = [UIColor blackColor].CGColor;
    containerView.layer.shadowPath      = [UIBezierPath bezierPathWithRoundedRect:containerView.bounds cornerRadius:containerView.layer.cornerRadius].CGPath;

    [self addSubview:self.containerView];
    
//    self.containerView.backgroundColor = [UIColor whiteColor];
    
    [containerView release];
    containerView = nil;
}

- (UIWindow *)currentWindow
{
    if (!_currentWindow) {
        BOOL created = NO;
        UIWindow *aWindow = [UIApplication sharedApplication].keyWindow;
        if (!aWindow) {
            if ([[UIApplication sharedApplication].windows count] > 0) {
                aWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
            } else {
                created = YES;
                aWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                aWindow.windowLevel = UIWindowLevelAlert;
                aWindow.backgroundColor = [UIColor clearColor];
            }
        }
        
        self.currentWindow = aWindow;
        if (created) {
            [aWindow release];
            aWindow = nil;
        }
    }
    return _currentWindow;
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    [self dismiss];
}

@end
