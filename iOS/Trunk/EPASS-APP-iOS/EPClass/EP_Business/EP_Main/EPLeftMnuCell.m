//
//  EPLeftMnuCell.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/16.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPLeftMnuCell.h"

@interface EPLeftMnuCell ()

@property(nonatomic, strong)UIImageView      *mIconView;
@property(nonatomic, strong)UILabel          *mTitleLabel;

@end

@implementation EPLeftMnuCell

- (void)initUI {
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.mIconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 30, 30)];
    [self.contentView addSubview:self.mIconView];
    
    self.mTitleLabel = [LCUITools creatNewLabel:CGRectMake(42, 0, 100, self.height) text:@"" color:[UIColor whiteColor] font:K_FONT_SIZE(14) textAlinment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.mTitleLabel];
    
    UIView *line = [LCUITools creatLineView:CGRectMake(0, self.height - 1, self.width, 1) bgColor:[UIColor whiteColor]];
    line.alpha = 0.5;
    [self.contentView addSubview:line];
}

- (void)setIcon:(NSString *)icon title:(NSString *)str {
    
    UIImage *iconImage = [UIImage imageWithPDFNamed:icon atSize:CGSizeMake(30, 30)];
    self.mIconView.image = iconImage;
    self.mIconView.top = (self.height -iconImage.size.height)/2;
    self.mTitleLabel.text = str;
}

@end
