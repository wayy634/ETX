//
//  XMPushLogicButton.h
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/5/12.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMPushLogicButton : UIButton

//@property (nonatomic, strong)CategroyModel *mCategroyModel;
/**
 *  设置跳转逻辑button数据
 *  @param data_           数据
 */
- (void)initNormalImage:(NSString *)imageUrl_ placeholderImage:(NSString *)placeholderImage_;

/**
 *  refresh跳转逻辑button数据
 *  @param data_           数据
 */
- (void)refreshNormalImage:(NSString *)imageUrl_ placeholderImage:(NSString *)placeholderImage_;
@end
