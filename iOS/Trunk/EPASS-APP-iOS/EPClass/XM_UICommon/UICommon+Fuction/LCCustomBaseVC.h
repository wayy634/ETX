//
//  LCCustomBaseVC.h
//  LeCai
//
//  Created by lehecaiminib on 14-12-2.
//
//

#import <UIKit/UIKit.h>
#import "LCBaseViewController.h"
#define LCCUSTOMBASEVC_ANIMATION_DURATION 0.5
#define LCCUSTOMBASEVC_ANIMATION_DELAY 0.0
#define LCCUSTOMBASEVC_TOPRIGHT_OFFSET_X 10
#define LCBOTTOMMENUV_BACKBUTTON 9999
#define LCBOTTOMMENUV_RESETTITLE_OBJECT_ID 9998

typedef NS_ENUM(NSInteger, LCCustomBaseVCType) {
    LCCustomBaseVCTypeRoot = 0,
    LCCustomBaseVCTypeNormal = 1
};
typedef NS_ENUM(NSInteger, BottomAnimationType) {
    BottomAnimationTypeShow = 0,
    BottomAnimationTypeDisappear = 1
};

@class XMBottomMenuV;
@interface LCCustomBaseVC : LCBaseViewController  {
    UIView                  *mTopView;//顶部
    UILabel                 *mTitleLabel;//标题
    NSString                *mTitleStr;
    UIView                  *mContentView;//内容视图
    UIButton                *mBackButton;//后退
    XMBottomMenuV           *mBottomMenuV;//底部
    BOOL                    mIsControlWithContentV;//是否交由父类处理动画后设置contentV的frame
    LCCustomBaseVCType      mCustomBaseType;//类对象类型
    UIActivityIndicatorView *mActivityV; //静默刷新圈圈
}

@property (nonatomic,assign)UIView                  *mTopView;
@property (nonatomic,assign)UIView                  *mContentView;
@property (nonatomic,assign)XMBottomMenuV           *mBottomMenuV;
@property (assign)BOOL                              mIsControlWithContentV;
@property (assign)LCCustomBaseVCType                mCustomBaseType;
@property (nonatomic,assign)UIActivityIndicatorView *mActivityV;

//视图类别
- (id)initCustomVCType:(LCCustomBaseVCType)_type;

//设置标题
- (void)setTitle:(NSString *)_titleText;

//重设title控件 父类默认把传进来的view对象添加在title位置
- (void)reSetCustomTitle:(UIView *)_customView;

//后退
- (void)backButtonPressed;

//右上角显示的活动或功能按钮(array中传view对象)
- (void)initTopRightV:(NSArray *)_data;

//左上角显示的活动或功能按钮(array中传view对象)
- (void)initTopLeftV:(NSArray *)_data;

//设置mTopView,从新refresh mContentView的frame
- (void)setTopViewHidden:(BOOL)_hidden;
@end
