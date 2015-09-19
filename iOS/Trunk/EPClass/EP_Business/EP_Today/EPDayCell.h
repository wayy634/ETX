//
//  EPDayCell.h
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EPDayCell : UITableViewCell
{
    UIImageView         *_EPDayCellBg, *_EPDayCellIcon;
    UILabel             *_EPDayCellTitle, *_EPDayCellCost, *_EPDayCellSTime;
}

+ (CGFloat)calHeightForText:(NSString *)text;

- (void)setCellBackground:(CGFloat)celHeight;

- (void)setEPDayCellIcon:(UIImage *)IconImg;

- (void)setEPDayCellTitle:(NSString *)ParkingTitle
        setEPDayCellSTime:(NSString *)StartTime
         setEPDayCellCost:(NSString *)ParkingCost;


@end
