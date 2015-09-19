//
//  EPDayCell.m
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//


#import "EPDayCell.h"

#define ICON_WH  40

@interface EPDayCell ()

@end

@implementation EPDayCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = K_COLOR_WHITE_TEXT;
        
        _EPDayCellBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 60)];
        _EPDayCellBg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_EPDayCellBg];
        
    
        
        _EPDayCellIcon = [[UIImageView alloc] init];
        [_EPDayCellIcon setFrame:CGRectMake(10, 10, ICON_WH, ICON_WH)];
        
        _EPDayCellTitle   = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, K_SCREEN_WIDTH-100, 20)];
        _EPDayCellSTime   = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, K_SCREEN_WIDTH-100, 20)];
        _EPDayCellCost    = [[UILabel alloc] initWithFrame:CGRectMake(K_SCREEN_WIDTH - 70, 10, 60, 40)];
        
        [self.contentView addSubview:_EPDayCellIcon];
        
        
        _EPDayCellTitle.textColor = K_COLOR_DARK_TEXT;
        _EPDayCellTitle.textAlignment = NSTextAlignmentLeft;
        _EPDayCellTitle.font = [UIFont fontWithName:FONT_H size:14];
        [self.contentView addSubview:_EPDayCellTitle];
        
        _EPDayCellSTime.textColor = K_COLOR_GRAY_FONT;
        _EPDayCellSTime.textAlignment = NSTextAlignmentLeft;
        _EPDayCellSTime.font = [UIFont fontWithName:FONT_H size:13];
        [self.contentView addSubview:_EPDayCellSTime];
 
        _EPDayCellCost.textColor = K_COLOR_ORANGE_TEXT;
        _EPDayCellCost.textAlignment = NSTextAlignmentRight;
        _EPDayCellCost.font = [UIFont fontWithName:FONT_H size:14];
        [self.contentView addSubview:_EPDayCellCost];
    
    }
    return self;
}

- (void)setCellBackground:(CGFloat)celHeight
{
//    [_EPDayCellBg setFrame:CGRectMake(0, 5, SCREEN_WIDTH, celHeight)];
////    [_OMCellOPView setFrame:CGRectMake(SCREEN_WIDTH - 100 -10  , celHeight-35, 110, 40)];
}

+ (CGFloat)calHeightForText:(NSString *)text
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *fontAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};

    return [text boundingRectWithSize:CGSizeMake(K_SCREEN_WIDTH - ICON_WH - 10 , 1000)
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:fontAttr context:nil].size.height;

    
}

- (void)setEPDayCellIcon:(UIImage *)IconImg{
    _EPDayCellIcon.image = IconImg;
}
- (void)setEPDayCellTitle:(NSString *)ParkingTitle
        setEPDayCellSTime:(NSString *)StartTime
         setEPDayCellCost:(NSString *)ParkingCost
{
    _EPDayCellTitle.text  = ParkingTitle;
    _EPDayCellSTime.text = StartTime;
    _EPDayCellCost.text  = ParkingCost;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
