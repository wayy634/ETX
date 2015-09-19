//
//  EPSMonthCell.h
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EPSMonthCell : UITableViewCell
{
    UIImageView         *_EPSMonthCellBg;
    UILabel             *_EPSMonthCellMonthTitle, *_EPSMonthCellMonthCost;
}

+ (CGFloat)calHeightForText:(NSString *)text;

- (void)setCellBackground:(CGFloat)celHeight;

- (void)setEPSMonthCellTitle:(NSString *)MonthTitle
         setEPSMonthCellCost:(NSString *)MonthCost;


@end
