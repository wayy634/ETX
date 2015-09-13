//
//  XMBottomMenuV.h
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/5/11.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <UIKit/UIKit.h>
#define K_XMBOTTOMMENUV_HEIGHT 49

typedef NS_ENUM(NSInteger, XMBottomMenuVRootType) {
    XMBottomMenuVTypeHomePage = 0,
    XMBottomMenuVTypeShoppingCart = 1,
    XMBottomMenuVTypeMy = 2
};

typedef NS_ENUM(NSInteger, XMBottomMenuImageType) {
    XMBottomMenuImageTypeNomal = 0,
    XMBottomMenuImageTypeSpecail = 1,
};

@protocol XMBottomMenuVDelegate
@optional
- (void)bottomVDelegateButtonPressed:(XMBottomMenuVRootType)type_ controller:(id)controller_;
@end

@interface XMBottomMenuV : UIView

@property (nonatomic,assign)id<XMBottomMenuVDelegate>   mBottomMenuVDelegate;

/**
 *  初始化
 */
- (id)initBottomMenuV;

/**
 *  检测缓存root类
 *  @param _type            root类型
 */
- (id)checkRootControllerIsAlreadyHave:(XMBottomMenuVRootType)_type;

/**
 *  选择页面
 *  @param _type            root类型
 */
- (void)bottomVSelected:(XMBottomMenuVRootType)_type animation:(BOOL)animation_;

/**
 *  设置下方menu是否有红点
 *  @param _index            索引
 *  @param _state            状态
 */
- (void)reSetBottomMenuButtonState:(XMBottomMenuVRootType)_index cornerState:(BOOL)_state;

/**
 *  动画角标
 *  @param _string     物品的个数
 *  @param animation_  是否要动画
 */
- (void)setPromptCount:(NSString *)string_ animation:(BOOL)animation_;

/**
 *  路径动画
 *  @param point_      动画path初始点
 *  @param count_      订单个数
 *  @param animation_  是否要动画
 */
- (void)pathAnimation:(CGPoint)point_ orderCount:(NSString *)count_ animation:(BOOL)animation_;
@end
