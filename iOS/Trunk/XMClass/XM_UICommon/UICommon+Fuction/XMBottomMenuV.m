//
//  XMBottomMenuV.m
//  XiaoMai
//
//  Created by Jeanne on 15/5/11.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMBottomMenuV.h"
#import "XMBottomMenuButton.h"
#import "LCCustomAnimationPointV.h"

#import "XMHomePageVC.h"
#import "XMMyVC.h"
#import "XMShoppingCartVC.h"

#define XMBOTTOMMENUV_BUTTON_WIDTH 100
#define XMBOTTOMMENUV_BUTTON_HEIGHT 39

#define XMBOTTOMMENUV_BUTTON_OFFSET_X (K_SCREEN_WIDTH - XMBOTTOMMENUV_BUTTON_WIDTH*3)/4

@interface XMBottomMenuV ()
@property (nonatomic, strong)NSMutableArray            *mButtomArray;
@property (nonatomic, strong)NSMutableArray            *mRootVCArray;
@property (nonatomic, strong)NSMutableArray            *mRootVCIndexArray;
@property (nonatomic, strong)NSMutableArray            *mButtonNormalImageArray;
@property (nonatomic, strong)NSMutableArray            *mButtonSelectedImageArray;
@property (nonatomic, assign)int                        mCurrentIndex;
@property (nonatomic, assign)XMBottomMenuImageType      mBottomMenuImageType;
//@property (nonatomic, strong)LCCustomAnimationPointV   *mPathAnimationPointV;
@end

@implementation XMBottomMenuV
- (id)initBottomMenuV {
    if (self == [super init]) {
        self.mCurrentIndex = -1;
        [self setFrame:CGRectMake(0, K_SCREEN_HEIGHT - K_XMBOTTOMMENUV_HEIGHT, K_SCREEN_WIDTH, K_XMBOTTOMMENUV_HEIGHT)];
        [self setBackgroundColor:[XMThemeManager sharedThemeManager].mThemeManagerType == XMThemeManagerTypeNormal?[LTools colorWithHexString:@"f9f9f9"]:[LTools colorWithHexString:@"3c3c3c"]];
        [self addSubview:[LCUITools creatLineView:CGRectMake(0, 0, self.width, 0.5) bgColor:[LTools colorWithHexString:@"b8b8b8"]]];
        self.mButtomArray = [[NSMutableArray alloc] init];
        self.mRootVCArray = [[NSMutableArray alloc] init];
        self.mRootVCIndexArray = [[NSMutableArray alloc] init];
        self.mButtonNormalImageArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"BottomMenu_HomePage_Normal",@"BottomMenu_ShoppingCart_Normal",@"BottomMenu_My_Normal",nil]];
        self.mButtonSelectedImageArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"BottomMenu_HomePage_Selected",@"BottomMenu_ShoppingCart_Selected",@"BottomMenu_My_Selected",nil]];
        for (int i = 0; i < [self.mButtonNormalImageArray count]; i ++) {
            XMBottomMenuButton *tempButton = [XMBottomMenuButton buttonWithType:UIButtonTypeCustom];
            [tempButton setTag:i];

            [tempButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[self.mButtonNormalImageArray objectAtIndex:i],[XMThemeManager sharedThemeManager].mThemeManagerType == XMThemeManagerTypeNormal?@"_Theme_Normal.png":@"_Theme_Fast.png"]] forState:UIControlStateNormal];
            [tempButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[self.mButtonSelectedImageArray objectAtIndex:i],[XMThemeManager sharedThemeManager].mThemeManagerType == XMThemeManagerTypeNormal?@"_Theme_Normal.png":@"_Theme_Fast.png"]] forState:UIControlStateSelected];
            [tempButton setFrame:CGRectMake((XMBOTTOMMENUV_BUTTON_OFFSET_X*(i+1)) + i*XMBOTTOMMENUV_BUTTON_WIDTH, (self.height - XMBOTTOMMENUV_BUTTON_HEIGHT)/2, XMBOTTOMMENUV_BUTTON_WIDTH, XMBOTTOMMENUV_BUTTON_HEIGHT)];
//            [tempButton setTopIconImage:[UIImage imageNamed:@"icon_msgCenter_unRead.png"]];
            [tempButton initTopIconUI];
            [tempButton setTopIconImageState:YES];
            [self addSubview:tempButton];
            [self.mButtomArray addObject:tempButton];
            [tempButton addTarget:self action:@selector(bottomVButtonPressed:animation:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.mBottomMenuImageType = XMBottomMenuImageTypeNomal;
        
        
//        self.mPathAnimationPointV = [[LCCustomAnimationPointV alloc] initCustomKeyAnimation:[UIImage imageNamed:@"icon_chooseNum_animation_ball.png"]];
//        [self.mPathAnimationPointV setFrame:CGRectMake(K_SCREEN_WIDTH, K_SCREEN_HEIGHT, self.mPathAnimationPointV.width, self.mPathAnimationPointV.height)];
//        [self.mPathAnimationPointV setHidden:YES];
//        [self addSubview:self.mPathAnimationPointV];
    }
    return self;
}

- (void)bottomVSelected:(XMBottomMenuVRootType)_type animation:(BOOL)animation_ {
    [self bottomVButtonPressed:[self.mButtomArray objectAtIndex:_type] animation:animation_];
}

- (void)reSetBottomMenuButtonState:(XMBottomMenuVRootType)_index cornerState:(BOOL)_state {
    XMBottomMenuButton *tempButton = [self.mButtomArray objectAtIndex:_index];
    [tempButton setTopIconImageState:!_state];
}

- (id)checkRootControllerIsAlreadyHave:(XMBottomMenuVRootType)_type {
    id object = nil;
    for (int i = 0; i < [self.mRootVCIndexArray count]; i++) {
        if ([[self.mRootVCIndexArray objectAtIndex:i] intValue] == _type) {
            object = [self.mRootVCArray objectAtIndex:i];
        }
    }
    return object;
}

- (id)getRootControllerAndCreat:(XMBottomMenuVRootType)_type {
    self.mCurrentIndex = _type;
    id object = nil;
    object = [self getRootController:_type];
    if (object != nil) {
        return object;
    }
    
    switch (_type) {
        case XMBottomMenuVTypeHomePage:{
            XMHomePageVC *home = [[XMHomePageVC alloc] initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCArray addObject:home];
            [self.mRootVCIndexArray addObject:[NSNumber numberWithInt:_type]];
            [home release];
            object = home;
            break;
        }
        case XMBottomMenuVTypeShoppingCart:{
            XMShoppingCartVC *shoppingCart = [[XMShoppingCartVC alloc] initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCArray addObject:shoppingCart];
            [self.mRootVCIndexArray addObject:[NSNumber numberWithInt:_type]];
            [shoppingCart release];
            object = shoppingCart;
            break;
        }
        case XMBottomMenuVTypeMy:{
            XMMyVC *my = [[XMMyVC alloc] initCustomVCType:LCCustomBaseVCTypeRoot];
            [self.mRootVCArray addObject:my];
            [self.mRootVCIndexArray addObject:[NSNumber numberWithInt:_type]];
            [my release];
            object = my;
            break;
        }
    }
    return object;
}

- (id)getRootController:(XMBottomMenuVRootType)_type {
    for (int i = 0; i < [self.mRootVCIndexArray count]; i++) {
        if ([[self.mRootVCIndexArray objectAtIndex:i] intValue] == _type) {
            return (id)[self.mRootVCArray objectAtIndex:i];
        }
    }
    return nil;
}

- (void)bottomVButtonPressed:(UIButton *)_sender animation:(BOOL)animation_ {
    if (_sender.selected) {
        if ([[APP_DELEGATE.mNavigationController viewControllers] count] > 1) {
            [LTools cancelUnfinishedRequest];
            [LTools popToRootViewControllerAnimated:animation_];
        }
        return;
    }
    [LTools cancelUnfinishedRequest];
    [LTools popToRootViewControllerAnimated:NO];
    [self.mButtomArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (!obj.selected && obj == _sender) {
            obj.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
    id object = [self getRootControllerAndCreat:_sender.tag];
    self.mBottomMenuVDelegate = object;
    [self.mBottomMenuVDelegate bottomVDelegateButtonPressed:_sender.tag controller:object];
    object = nil;
}

- (void)setPromptCount:(NSString *)string_ animation:(BOOL)animation_ {
    if (string_ != nil) {
        [[self.mButtomArray objectAtIndex:XMBottomMenuVTypeShoppingCart] setTopIconImageState:NO];
        [[self.mButtomArray objectAtIndex:XMBottomMenuVTypeShoppingCart] setTopIconString:string_];
        if (animation_) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values   = @[@(1.0), @(1.1), @(1.3), @(1.2),@(1.1), @(1.0)];
            animation.keyTimes = @[@(0.0), @(0.1), @(0.2), @(0.3),@(0.4), @(0.5)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [LCCustomAnimationPointV startAnimation:[self.mButtomArray objectAtIndex:XMBottomMenuVTypeShoppingCart] animationGroupArray:[NSArray arrayWithObjects:animation, nil] durationTime:0.5];
        }
    } else {
        [[self.mButtomArray objectAtIndex:XMBottomMenuVTypeShoppingCart] setTopIconString:@""];
        [[self.mButtomArray objectAtIndex:XMBottomMenuVTypeShoppingCart] setTopIconImageState:YES];
    }
}

- (void)pathAnimation:(CGPoint)point_ orderCount:(NSString *)count_ animation:(BOOL)animation_ {
    LCCustomAnimationPointV *tempAnimation = [[[LCCustomAnimationPointV alloc] initCustomKeyAnimation:[UIImage imageNamed:@"circel.png"]] autorelease];
    [tempAnimation setFrame:CGRectMake(K_SCREEN_WIDTH, K_SCREEN_HEIGHT, tempAnimation.width, tempAnimation.height)];
    [APP_DELEGATE.mWindow addSubview:tempAnimation];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,point_.x,point_.y);
    CGPathAddCurveToPoint(path,NULL,point_.x,point_.y,point_.x,point_.y - 200,self.width/2,self.bottom);
    [tempAnimation startBaiduChooseBallPathAnimationpathFrame:path success:^{
        [self setPromptCount:count_ animation:YES];
        [tempAnimation removeFromSuperview];
    }];
    
}

#pragma mark--
#pragma mark XMListCellItemVDelegate
- (void)animationPoint:(CGPoint)point_ {

}

- (void)dealloc {
    [self.mButtomArray release] , self.mButtomArray = nil;
    [self.mRootVCArray release] , self.mRootVCArray = nil;
    [self.mRootVCIndexArray release] , self.mRootVCIndexArray = nil;
    [self.mButtonNormalImageArray release] , self.mButtonNormalImageArray = nil;
    [self.mButtonSelectedImageArray release] , self.mButtonSelectedImageArray = nil;
//    [self.mPathAnimationPointV release] , self.mPathAnimationPointV = nil;
    self.mBottomMenuVDelegate = nil;
    [super dealloc];
}

@end
