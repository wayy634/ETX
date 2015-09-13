//
//  XMCustomSectionV.m
//  XiaoMai
//
//  Created by Jeanne on 15/6/2.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMCustomSectionV.h"

#define OFFSET_HEIGHT 11
#define LEFT_AREA_WIDTH 42
#define SINGLE_CELL_HEIGHT 44

@interface XMCustomSectionV ()
@property (nonatomic, strong)NSArray         *mDataArray;
@end

@implementation XMCustomSectionV

- (void)setData:(NSArray *)dataArray_ {
    self.mDataArray = dataArray_;
    int count = 0;
    for (int i = 0; i < dataArray_.count; i++) {
        count += ((NSArray *)[dataArray_ objectAtIndex:i]).count;
    }
    [self setFrame:CGRectMake(0, 0, K_SCREEN_WIDTH,(OFFSET_HEIGHT*dataArray_.count) + (count*44))];
    [self setBackgroundColor:[UIColor clearColor]];
    
    int index = 0;
    for (int i = 0; i < dataArray_.count; i++) {
        float mathOffSetY = OFFSET_HEIGHT;
        for (int k = 0; k < i; k++) {
            mathOffSetY += OFFSET_HEIGHT + ([[dataArray_ objectAtIndex:k] count]*SINGLE_CELL_HEIGHT);
        }
        UIView *contentV = [[[UIView alloc] initWithFrame:CGRectMake(0, mathOffSetY, self.width,([[dataArray_ objectAtIndex:i] count]*SINGLE_CELL_HEIGHT))] autorelease];
        [contentV setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:contentV];
        for (int j = 0; j < [[dataArray_ objectAtIndex:i] count]; j++) {
            UIImage *image = [UIImage imageNamed:[[[dataArray_ objectAtIndex:i] objectAtIndex:j] objectAtIndex:0]];
            UIImageView *itemIconImageV = [[[UIImageView alloc] initWithImage:image] autorelease];
            [itemIconImageV setFrame:CGRectMake((LEFT_AREA_WIDTH - image.size.width)/2,(SINGLE_CELL_HEIGHT*j) +(SINGLE_CELL_HEIGHT - image.size.height)/2, image.size.width, image.size.height)];
            [contentV addSubview:itemIconImageV];
            image = nil;
            
            UILabel *title = [[[UILabel alloc] initWithFrame:CGRectMake(LEFT_AREA_WIDTH, (SINGLE_CELL_HEIGHT*j), 180, SINGLE_CELL_HEIGHT)] autorelease];
            [title setBackgroundColor:[UIColor clearColor]];
            [title setTextColor:[UIColor blackColor]];
            [title setTextAlignment:NSTextAlignmentLeft];
            [title setFont:K_FONT_SIZE(14)];
            [title setText:[[[dataArray_ objectAtIndex:i] objectAtIndex:j] objectAtIndex:1]];
            [contentV addSubview:title];
            
            UILabel *promptTitle = [[[UILabel alloc] initWithFrame:CGRectMake(title.right, (SINGLE_CELL_HEIGHT*j), 150, SINGLE_CELL_HEIGHT)] autorelease];
            [promptTitle setBackgroundColor:[UIColor clearColor]];
            [promptTitle setTextColor:[UIColor grayColor]];
            [promptTitle setTextAlignment:NSTextAlignmentLeft];
            [promptTitle setFont:K_FONT_SIZE(12)];
            [promptTitle setText:[[[dataArray_ objectAtIndex:i] objectAtIndex:j] objectAtIndex:2]];
            [contentV addSubview:promptTitle];
            [title release] , title = nil;
            [promptTitle release] , promptTitle = nil;
            
            if ([[[dataArray_ objectAtIndex:i] objectAtIndex:j] lastObject]) {
                UIImage *tailImage = [UIImage imageNamed:[[[dataArray_ objectAtIndex:i] objectAtIndex:j] lastObject]];
                UIImageView *tailImageV = [[[UIImageView alloc] initWithImage:tailImage] autorelease];
                [tailImageV setFrame:CGRectMake(self.width - tailImage.size.width - 18, (SINGLE_CELL_HEIGHT-tailImage.size.height)/2 + (SINGLE_CELL_HEIGHT*j), tailImage.size.width, tailImage.size.height)];
                [contentV addSubview:tailImageV];
                tailImage = nil;
            }
            if (j != 0) {
                [contentV addSubview:[LCUITools creatLineView:CGRectMake(LEFT_AREA_WIDTH, (SINGLE_CELL_HEIGHT*j) - 0.5,contentV.width, 0.5) bgColor:[LTools colorWithHexString:@"b8b8b8"]]];
            }
            
            UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
            cover.tag = index;
            [cover setFrame:CGRectMake(0, (SINGLE_CELL_HEIGHT*j), self.width, SINGLE_CELL_HEIGHT)];
            [cover setBackgroundColor:[UIColor clearColor]];
            [cover addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [contentV addSubview:cover];
            index++;
        }
    }
}

- (void)buttonPressed:(UIButton *)sender_ {
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(XMCustomPressed:)]) {
        [self.mDelegate XMCustomPressed:(int)sender_.tag];
    }
}

- (void)dealloc {
    self.mDataArray = nil;
    [super dealloc];
}

@end
