//
//  XMBottomMenuButton.h
//  XiaoMai
//
//  Created by Jeanne on 15/5/11.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMBottomMenuButton : UIButton
@property (nonatomic, strong) UIButton *mTopIconButton;
/**
 *  初始化角标
 */
- (void)initTopIconUI;

/**
 *  设置角标
 *  @param _image            图片
 */
- (void)setTopIconImage:(UIImage *)image_;

/**
 *  设置角标
 *  @param string_           title
 */
- (void)setTopIconString:(NSString *)string_;

/**
 *  设置角标状态
 *  @param _hidden           hidden
 */
- (void)setTopIconImageState:(BOOL)hidden_;
@end
