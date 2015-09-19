//
//  EPSMonthCell.m
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//

#import "EPSMonthCell.h"

#define ICON_WH  40

@interface EPSMonthCell ()

@end

@implementation EPSMonthCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = K_COLOR_WHITE_TEXT;
        
        _EPSMonthCellBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 50)];
        _EPSMonthCellBg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_EPSMonthCellBg];
    
        _EPSMonthCellMonthTitle     = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, K_SCREEN_WIDTH-100, 30)];
        _EPSMonthCellMonthCost      = [[UILabel alloc] initWithFrame:CGRectMake(K_SCREEN_WIDTH - 70, 10, 60, 30)];
        
        _EPSMonthCellMonthTitle.textColor = K_COLOR_DARK_TEXT;
        _EPSMonthCellMonthTitle.textAlignment = NSTextAlignmentLeft;
        _EPSMonthCellMonthTitle.font = [UIFont fontWithName:FONT_H size:14];
        [self.contentView addSubview:_EPSMonthCellMonthTitle];
        
 
        _EPSMonthCellMonthCost.textColor = K_COLOR_ORANGE_TEXT;
        _EPSMonthCellMonthCost.textAlignment = NSTextAlignmentRight;
        _EPSMonthCellMonthCost.font = [UIFont fontWithName:FONT_H size:14];
        [self.contentView addSubview:_EPSMonthCellMonthCost];
    

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

- (void)setEPSMonthCellTitle:(NSString *)MonthTitle
         setEPSMonthCellCost:(NSString *)MonthCost
{
    _EPSMonthCellMonthTitle.text   = MonthTitle;
    _EPSMonthCellMonthCost.text    = MonthCost;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
