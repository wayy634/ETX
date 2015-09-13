//
//  XMBottomMenuButton.m
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/5/11.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMBottomMenuButton.h"

@implementation XMBottomMenuButton

- (void)initTopIconUI {
    self.mTopIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [LTools roundedRectangleView:self.mTopIconButton corner:7.5 width:0.0 color:[UIColor clearColor]];
    [self.mTopIconButton setUserInteractionEnabled:NO];
    [self.mTopIconButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.mTopIconButton.titleLabel setFont:K_FONT_SIZE(10)];
    [self.mTopIconButton setBackgroundColor:K_COLOR_MAIN_ORANGER];
    [self.mTopIconButton setFrame:CGRectMake(self.width - 40, -3, 15, 15)];
    [self addSubview:self.mTopIconButton];
}

- (void)setTopIconImage:(UIImage *)image_ {
    if (!self.mTopIconButton) {
        self.mTopIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mTopIconButton setUserInteractionEnabled:NO];
        [self.mTopIconButton setFrame:CGRectMake(self.width - image_.size.width - 2, 0, image_.size.width, image_.size.height)];
        [self addSubview:self.mTopIconButton];
    }
}

- (void)setTopIconString:(NSString *)string_ {
    if (self.mTopIconButton) {
        [self.mTopIconButton setTitle:string_ forState:UIControlStateNormal];
    }
}

- (void)setTopIconImageState:(BOOL)hidden_ {
    if (self.mTopIconButton) {
        [self.mTopIconButton setHidden:hidden_];
    }
}

- (void)dealloc {
    self.mTopIconButton = nil;
    [super dealloc];
}

@end
