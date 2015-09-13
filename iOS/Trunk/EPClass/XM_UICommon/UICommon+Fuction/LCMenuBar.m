//
//  LCMenuBar.m
//  LeCai
//
//  Created by HXG on 3/7/15.
//
//

#import "LCMenuBar.h"
#import "LCButton.h"

#import "NSArray+LCAddition.h"

@implementation LCMenuBarButtonConfiguration

- (id)init {
    self = [super init];
    if (self) {
        [self loadDefaultConfiguration];
    }
    return self;
}

+ (id)menuBarButtonConfiguration {
    return [[[[self class] alloc] init] autorelease];
}

- (void)dealloc {
    self.mFont = nil;
    self.mNormalBackgroundColor     = nil;
    self.mSelectionBackgroundColor  = nil;
    self.mNormalTextColor           = nil;
    self.mSelectionTextColor        = nil;
    self.mBottomSelectionColor      = nil;
    self.mSplitLineColor            = nil;
    [super dealloc];
}

#pragma mark - private
- (void)loadDefaultConfiguration {
    self.mFont = K_FONT_SIZE(14);
    
//    self.mNormalTextColor       = [LCThemeManager commonTitleColor];
    self.mSelectionTextColor    = [LTools colorWithHexString:@"f13131"];
    self.mBottomSelectionColor  = [LTools colorWithHexString:@"f13131"];
    
    self.mNormalBackgroundColor     = [UIColor clearColor];
    self.mSelectionBackgroundColor  = [UIColor clearColor];
    
    self.mSelectionAnimationType = LCMenuBarSelectionAnimationTypeNone;
    self.mWidthCaclRule          = LCMenuBarWidthCaclRuleAuto;
    
    self.mButtonWidth = 0.f;
    self.mBottomSelectionHeight  = 3.f;
    self.mShouldShowBottomLine = YES;
    
    self.mShouldAddSplitLine = NO;
    self.mSplitLineColor     = [LTools colorWithHexString:@"dbdbdb"];
    self.mSplitLineMargin    = 10.f;
}

@end

@interface LCMenuBar ()

@property (nonatomic, strong) LCMenuBarButtonConfiguration *mButtonConfiguration;

@property (nonatomic, strong) UIView        *mBottomSelectionView;
@property (nonatomic, strong) UIView        *mBottomLineView;
@property (nonatomic, strong) LCButton      *mLastSelectedButton;
@property (nonatomic, strong) UIScrollView  *mScrollView;

@property (nonatomic, assign) NSInteger       mCurrentIndex;
@property (nonatomic, strong) NSMutableArray *mCachedButtons;


@end

@implementation LCMenuBar

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
    
    self.mButtonConfiguration = nil;
    self.mBottomSelectionView = nil;
    self.mLastSelectedButton  = nil;
    self.mCachedButtons  = nil;
    self.mBottomLineView = nil;
    self.mScrollView     = nil;
    [super dealloc];
}

#pragma mark - private
- (void)initUI {
    
    UIScrollView *tmpScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    tmpScrollView.showsHorizontalScrollIndicator = NO;
    tmpScrollView.showsVerticalScrollIndicator = NO;
    tmpScrollView.backgroundColor = [UIColor clearColor];
    tmpScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.mScrollView = tmpScrollView;
    [self addSubview:tmpScrollView];
    [tmpScrollView release];
    
    self.mCurrentIndex = -1;
}

- (void)setButtonConfiguration:(LCMenuBarButtonConfiguration *)buttonConfiguration_ buttonTitles:(NSArray *)buttonTitles_ {
    if (buttonConfiguration_) {
        self.mButtonConfiguration = buttonConfiguration_;
    } else {
        self.mButtonConfiguration = [LCMenuBarButtonConfiguration menuBarButtonConfiguration];
    }
    
    [self resetButtonTitles:buttonTitles_];
}

- (void)resetButtonTitles:(NSArray *)buttonTitles_ {
    
    [self.mBottomLineView removeFromSuperview];
    self.mBottomLineView = nil;
    
    [self.mBottomSelectionView removeFromSuperview];
    self.mBottomSelectionView = nil;
    
    for (UIButton *aButton in self.mCachedButtons) {
        [aButton removeFromSuperview];
    }
    self.mCachedButtons = nil;
    
    NSUInteger buttonAmount = [buttonTitles_ count];
    CGFloat tmpSelectionWidth = 0.f;
    
    if (buttonAmount > 0) {
        CGSize realContentSize = self.bounds.size;
        
        if (_mButtonConfiguration.mWidthCaclRule == LCMenuBarWidthCaclRuleAuto) {
            _mButtonConfiguration.mButtonWidth = self.width / buttonAmount;
        } else {
            realContentSize.width = buttonAmount * _mButtonConfiguration.mButtonWidth;
        }
        
        _mScrollView.contentSize = realContentSize;
        
        NSInteger index = 0;
        
        CGRect buttonFrame = CGRectMake(0, 0, _mButtonConfiguration.mButtonWidth, self.height);
        
        self.mCachedButtons = [NSMutableArray arrayWithCapacity:buttonAmount];
        
        self.mCurrentIndex = 0;
        for (NSString *buttonTitle in buttonTitles_) {
            buttonFrame.origin.x = index * _mButtonConfiguration.mButtonWidth;
            LCButton *aButton = [self buttonWithTitle:buttonTitle frame:buttonFrame index:index];
            [_mScrollView addSubview:aButton];
            [_mCachedButtons addObject:aButton];
            
            if (index == 0) {
                aButton.selected = YES;
                self.mLastSelectedButton = aButton;
            }
            
            index ++;
        }
        tmpSelectionWidth = _mButtonConfiguration.mButtonWidth;
    } else {
        tmpSelectionWidth = self.width;
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5f, self.width, 0.5f)];
    self.mBottomLineView = lineView;
    [self addSubview:lineView];
    [lineView release];
    
    if (!_mButtonConfiguration.mShouldShowBottomLine) {
        _mBottomLineView.hidden = YES;
    }
    
    CGRect bottomSelectionFrame = CGRectMake(0, self.height - _mButtonConfiguration.mBottomSelectionHeight, tmpSelectionWidth, _mButtonConfiguration.mBottomSelectionHeight);
    self.mBottomSelectionView = [[[UIView alloc] initWithFrame:bottomSelectionFrame] autorelease];
    _mBottomSelectionView.backgroundColor = _mButtonConfiguration.mBottomSelectionColor;
    [_mScrollView addSubview:_mBottomSelectionView];
}

- (void)changeButtonStatusAtIndexes:(NSArray *)buttonIndexes_ disabled:(BOOL)isDisabled_ {
    if ([buttonIndexes_ count] > 0) {
        UIButton *aButton = nil;
        for (NSNumber *indexNum in buttonIndexes_) {
            NSInteger buttonIndex = [indexNum intValue];
            aButton = [_mCachedButtons safeObjectAtIndex:buttonIndex];
            aButton.enabled = !isDisabled_;
            if (_mCurrentIndex == buttonIndex) {
                _mBottomSelectionView.hidden = isDisabled_;
            }
        }
    }
}

- (LCButton *)buttonWithTitle:(NSString *)buttonTitle_ frame:(CGRect)buttonFrame_ index:(NSInteger)buttonIndex_ {
    
    LCButton *theButton = [LCButton buttonWithType:UIButtonTypeCustom];
    theButton.frame     = buttonFrame_;
    theButton.tag       = [self tagAtIndex:buttonIndex_];
    
    theButton.titleLabel.font = _mButtonConfiguration.mFont;
    theButton.backgroundColor = _mButtonConfiguration.mNormalBackgroundColor;
    
    [theButton setTitleColor:_mButtonConfiguration.mNormalTextColor    forState:UIControlStateNormal];
    [theButton setTitleColor:_mButtonConfiguration.mSelectionTextColor forState:UIControlStateHighlighted];
    [theButton setTitleColor:_mButtonConfiguration.mSelectionTextColor forState:UIControlStateSelected];
    [theButton setTitle:buttonTitle_ forState:UIControlStateNormal];
    [theButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_mButtonConfiguration.mShouldAddSplitLine) {
        CGRect lineFrame = CGRectZero;
        lineFrame.size.width = 0.5f;
        lineFrame.origin.x = buttonFrame_.size.width - lineFrame.size.width;
        lineFrame.origin.y = _mButtonConfiguration.mSplitLineMargin;
        lineFrame.size.height = buttonFrame_.size.height - 2 * lineFrame.origin.y;
        UIView *splitLineView = [[UIView alloc] initWithFrame:lineFrame];
        splitLineView.backgroundColor = _mButtonConfiguration.mSplitLineColor;
        [theButton addSubview:splitLineView];
        [splitLineView release];
    }
    
    return theButton;
}

- (NSInteger)tagAtIndex:(NSInteger)index_ {
    return 1000 + index_;
}

- (NSInteger)indexForTag:(NSInteger)tag_ {
    return tag_ - 1000;
}

- (void)buttonClicked:(LCButton *)aButton_ {
    [self setSelectedIndex:[self indexForTag:aButton_.tag] shouldSendMessageToDelegate:YES];
}

- (void)setSelectedIndex:(NSInteger)index_ shouldSendMessageToDelegate:(BOOL)shouldSend_ {
    if (_mCurrentIndex != index_) {
        [self buttonAtIndex:_mCurrentIndex].selected = NO;
        self.mCurrentIndex = index_;
        LCButton *selectedButton = [self buttonAtIndex:index_];
        self.mLastSelectedButton = selectedButton;
        selectedButton.selected  = YES;
        
        CGRect targetFrame       = _mBottomSelectionView.frame;
        targetFrame.origin.x     = index_ * _mButtonConfiguration.mButtonWidth;
        
//        self.userInteractionEnabled = NO;
        _mBottomSelectionView.alpha = 1.f;
        _mBottomSelectionView.hidden = NO;
        __block LCMenuBar *weakSelf = self;
        switch (_mButtonConfiguration.mSelectionAnimationType) {
            case LCMenuBarSelectionAnimationTypeMove:
                [UIView animateWithDuration:0.2f animations:^{
                     weakSelf.mBottomSelectionView.frame = targetFrame;
                 } completion:^(BOOL finished) {
                     
                 }];
                break;
            case LCMenuBarSelectionAnimationTypeFadeOutIn:
                [UIView animateWithDuration:0.1f animations:^{
                     weakSelf.mBottomSelectionView.alpha = 0.f;
                 } completion:^(BOOL finished) {
                     weakSelf.mBottomSelectionView.frame = targetFrame;
                     [UIView animateWithDuration:0.2f animations:^{
                         weakSelf.mBottomSelectionView.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         
                     }];
                 }];
                break;
            default:
                self.mBottomSelectionView.frame = targetFrame;
                break;
        }
        
        if (shouldSend_) {
            [_mMenuBarDelegate menuBar:self didSelectButtonAtIndex:_mCurrentIndex];
        }
    }
}

- (LCButton *)buttonAtIndex:(NSInteger)index_ {
    LCButton *resultButton = nil;
    for (LCButton *aButton in _mCachedButtons) {
        if ([self indexForTag:aButton.tag] == index_) {
            resultButton = aButton;
            break;
        }
    }
    return resultButton;
}

- (void)changeCurrentIndex:(NSInteger)targetIndex_ {
    [self changeCurrentIndex:targetIndex_ shouldSendMessage:NO];
}

- (void)changeCurrentIndex:(NSInteger)targetIndex_ shouldSendMessage:(BOOL)shouldSend_ {
    if (targetIndex_ >= 0 && targetIndex_ < [_mCachedButtons count]) {
        [self setSelectedIndex:targetIndex_ shouldSendMessageToDelegate:shouldSend_];
    }
}

@end
