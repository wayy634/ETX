//
//  LCNotificationFloatView.m
//  LeCai
//
//  Created by HXG on 3/12/15.
//
//

#import "LCNotificationFloatView.h"
#import "UIWindow+LCAddition.h"

#define K_LC_NOTIFICATION_FLOAT_VIEW_TOP_MARGIN         26
#define K_LC_NOTIFICATION_FLOAT_VIEW_LEFT_MARGIN        14
#define K_LC_NOTIFICATION_FLOAT_VIEW_HORIZON_GAP        10
#define K_LC_NOTIFICATION_FLOAT_VIEW_LBALE_HEIGHT       15.f
#define K_LC_NOTIFICATION_FLOAT_VIEW_ANIMATION_DURATION 0.5f
#define K_LC_NOTIFICATION_FLOAT_VIEW_PULL_UP_DEALY      3.f


@interface LCNotificationFloatView ()

@property (nonatomic, strong) UIImageView *mIconImageView;
@property (nonatomic, strong) UILabel     *mTitleLabel;
@property (nonatomic, strong) UILabel     *mDetailLabel;

@end

@implementation LCNotificationFloatView

static NSInteger LCNotificationDisplayIndex = 0;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)dealloc {
    
    self.mIconImageView = nil;
    self.mTitleLabel    = nil;
    self.mDetailLabel   = nil;
    
    [super dealloc];
}

#pragma mark - private
- (void)initUI {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    
    CGRect tmpFrame = CGRectMake(K_LC_NOTIFICATION_FLOAT_VIEW_LEFT_MARGIN, K_LC_NOTIFICATION_FLOAT_VIEW_TOP_MARGIN, 17, 14);
    
    CGSize viewSize = self.bounds.size;
    
    UIImageView *tmpIconImageView = [[UIImageView alloc] initWithFrame:tmpFrame];
    [self addSubview:tmpIconImageView];;
    self.mIconImageView = tmpIconImageView;
    [tmpIconImageView release];
    
    tmpFrame.origin.x   = _mIconImageView.right + K_LC_NOTIFICATION_FLOAT_VIEW_HORIZON_GAP;
    tmpFrame.size.width = viewSize.width - tmpFrame.origin.x - K_LC_NOTIFICATION_FLOAT_VIEW_LEFT_MARGIN;
    tmpFrame.size.height= K_LC_NOTIFICATION_FLOAT_VIEW_LBALE_HEIGHT;
    tmpFrame.origin.y -= 3.f;
    
    UILabel *tmpDetailLabel = [[UILabel alloc] initWithFrame:tmpFrame];
    tmpDetailLabel.backgroundColor = [UIColor clearColor];
    tmpDetailLabel.font      = K_FONT_SIZE(13);
    tmpDetailLabel.textColor = [UIColor whiteColor];
    tmpDetailLabel.numberOfLines = 0;
    self.mDetailLabel        = tmpDetailLabel;
    [self addSubview:tmpDetailLabel];
    [tmpDetailLabel release];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
    
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture_ {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAumatically) object:nil];
    [self dismissAnimated:NO];
}

- (void)showAnimated:(BOOL)animated_ {
    
    LCNotificationDisplayIndex ++;
//    if ([LTools isGreatherThanIOS7]) {
//        [UIApplication sharedApplication].statusBarHidden = YES;
//    }
    
    if ([self superview]) {
        [self removeFromSuperview];
    }
    
    [[UIWindow lcCurrentTopWindow] addSubview:self];
    
    CGRect targetFrame = self.frame;
    targetFrame.origin.y = 0;
    
    NSTimeInterval duration = 0.f;
    if (animated_) {
        duration = K_LC_NOTIFICATION_FLOAT_VIEW_ANIMATION_DURATION;
    }
    
    CGRect originFrame = targetFrame;
    originFrame.origin.y = -originFrame.size.height;
    self.frame = originFrame;
    
    __block LCNotificationFloatView *weakSelf = self;
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.frame = targetFrame;
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(dismissAumatically) withObject:nil afterDelay:K_LC_NOTIFICATION_FLOAT_VIEW_PULL_UP_DEALY];
    }];
}

- (void)dismissAnimated:(BOOL)animated_ {
    CGRect targetFrame = self.frame;
    targetFrame.origin.y = - targetFrame.size.height;
    NSTimeInterval duration = 0.f;
    if (animated_) {
        duration = K_LC_NOTIFICATION_FLOAT_VIEW_ANIMATION_DURATION;
    }
    
    __block LCNotificationFloatView *weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.frame = targetFrame;
    } completion:^(BOOL finished) {
        LCNotificationDisplayIndex --;
        if (LCNotificationDisplayIndex <= 0) {
//            if ([LTools isGreatherThanIOS7]) {
//                [UIApplication sharedApplication].statusBarHidden = NO;
//            }
        }
        [weakSelf removeFromSuperview];
    }];
}

- (void)dismissAumatically {
    [self dismissAnimated:YES];
}

- (void)setDetailContent:(NSString *)detailContent_ {
    self.mDetailLabel.text = detailContent_;
    
    if (detailContent_.length > 0) {
        CGSize textSize = [detailContent_ sizeWithFont:self.mDetailLabel.font];
        
        CGRect labelFrame = _mDetailLabel.frame;
        if (textSize.width > labelFrame.size.width) {
            labelFrame.size.height = 2 * ceil(textSize.height);
        } else {
            labelFrame.size.height = ceil(textSize.height);
        }
        _mDetailLabel.frame = labelFrame;
    }
}

+ (LCNotificationFloatView *)showFloatViewWithImage:(UIImage *)iconImage_
                                          titleInfo:(NSString *)titleInfo_
                                         detailInfo:(NSString *)detailInfo_ {
 
    LCNotificationFloatView *floatView = [[LCNotificationFloatView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 64.f)];
    
    floatView.mIconImageView.image  = iconImage_;
    floatView.mTitleLabel.text      = titleInfo_;
    
    [floatView setDetailContent:detailInfo_];
    [floatView showAnimated:YES];
    
    return [floatView autorelease];
}

+ (LCNotificationFloatView *)showFloatViewWithDetailInfo:(NSString *)detailInfo_ {
    
    return [self showFloatViewWithImage:[UIImage imageNamed:@"notification_icon"]
                              titleInfo:nil
                             detailInfo:detailInfo_];
}

@end
