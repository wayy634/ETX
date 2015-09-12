//
//  XMCustomAlertV.m
//  XiaoMai
//
//  Created by Jeanne on 15/8/4.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//
#define K_XMCUSTOMALERTV_OFFSET 15

#define K_XMCUSTOMALERTV_WIDTH (K_SCREEN_WIDTH - 80)
#define K_XMCUSTOMALERTV_LIMIT_HEiGHT ([UIScreen mainScreen].bounds.size.height - 200)
#define K_XMCUSTOMALERTV_BUTTON_OFFSET_X 10
#define K_XMCUSTOMALERTV_BUTTON_WIDTH ((K_XMCUSTOMALERTV_WIDTH - K_XMCUSTOMALERTV_OFFSET*3)/2)
#define K_XMCUSTOMALERTV_BUTTON_HEIGHT 37

#import "XMCustomAlertV.h"
#import "XMAttributedLabel.h"
#import <objc/runtime.h>

static char cancel;
static char confirm;

@interface XMCustomAlertV ()
@property (nonatomic, strong)UIView  *mCoverV;
@property (nonatomic, strong)UIView  *mContentV;
@property (nonatomic, strong)UILabel *mTitleLabel;
@property (nonatomic, strong)XMAttributedLabel *mContentLabel;
@property (nonatomic, strong)UIButton *mCancelButton;
@property (nonatomic, strong)UIButton *mConfirmButton;
@property (nonatomic, strong)UIScrollView *mScrollV;
@property (nonatomic, strong)NSMutableArray *mSpecialDataArray;
@end

@implementation XMCustomAlertV

+ (XMCustomAlertV *)shareXMCustomAlertV {
    static XMCustomAlertV *sharedXMCustomAlertV = nil;
    static dispatch_once_t threadOnceToken;
    dispatch_once(&threadOnceToken, ^{
        sharedXMCustomAlertV = [[XMCustomAlertV alloc] initUI];
    });
    return sharedXMCustomAlertV;
}

- (id)initUI {
    if (self == [super initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)]) {
        [LTools roundedRectangleView:self color:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
//        self.mSpecialDataArray = [NSMutableArray array];
        
        UIView *coverV = [[UIView alloc] initWithFrame:self.frame];
        [coverV setBackgroundColor:[UIColor blackColor]];
        coverV.alpha = 0.5;
        [self addSubview:coverV];
        self.mCoverV = coverV;
        [coverV release];
        
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_XMCUSTOMALERTV_WIDTH, 0)];
        [contentV setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:contentV];
        self.mContentV = contentV;
        [contentV release];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, K_XMCUSTOMALERTV_OFFSET, self.mContentV.width, 18)];
        [title setTextColor:K_COLOR_MAIN_FONT];
        [title setFont:K_FONT_SIZE(18)];
        [title setTextAlignment:NSTextAlignmentCenter];
        [self.mContentV addSubview:title];
        self.mTitleLabel = title;
        [title release];
        
        UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.mTitleLabel.bottom + K_XMCUSTOMALERTV_OFFSET, self.mContentV.width, 0)];
        [self.mContentV addSubview:scrollV];
        self.mScrollV = scrollV;
        [scrollV release];
        
        XMAttributedLabel *content = [[XMAttributedLabel alloc] initWithFrame:CGRectMake(K_XMCUSTOMALERTV_OFFSET, 0, self.mContentV.width - K_XMCUSTOMALERTV_OFFSET*2, 0)];
        [content setNumberOfLines:100];
        [content setTextColor:K_COLOR_MAIN_FONT];
        [content setFont:K_FONT_SIZE(14)];
        [content setTextAlignment:NSTextAlignmentCenter];
        [self.mScrollV addSubview:content];
        self.mContentLabel = content;
        [content release];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setBackgroundColor:K_COLOR_MAIN_ORANGER];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.mContentV addSubview:cancelButton];
        [LTools roundedRectangleView:cancelButton corner:4. width:0.5 color:K_COLOR_MAIN_ORANGER];
        [cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.mCancelButton = cancelButton;
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setBackgroundColor:K_COLOR_MAIN_ORANGER];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.mContentV addSubview:confirmButton];
        [LTools roundedRectangleView:confirmButton corner:4. width:0.5 color:K_COLOR_MAIN_ORANGER];
        [confirmButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.mConfirmButton = confirmButton;
        
        [APP_DELEGATE.mWindow addSubview:self];
    }
    return self;
}

- (void)buttonPressed:(UIButton *)sender_ {
    if (sender_ == self.mCancelButton) {
        void(^cancelBlock)(void) = objc_getAssociatedObject(self.mCancelButton, &cancel);
        if (cancelBlock) {
            cancelBlock();
        }
    } else if (sender_ == self.mConfirmButton) {
        void(^confirmBlock)(void) = objc_getAssociatedObject(self.mConfirmButton, &confirm);
        if (confirmBlock) {
            confirmBlock();
        }
    }
    [self dismiss];
}


- (void)setWithTitle:(NSString *)title_ msg:(NSString *)msg_ specialDataArray:(NSArray *)dataArray_ cancelButtonTitle:(NSString *)cancelTitle_ confirmButtonTitle:(NSString *)confirmTitle_ cancelButtonBlock:(void (^)(void))cancelBlock_ confirmButtonTitle:(void (^)(void))confirmBlock_ {
    [self.mScrollV setContentOffset:CGPointMake(0, 0)];
    
    objc_setAssociatedObject(self.mCancelButton, &cancel, cancelBlock_, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self.mConfirmButton, &confirm, confirmBlock_, OBJC_ASSOCIATION_COPY);
    
    float height = title_.length > 0 ? .0 : -self.mTitleLabel.height - K_XMCUSTOMALERTV_OFFSET;
    [self.mTitleLabel setText:title_];
    
    self.mScrollV.top += height;
    [self.mContentLabel setXMAttributedString:[NSString stringWithFormat:@"%@",msg_]];
    NSMutableParagraphStyle *paragraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [paragraph setLineSpacing:5.0];
    [self.mContentLabel addAttributeType:XMAttributedTypeParagraph value:paragraph range:NSMakeRange(0,msg_.length)];
    [self.mContentLabel renderAttribute];
    CGSize rect = [LTools sizeForText:self.mContentLabel isLabelWidth:YES];
    self.mContentLabel.height = rect.height + 5 * (int)((rect.height/14));
    height += self.mContentLabel.bottom + K_XMCUSTOMALERTV_OFFSET;

    if (dataArray_ != nil) {
        for (int i = 0; i < dataArray_.count; i++) {
//            UILabel *specialLabel;
//            if (self.mSpecialDataArray.count > i) {
//                specialLabel = [self.mSpecialDataArray objectAtIndex:i];
//            } else {
//                specialLabel = [[UILabel alloc] init];
//                [specialLabel setTextColor:K_COLOR_MAIN_ORANGER];
//                [specialLabel setFont:K_FONT_SIZE(14)];
//                [self.mScrollV addSubview:specialLabel];
//                [self.mSpecialDataArray addObject:specialLabel];
//            }
            UILabel *specialLabel = [[[UILabel alloc] init] autorelease];
            [specialLabel setTextColor:K_COLOR_MAIN_ORANGER];
            [specialLabel setFont:K_FONT_SIZE(14)];
            [self.mScrollV addSubview:specialLabel];
//            [self.mSpecialDataArray addObject:specialLabel];
            [specialLabel setFrame:CGRectMake(K_XMCUSTOMALERTV_OFFSET,-K_XMCUSTOMALERTV_OFFSET/2 + height + i*K_XMCUSTOMALERTV_OFFSET + i*10, self.mContentV.width - K_XMCUSTOMALERTV_OFFSET*2, K_XMCUSTOMALERTV_OFFSET)];
            [specialLabel setText:[dataArray_ objectAtIndex:i]];
        }
        height += dataArray_.count*(K_XMCUSTOMALERTV_OFFSET + 10);
        height += K_XMCUSTOMALERTV_OFFSET;
    }
    
    height += K_XMCUSTOMALERTV_BUTTON_HEIGHT + K_XMCUSTOMALERTV_OFFSET + self.mTitleLabel.bottom + K_XMCUSTOMALERTV_OFFSET;
    [self.mContentV setFrame:CGRectMake((K_SCREEN_WIDTH - self.mContentV.width)/2, (K_SCREEN_HEIGHT - (height > K_XMCUSTOMALERTV_LIMIT_HEiGHT ? K_XMCUSTOMALERTV_LIMIT_HEiGHT : height))/2, self.mContentV.width, height > K_XMCUSTOMALERTV_LIMIT_HEiGHT ? K_XMCUSTOMALERTV_LIMIT_HEiGHT : height)];
    
    if (cancelTitle_ && cancelTitle_.length > 0) {
        self.mCancelButton.hidden = NO;
        [self.mCancelButton setTitle:cancelTitle_ forState:UIControlStateNormal];
        if (!confirmTitle_ || confirmTitle_.length == 0) {
            [self.mCancelButton setFrame:CGRectMake(K_XMCUSTOMALERTV_OFFSET, self.mContentV.height - K_XMCUSTOMALERTV_BUTTON_HEIGHT - K_XMCUSTOMALERTV_OFFSET, self.mContentV.width - K_XMCUSTOMALERTV_OFFSET*2, K_XMCUSTOMALERTV_BUTTON_HEIGHT)];
        } else {
            [self.mCancelButton setFrame:CGRectMake(K_XMCUSTOMALERTV_OFFSET, self.mContentV.height - K_XMCUSTOMALERTV_BUTTON_HEIGHT - K_XMCUSTOMALERTV_OFFSET, K_XMCUSTOMALERTV_BUTTON_WIDTH, K_XMCUSTOMALERTV_BUTTON_HEIGHT)];
        }
    } else {
        self.mCancelButton.hidden = YES;
    }
    
    if (confirmTitle_ && confirmTitle_.length > 0) {
        self.mConfirmButton.hidden = NO;
        [self.mConfirmButton setTitle:confirmTitle_ forState:UIControlStateNormal];
        if (!cancelTitle_ || cancelTitle_.length == 0) {
            [self.mConfirmButton setFrame:CGRectMake(K_XMCUSTOMALERTV_OFFSET, self.mContentV.height - K_XMCUSTOMALERTV_BUTTON_HEIGHT - K_XMCUSTOMALERTV_OFFSET, self.mContentV.width - K_XMCUSTOMALERTV_OFFSET*2, K_XMCUSTOMALERTV_BUTTON_HEIGHT)];
        } else {
            [self.mConfirmButton setFrame:CGRectMake(self.mContentV.width - K_XMCUSTOMALERTV_OFFSET - K_XMCUSTOMALERTV_BUTTON_WIDTH, self.mContentV.height - K_XMCUSTOMALERTV_BUTTON_HEIGHT - K_XMCUSTOMALERTV_OFFSET, K_XMCUSTOMALERTV_BUTTON_WIDTH, K_XMCUSTOMALERTV_BUTTON_HEIGHT)];
        }
    } else {
        self.mConfirmButton.hidden = YES;
    }
    [self.mScrollV setFrame:CGRectMake(0, self.mScrollV.top, self.mScrollV.width, self.mContentV.height - K_XMCUSTOMALERTV_BUTTON_HEIGHT - K_XMCUSTOMALERTV_OFFSET*2 - self.mScrollV.top)];
    [self.mScrollV setContentSize:CGSizeMake(self.mContentV.width, height - K_XMCUSTOMALERTV_BUTTON_HEIGHT - K_XMCUSTOMALERTV_OFFSET*2 - self.mScrollV.top)];
    
    [self show];
}

- (void)show {
    [self setAlpha:0.0];
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.0];
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:0.0];
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)dealloc {
    self.mConfirmButton = nil;
    self.mCancelButton = nil;
    self.mContentLabel = nil;
    self.mTitleLabel = nil;
    self.mScrollV = nil;
    self.mContentV = nil;
    self.mCoverV = nil;
    [super dealloc];
}

@end
