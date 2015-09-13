//
//  XMFuctionTypeV.h
//  EPASS-APP-iOS
//
//  Created by Jeanne on 15/6/4.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMFuctionTypeVDelegate <NSObject>
@optional
- (void)hideFuctionTypeV;
- (void)fuctionTypeVButtonPressed:(int)index_;
@end

@interface XMFuctionTypeV : UIView
@property (assign) id<XMFuctionTypeVDelegate> mDelegate;
- (id)initWithFrame:(CGRect)frame_ rowCount:(int)rowCount_ dataArray:(NSArray *)dataArray_;
@end
