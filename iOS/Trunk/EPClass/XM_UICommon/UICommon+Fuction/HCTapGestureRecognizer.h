//
//  HCTapGestureRecognizer.h
//  HCToolKit
//
//  Created by HXG on 1/13/15.
//  Copyright (c) 2015 Wang Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  在使用手势的target-action中处理点击事件的时候，需要判断state为end的时候再调用相应方法
 *  在使用该手势订制UI开发控件的时候，要在dealloc方法里将tagDelegate设置为nil。因为手势生效方法是一个延迟0.5s调用的类
 *  在某些特殊的情况下如果控件被释放，然而还是在做长按操作的话可能会造成crash
 */

@protocol HCTapGestureRecognizerDelegate;
@interface HCTapGestureRecognizer : UIGestureRecognizer

@property (assign, nonatomic) BOOL highlighted;
@property (assign, nonatomic) id<HCTapGestureRecognizerDelegate> tapDelegate;

@end

@protocol HCTapGestureRecognizerDelegate <NSObject>

@optional
- (void)highlightedChangedInGesture:(HCTapGestureRecognizer *)tapGesture;
- (void)touchUpInsideGesture:(HCTapGestureRecognizer *)tapGesture;

@end