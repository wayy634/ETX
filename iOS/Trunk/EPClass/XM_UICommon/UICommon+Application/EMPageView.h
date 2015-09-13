//
//  EMPageView.h
//
//  Created by Hui Wang on 3/5/12.
//  Copyright (c) 2012 Wang Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EMPageItemViewStyleNone,
    EMPageItemViewStyleImage,
    EMPageItemViewStyleTextView
}EMPageItemViewStyle;

/**
 *  EMPageView每一页显示的视图的基类，所有的视图都必须继承该类，才能显示到EMPageView控件中
 */
@protocol EMPageItemViewDelegate;
@interface EMPageItemView : UIView
{
    EMPageItemViewStyle _style;
}

/**
 *  重用ID
 */
@property (nonatomic, copy) NSString *identifier;

/**
 *  当前的页码
 */
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL highlighted;

@property (nonatomic, assign) id<EMPageItemViewDelegate> delegate;
@property (nonatomic, assign) BOOL showTopCoverWhenHighlighted;

//- (id)initWithStyle:(EMPageItemViewStyle)style reusableIdentifier:(NSString *)identifier;

/**
 *  通过重用ID初始化对象
 *
 *  @param identifier 重用ID
 *
 *  @return EMPageItemView对象
 */
- (id)initWithReusableIdentifier:(NSString *)identifier;

//- (void)addActionForClickEvent:(SEL)action toTarget:(id)target;

@end

@protocol EMPageItemViewDelegate <NSObject>
@optional
- (void)clickAtPageItemView:(EMPageItemView *)itemView;
@end

/**
 *  分页展示内容的控件，支持自动滚动显示每页的内容。主页面的滚动广告栏的效果就是用这个控件来实现的
 *  支持用PageControl或者文字的形式来显示页码信息
 */
@protocol EMPageViewDelegate;
@interface EMPageView : UIView <UIScrollViewDelegate, EMPageItemViewDelegate> {
@private    
    BOOL _manual;
    BOOL _crossed;
}

@property (nonatomic, assign) IBOutlet id<EMPageViewDelegate> delegate;

/**
 *  when total pages larger than this value, it will show label text instead.
 */
@property (nonatomic, assign) NSInteger maxPageNumbersToShowPageControl;

/**
 *  是否支持滚动
 */
@property (nonatomic, assign) BOOL scrollEnabled;

/**
 *  滚动视图的位置信息
 */
@property (nonatomic, assign) CGRect scrollViewFrame;

/**
 *  是否开启自动滚动
 */
@property (nonatomic, assign, readonly) BOOL autoScroll;
@property (nonatomic, assign, readonly) NSTimeInterval scrollDuration;

@property (nonatomic, assign) BOOL cacheEnabled;

@property (nonatomic, assign) BOOL onlyLoadVisibleCells;
@property (nonatomic, assign) BOOL circleSupported;

- (void)setAutoScroll:(BOOL)autoScroll scrollDuration:(NSTimeInterval)scrollDuration;
- (void)disableAutoScroll;

/**
 *  通过控件的大小位置信息和delegate初始化控件
 *
 *  @param frame     控件的frame
 *  @param aDelegate 回调对象
 *
 *  @return EMPageView对象
 */
- (id)initWithFrame:(CGRect)frame delegate:(id<EMPageViewDelegate>)aDelegate;

/**
 *  从缓存中获取id对应的视图
 *
 *  @param aIdentifier 标记视图的id
 *
 *  @return 单页的视图
 */
- (EMPageItemView *)dequeueReusablePageViewWithIdentifier:(NSString *)aIdentifier;

/**
 *  设置背景图
 *
 *  @param bgImage 背景图
 */
- (void)setBackgroundImage:(UIImage *)bgImage;

/**
 *  设置页码信息的字体颜色
 *
 *  @param textColor 颜色值
 */
- (void)setPageTextColor:(UIColor *)textColor;

/**
 *  设置页码信息的字体
 *
 *  @param textFont 字体
 */
- (void)setPageTextFont:(UIFont *)textFont;

/**
 *  控制文字页码信息的显示和隐藏
 *
 *  @param isShow 是否显示 YES：显示  NO：隐藏
 */
- (void)showPageInfo:(BOOL)isShow;

/**
 *  跳转到某一页，支持动画效果
 *
 *  @param page     页码
 *  @param animated 是否用动画效果
 */
- (void)jumpToPage:(NSInteger)page animated:(BOOL)animated;

/**
 *  重新加载所有页面内容
 */
- (void)reloadData;

/**
 *  清除所有重用页面的视图
 */
- (void)clearCache;

/**
 *
 *  @return 返回当前正在显示的页码数，页码数从0开始到totalPage-1
 */
- (NSInteger)currentPage;

/**
 *
 *  @return 返回总共有多少页
 */
- (NSInteger)totalPage;

- (EMPageItemView *)itemViewAtPage:(NSInteger)page;

- (NSInteger)pageAtPageIndex:(NSInteger)pageIndex;

@end

@protocol EMPageViewDelegate <NSObject>
@required

/**
 *  定义控件一共要显示多少页
 */
- (NSInteger)numbersOfPageInView:(EMPageView *)pageView;

/**
 *  定义每一页的视图信息，支持页面视图的重用
 *
 *  @param pageView EMPageView对象
 *  @param page     当前页码
 *
 *  @return 每一页的视图
 */
- (EMPageItemView *)pageView:(EMPageView *)pageView itemViewForPage:(NSInteger)page;

@optional

/**
 *  点击某一页的回调方法
 *  @param page     当前点击的页码数
 */
- (void)pageView:(EMPageView *)pageView clickAtPage:(EMPageItemView *)itemView;

/**
 *  滚动到最后一页的回调方法
 */
- (void)scrollToEndOfView:(EMPageView *)aPageView;

/**
 *  滚动到特定页面的回调方法
 *  @param page     当前滚动到的页码
 */
- (void)pageView:(EMPageView *)pageView scrollToPage:(NSInteger)page;

- (void)itemViewDidAddToCache:(EMPageItemView *)itemView;

@end
