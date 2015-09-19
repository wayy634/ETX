//
//  EPSDayCell.h
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EPAccountCell : UITableViewCell
{
    UIImageView         *_EPAccountCellBg, *_EPAccountCellDayIcon;
    UILabel             *_EPAccountCellDayTitle;
}

+ (CGFloat)calHeightForText:(NSString *)text;

- (void)setCellBackground:(CGFloat)celHeight;

- (void)setEPAccountCellIcon:(UIImage  *)cellIcon
       setEPAccountCellTitle:(NSString *)cellTitle;


@end
