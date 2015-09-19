//
//  EPSDayCell.h
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EPCarGarageCell : UITableViewCell
{
    UIImageView         *_EPCarGarageCellBg;
    UILabel             *_EPCarGarageCellTitle, *_EPCarGarageCellDetail;
}

+ (CGFloat)calHeightForText:(NSString *)text;

- (void)setCellBackground:(CGFloat)celHeight;

- (void)setEPCarGarageCellTitle:(NSString *)cellTitle
       setEPCarGarageCellDetail:(NSString *)cellDetail;



@end
