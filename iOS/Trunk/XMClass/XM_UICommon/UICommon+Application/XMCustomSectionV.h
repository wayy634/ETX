//
//  XMCustomSectionV.h
//  XiaoMai
//
//  Created by Jeanne on 15/6/2.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMCustomSectionVDelegate <NSObject>
@optional
- (void)XMCustomPressed:(int)index_;
@end

@interface XMCustomSectionV : UIView
@property (nonatomic,assign)id<XMCustomSectionVDelegate> mDelegate;
- (void)setData:(NSArray *)dataArray_;
@end
