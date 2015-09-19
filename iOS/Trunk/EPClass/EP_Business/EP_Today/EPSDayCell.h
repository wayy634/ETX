//
//  EPSDayCell.h
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EPSDayCell : UITableViewCell
{
    UIImageView         *_EPSDayCellBg;
    UILabel             *_EPSDayCellDaySum, *_EPSDayCellDayTitle, *_EPSDayCellDayCost, *_EPSDayCellDayType;
}

+ (CGFloat)calHeightForText:(NSString *)text;

- (void)setCellBackground:(CGFloat)celHeight;

- (void)setEPSDayCellSum:(NSString *)DaySum
        setEPSDayCellDay:(NSString *)DayTitle
       setEPSDayCellCost:(NSString *)DayCost
       setEPSDayCellType:(NSString *)DayType;


@end
