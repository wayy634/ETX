//
//  XMFuctionTypeV.m
//  XiaoMai
//
//  Created by Jeanne on 15/6/4.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMFuctionTypeV.h"

#define XMFUCTIONTYPEV_CELL_HEIGHT 55
#define XMFUCTIONTYPEV_BUTTON_HEIGHT 30
#define XMFUCTIONTYPEV_BUTTON_WIDTH 107
#define XMFUCTIONTYPEV_OFFSET_Y     12

@implementation XMFuctionTypeV

- (id)initWithFrame:(CGRect)frame_ rowCount:(int)rowCount_ dataArray:(NSArray *)dataArray_ {
    if (self == [super initWithFrame:frame_]) {
        
        UIView *coverV = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)] autorelease];
        [coverV setBackgroundColor:[UIColor blackColor]];
        [coverV setAlpha:0.5];
        [self addSubview:coverV];
        
        UIView *contentV = [[[UIView alloc] init] autorelease];
        [contentV setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:contentV];
        
        float offsetX = (self.width - XMFUCTIONTYPEV_BUTTON_WIDTH*rowCount_)/(rowCount_+1);
        int row = 0;
        float height = .0;
        for (int i = 0; i < dataArray_.count; i++) {
            if (i != 0 && i%rowCount_ == 0) {
                row++;
            }
            UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [tempButton setTag:i];
            [tempButton setFrame:CGRectMake(offsetX*(i+1) + XMFUCTIONTYPEV_BUTTON_WIDTH*i, XMFUCTIONTYPEV_OFFSET_Y*(row+1) + row*XMFUCTIONTYPEV_BUTTON_HEIGHT, XMFUCTIONTYPEV_BUTTON_WIDTH, XMFUCTIONTYPEV_BUTTON_HEIGHT)];
            [tempButton setAdjustsImageWhenHighlighted:NO];
            [tempButton setTitle:[[dataArray_ objectAtIndex:i] objectAtIndex:0] forState:UIControlStateNormal];
            [tempButton.titleLabel setFont:K_FONT_SIZE(14)];
            [tempButton setTitleColor:[[dataArray_ objectAtIndex:i] objectAtIndex:1] forState:UIControlStateNormal];
            [tempButton setBackgroundColor:[[dataArray_ objectAtIndex:i] objectAtIndex:2]];
            [tempButton setImage:[UIImage imageNamed:[[dataArray_ objectAtIndex:i] objectAtIndex:3]] forState:UIControlStateNormal];
            [LTools roundedRectangleView:tempButton corner:16.0 width:0.5 color:[[dataArray_ objectAtIndex:i] objectAtIndex:2]];
            [tempButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:tempButton];
            height = tempButton.bottom + XMFUCTIONTYPEV_OFFSET_Y;
        }
        [contentV setFrame:CGRectMake(0, 0, self.width, height)];
    }
    return self;
}

- (void)buttonPressed:(UIButton *)sender_ {
    if ([self.mDelegate respondsToSelector:@selector(fuctionTypeVButtonPressed:)]) {
        [self.mDelegate fuctionTypeVButtonPressed:(int)sender_.tag];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.mDelegate respondsToSelector:@selector(hideFuctionTypeV)]) {
        [self.mDelegate hideFuctionTypeV];
    }
}

@end
