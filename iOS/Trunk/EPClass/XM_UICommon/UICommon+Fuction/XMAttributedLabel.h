//
//  XMAttributedLabel.h
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/5/6.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XMAttributedType) {
    XMAttributedTypeColor,
    XMAttributedTypeFont,
    XMAttributedTypeParagraph
};

@interface XMAttributedLabel : UILabel
/**
 *  @param string_ 显示内容
 */
- (void)setXMAttributedString:(NSString *)string_;

/**
 *  @param xmAttributedType_ 修改字体的type
 *  @param value_            修改字体的内容
 *  @param range_            修改字体的范围
 */
- (void)addAttributeType:(XMAttributedType)xmAttributedType_ value:(id)value_ range:(NSRange)range_;

/**
 *  @param value_            修改字体的内容
 *  @param range_            修改字体的范围
 */
- (void)addAttributeDictionary:(NSDictionary *)value_ range:(NSRange)range_;

/**
 *  render
 */
- (void)renderAttribute;

@end
