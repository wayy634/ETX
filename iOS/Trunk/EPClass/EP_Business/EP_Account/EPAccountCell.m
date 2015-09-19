//
//  EPSDayCell.m
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//


#import "EPAccountCell.h"

#define ICON_WH  40

@interface EPAccountCell ()

@end

@implementation EPAccountCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = K_COLOR_WHITE_TEXT;
        
        _EPAccountCellBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 50)];
        _EPAccountCellBg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_EPAccountCellBg];
        
        UIImageView  *grayLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50-0.5, K_SCREEN_WIDTH, 0.5)];
        grayLine.backgroundColor           = K_COLOR_GRAY_FONT;
        grayLine.alpha                     = 0.4;
        [self.contentView addSubview:grayLine];
    
        _EPAccountCellDayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        _EPAccountCellDayIcon.tag = 10001;
        [self.contentView addSubview:_EPAccountCellDayIcon];
        
        _EPAccountCellDayTitle     = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, K_SCREEN_WIDTH-100, 30)];
        
        _EPAccountCellDayTitle.textColor = K_COLOR_DARK_TEXT;
        _EPAccountCellDayTitle.textAlignment = NSTextAlignmentLeft;
        _EPAccountCellDayTitle.font = [UIFont fontWithName:FONT_H size:14];
        [self.contentView addSubview:_EPAccountCellDayTitle];
        
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

- (void)setEPAccountCellIcon:(UIImage *)cellIcon
       setEPAccountCellTitle:(NSString *)cellTitle
{
    _EPAccountCellDayTitle.text   = cellTitle;
    _EPAccountCellDayIcon.image   = cellIcon;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
