//
//  EPSDayCell.m
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//


#import "EPSDayCell.h"

#define ICON_WH  40

@interface EPSDayCell ()

@end

@implementation EPSDayCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = K_COLOR_WHITE_TEXT;
        
        _EPSDayCellBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 60)];
        _EPSDayCellBg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_EPSDayCellBg];
    
        UIImageView  *grayLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60-0.5, K_SCREEN_WIDTH, 0.5)];
        grayLine.backgroundColor           = K_COLOR_GRAY_FONT;
        grayLine.alpha                     = 0.4;
        [self.contentView addSubview:grayLine];
        
        _EPSDayCellDaySum     = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, K_SCREEN_WIDTH-100, 20)];
        _EPSDayCellDayTitle   = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, K_SCREEN_WIDTH-100, 20)];
        _EPSDayCellDayCost    = [[UILabel alloc] initWithFrame:CGRectMake(K_SCREEN_WIDTH - 70, 10, 60, 20)];
        _EPSDayCellDayType    = [[UILabel alloc] initWithFrame:CGRectMake(K_SCREEN_WIDTH - 70, 30, 60, 20)];
        
        _EPSDayCellDaySum.textColor = K_COLOR_DARK_TEXT;
        _EPSDayCellDaySum.textAlignment = NSTextAlignmentLeft;
        _EPSDayCellDaySum.font = [UIFont fontWithName:FONT_H size:14];
        [self.contentView addSubview:_EPSDayCellDaySum];
        
        _EPSDayCellDayTitle.textColor = K_COLOR_GRAY_FONT;
        _EPSDayCellDayTitle.textAlignment = NSTextAlignmentLeft;
        _EPSDayCellDayTitle.font = [UIFont fontWithName:FONT_H size:12];
        [self.contentView addSubview:_EPSDayCellDayTitle];
 
        _EPSDayCellDayCost.textColor = K_COLOR_ORANGE_TEXT;
        _EPSDayCellDayCost.textAlignment = NSTextAlignmentRight;
        _EPSDayCellDayCost.font = [UIFont fontWithName:FONT_H size:14];
        [self.contentView addSubview:_EPSDayCellDayCost];
    
        _EPSDayCellDayType.textColor = K_COLOR_GRAY_FONT;
        _EPSDayCellDayType.textAlignment = NSTextAlignmentRight;
        _EPSDayCellDayType.font = [UIFont fontWithName:FONT_H size:12];
        [self.contentView addSubview:_EPSDayCellDayType];
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

- (void)setEPSDayCellSum:(NSString *)DaySum
        setEPSDayCellDay:(NSString *)DayTitle
       setEPSDayCellCost:(NSString *)DayCost
       setEPSDayCellType:(NSString *)DayType
{
    _EPSDayCellDaySum.text   = DaySum;
    _EPSDayCellDayTitle.text = DayTitle;
    _EPSDayCellDayCost.text  = DayCost;
    _EPSDayCellDayType.text  = DayType;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
