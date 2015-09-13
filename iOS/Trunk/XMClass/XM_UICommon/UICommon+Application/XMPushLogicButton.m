//
//  XMPushLogicButton.m
//  XiaoMai
//
//  Created by Jeanne on 15/5/12.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMPushLogicButton.h"
#import "UIImageView+WebCache.h"

@interface XMPushLogicButton ()
@property (nonatomic ,strong)UIImageView *mImageV;
@end

@implementation XMPushLogicButton

- (void)initNormalImage:(NSString *)imageUrl_ placeholderImage:(NSString *)placeholderImage_ {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [imageV setUserInteractionEnabled:NO];
    self.mImageV = imageV;
    [self addSubview:imageV];
    [imageV release];
    [self.mImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl_] placeholderImage:(placeholderImage_ && placeholderImage_.length != 0) ? [UIImage imageNamed:placeholderImage_] : [UIImage imageNamed:@"Icon_Default_159x85.png"]];
}

- (void)refreshNormalImage:(NSString *)imageUrl_ placeholderImage:(NSString *)placeholderImage_ {
    [self.mImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl_] placeholderImage:(placeholderImage_ && placeholderImage_.length != 0) ? [UIImage imageNamed:placeholderImage_] : [UIImage imageNamed:@"Icon_Default_159x85.png"]];
}

- (void)dealloc {
    self.mImageV = nil;
    [super dealloc];
}
@end
