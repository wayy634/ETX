//
//  XMDrawLineLabel.h
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/5/9.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XMDrawLineType) {
    XMDrawLineTypeTop,
    XMDrawLineTypeMid,
    XMDrawLineTypeDown
};

@interface XMDrawLineLabel : UILabel
/**
 *  @param frame_               frame
 *  @param lineType_            划线的type
 *  @param lineColor_           划线的颜色
 */
- (id)initWithFrame:(CGRect)frame_ lineType:(XMDrawLineType)lineType_ lineColor:(UIColor *)lineColor_;
@end
