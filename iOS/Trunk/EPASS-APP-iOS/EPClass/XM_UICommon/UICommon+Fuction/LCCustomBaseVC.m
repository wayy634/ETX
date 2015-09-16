//
//  LCCustomBaseVC.m
//  LeCai
//
//  Created by lehecaiminib on 14-12-2.
//
//

#import "LCCustomBaseVC.h"
#import "AppDelegate.h"


@interface LCCustomBaseVC () <UIGestureRecognizerDelegate>
@end

@implementation LCCustomBaseVC
@synthesize mTopView,mContentView,mIsControlWithContentV, mBottomMenuV,mActivityV,mCustomBaseType;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view setFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    self.mTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SYSTEM_BAR + K_NAVIGATION_BAR_HEIGHT)];
    [self.mTopView setBackgroundColor:[XMThemeManager sharedThemeManager].mThemeManagerType == XMThemeManagerTypeNormal?[UIColor whiteColor]:[LTools colorWithHexString:@"0090ff"]];
    [self.view addSubview:self.mTopView];

    mTitleLabel = [[UILabel alloc] init];
    [mTitleLabel setFrame:CGRectMake(0, K_SYSTEM_BAR, mTopView.width, mTopView.height - K_SYSTEM_BAR)];
    [mTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mTitleLabel setTextColor:K_COLOR_MAIN_FONT];
    [mTitleLabel setFont:K_FONT_SIZE(16)];
    [mTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.mTopView addSubview:mTitleLabel];
    [self setTitle:mTitleStr];
    
    CGFloat topY = self.mTopView.bottom;
    CGFloat tmpheight = self.view.height - self.mTopView.height;
    mContentView = [[UIView alloc] initWithFrame:CGRectMake(0, topY, K_SCREEN_WIDTH, tmpheight)];
    [mContentView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mContentView];
    [self.view bringSubviewToFront:self.mTopView];
    
    if (self.mCustomBaseType == LCCustomBaseVCTypeRoot) {
        [mContentView setFrame:CGRectMake(0, self.mTopView.bottom, K_SCREEN_WIDTH, self.view.height - self.mTopView.bottom)];
    }
    mBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mBackButton setTag:LCBOTTOMMENUV_BACKBUTTON];
    
    [mBackButton setImage:[UIImage imageWithPDFNamed:@"btn_nav_back.pdf" atSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    mBackButton.adjustsImageWhenHighlighted = NO;
    [mBackButton setFrame:CGRectMake(10, K_SYSTEM_BAR/2 + (self.mTopView.height - 30)/2, 100, 30)];
    [mBackButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, mBackButton.width-30)];
    [mBackButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.mTopView addSubview:mBackButton];
    
    [self.view addSubview:[LCUITools creatLineView:CGRectMake(0, topY-0.5, K_SCREEN_WIDTH, 0.5) bgColor:[LTools colorWithHexString:@"dddddd"]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --
#pragma mark self fuction
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (APP_DELEGATE.mNavigationController.viewControllers.count <= 1) {
        return NO;
    } else {
       return YES;
    }
}


- (void)backButtonPressed {
    if (self.navigationController == APP_DELEGATE.mNavigationController) {
        if (self.mCustomBaseType == LCCustomBaseVCTypeNormal) {
            [LTools cancelUnfinishedRequest];
            [LTools popControllerAnimated:YES];
        }else if (self.mCustomBaseType == LCCustomBaseVCTypeRoot) {
            [APP_DELEGATE.mDDMenu showLeftController:YES];
        }
        
    }
}

- (void)initTopLeftV:(NSArray *)_data {
    double totalWidth = 0;
    for (int i = 0; i < [_data count]; i++) {
        UIView *temp = [_data objectAtIndex:i];
        [temp setFrame:CGRectMake(LCCUSTOMBASEVC_TOPRIGHT_OFFSET_X*(i+1) + totalWidth,K_SYSTEM_BAR/2 + (mTopView.height - temp.height)/2, temp.width, temp.height)];
        totalWidth += temp.width;
        [self.mTopView addSubview:temp];
    }
}

- (void)setTopViewHidden:(BOOL)_hidden {
    if (_hidden) {
        [self.mTopView setBackgroundColor:[UIColor clearColor]];
        [mContentView setFrame:self.view.frame];
    } else {
        [self.mTopView setBackgroundColor:[LTools colorWithHexString:@"F13131"]];
        CGRectMake(0, self.mTopView.bottom, K_SCREEN_WIDTH, self.view.height - self.mTopView.bottom);
    }
}

- (void)initTopRightV:(NSArray *)_data {
    double totalWidth = 0;
    for (int i = 0; i < [_data count]; i++) {
        UIView *temp = [_data objectAtIndex:i];
        totalWidth += temp.width;
        [temp setFrame:CGRectMake(K_SCREEN_WIDTH - LCCUSTOMBASEVC_TOPRIGHT_OFFSET_X*(i+1) - totalWidth,K_SYSTEM_BAR/2 + (self.mTopView.height - temp.height)/2, temp.width, temp.height)];
        [self.mTopView addSubview:temp];
    }
}

- (id)initCustomVCType:(LCCustomBaseVCType)_type {
    if ((self = [super init])) {
        self.mCustomBaseType = _type;
        if (self.mCustomBaseType == LCCustomBaseVCTypeNormal && [LTools isGreatherThanIOS7]) {
//            APP_DELEGATE.mNavigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
    return self;
}

- (void)setTitle:(NSString *)_titleText {
    mTitleStr = _titleText;
    if (mTitleLabel != nil) {
        [mTitleLabel setHidden:NO];
        [mTitleLabel setText:mTitleStr];
    }
}

- (void)reSetCustomTitle:(UIView *)_customView {
    [mTitleLabel setHidden:YES];
    _customView.tag = LCBOTTOMMENUV_RESETTITLE_OBJECT_ID;
    [_customView setFrame:CGRectMake((self.mTopView.width - _customView.width)/2, (self.mTopView.height - _customView.height)/2 + K_SYSTEM_BAR/2, _customView.width, _customView.height)];
    [self.mTopView addSubview:_customView];
}

- (UIActivityIndicatorView *)mActivityV {
    if(!mActivityV) {
        mActivityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        mActivityV.hidesWhenStopped = YES;
        [self.mTopView addSubview:mActivityV];
    }
    UIView *tempV = [mTopView viewWithTag:LCBOTTOMMENUV_RESETTITLE_OBJECT_ID];
    if (tempV != nil) {
        [mActivityV setFrame:CGRectMake(tempV.right + 2.f, tempV.top, tempV.height, tempV.height)];
    } else {
        CGFloat textWidth = [mTitleLabel.text sizeWithFont:mTitleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT,MAXFLOAT)].width;
       [mActivityV setFrame: CGRectMake((mTitleLabel.width + textWidth) / 2.f + 2.f, mTitleLabel.top, mTitleLabel.height, mTitleLabel.height)];
    }
    return mActivityV;
}

#pragma mark --

- (void)dealloc {
    [self.mTopView release] , self.mTopView = nil;
    [mTitleLabel release] , mTitleLabel = nil;
    [mContentView release] , mContentView = nil;
    mTitleStr = nil;
    mBottomMenuV = nil;
    if (mActivityV) {
        [mActivityV release] , mActivityV = nil;
    }
    [super dealloc];
}
@end
