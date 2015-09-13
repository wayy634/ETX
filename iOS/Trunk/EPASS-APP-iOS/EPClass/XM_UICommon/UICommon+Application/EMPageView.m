//
//  EMPageView.m
//  
//
//  Created by Hui Wang on 3/5/12.
//  Copyright (c) 2012 Wang Hui. All rights reserved.
//

#import "EMPageView.h"

@interface EMPageItemView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *highlightView;

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture;

@end

@implementation EMPageItemView

- (id)initWithStyle:(EMPageItemViewStyle)style reusableIdentifier:(NSString *)identifier {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setItemWithStyle:style reusableIdentifier:identifier];
    }
    return self;
}

- (id)initWithReusableIdentifier:(NSString *)identifier {
    return [self initWithStyle:EMPageItemViewStyleNone reusableIdentifier:identifier];
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithReusableIdentifier:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setItemWithStyle:EMPageItemViewStyleNone reusableIdentifier:nil];
    }
    return self;
}

- (void)dealloc {
    self.identifier = nil;
    self.highlightView = nil;
    [super dealloc];
}

- (void)setItemWithStyle:(EMPageItemViewStyle)style reusableIdentifier:(NSString *)identifier
{
    _style = style;
    self.identifier = identifier;
    self.highlighted = NO;
    self.showTopCoverWhenHighlighted = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if ([_delegate respondsToSelector:@selector(clickAtPageItemView:)]) {
        [_delegate clickAtPageItemView:self];
    }
}

- (void)changeHightlightStatus:(BOOL)isHighlighted_ {
    self.highlighted = isHighlighted_;
    if (self.showTopCoverWhenHighlighted) {
        if (self.highlighted) {
            self.highlightView.frame = self.bounds;
            [self addSubview:self.highlightView];
        } else {
            [self.highlightView removeFromSuperview];
        }
    }
}

- (UIView *)highlightView
{
    if (!_highlightView) {
        self.highlightView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    }
    return _highlightView;
}

- (void)addActionForClickEvent:(SEL)action toTarget:(id)target {
    for (UIGestureRecognizer *gesture in [self gestureRecognizers]) {
        [self removeGestureRecognizer:gesture];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGesture];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [tapGesture release];
}

#pragma mark - event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self changeHightlightStatus:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self changeHightlightStatus:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self changeHightlightStatus:NO];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    
    return YES;
}

@end

@interface EMPageView ()
@property (nonatomic, retain) UIScrollView        *pageScrollView;
@property (nonatomic, retain) UIView              *pageInfoView;
@property (nonatomic, retain) UIPageControl       *pageControl;
@property (nonatomic, retain) UILabel             *pageLabel;
@property (nonatomic, retain) UIImageView         *bgImageView;
@property (nonatomic, retain) NSMutableDictionary *reusablePageViewDict;
@property (nonatomic, retain) NSTimer             *autoScrollTimer;
@property (nonatomic, assign) BOOL                 autoScroll;
@property (nonatomic, assign) NSTimeInterval       scrollDuration;
@property (nonatomic, assign) int                  currentPageIndex;


- (void)addPageViewToReusableCache:(EMPageItemView *)itemView;
- (void)initUI;
- (void)pageChanged;
- (void)dataInit;
- (void)pageControlClicked:(id)sender;
- (void)changeToPage:(NSInteger)page animated:(BOOL)animated;


- (void)scheduleAutoScrollTimer;
- (void)invalidateAutoScrollTimer;
- (void)handleAutoScrollTimer:(NSTimer *)aTimer;

@end

@implementation EMPageView
@synthesize pageScrollView                  = _pageScrollView;
@synthesize pageInfoView                    = _pageInfoView;
@synthesize pageControl                     = _pageControl;
@synthesize pageLabel                       = _pageLabel;
@synthesize bgImageView                     = _bgImageView;
@synthesize reusablePageViewDict            = _reusablePageViewDict;
@synthesize delegate                        = _delegate;
@synthesize maxPageNumbersToShowPageControl = _maxPageNumbersToShowPageControl;

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame delegate:nil];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<EMPageViewDelegate>)aDelegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate   = aDelegate;
        [self initUI];
        self.autoScroll = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)dealloc {
    _pageScrollView.delegate = nil;
    if (_autoScrollTimer) {
        [_autoScrollTimer invalidate];
    }
    self.autoScrollTimer = nil;
    self.pageInfoView = nil;
    self.pageControl  = nil;
    self.pageLabel    = nil;
    self.bgImageView  = nil;
    self.pageScrollView = nil;
    self.reusablePageViewDict = nil;
    [super dealloc];
}

#pragma mark - private
- (void)addPageViewToReusableCache:(EMPageItemView *)itemView {
    if (!_cacheEnabled) {
        return;
    }
    if (itemView.identifier && itemView.identifier.length > 0) {
        if (!_reusablePageViewDict) {
            _reusablePageViewDict = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
        
        NSMutableArray *reusableArray = [_reusablePageViewDict objectForKey:itemView.identifier];
        if (!reusableArray) {
            reusableArray = [NSMutableArray arrayWithObject:itemView];
            [_reusablePageViewDict setObject:reusableArray forKey:itemView.identifier];
        } else {
            [reusableArray addObject:itemView];
        }
    }
}

- (void)initUI {
    self.cacheEnabled = YES;
    self.onlyLoadVisibleCells = YES;
    self.scrollDuration = 5.f;
    self.backgroundColor = [UIColor clearColor];
    
    self.bgImageView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
    _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:_bgImageView];
    
    self.pageScrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
    _pageScrollView.backgroundColor = [UIColor clearColor];
    _pageScrollView.pagingEnabled   = YES;
    _pageScrollView.showsHorizontalScrollIndicator = NO;
    _pageScrollView.delegate        = self;
    _pageScrollView.clipsToBounds   = NO;
    [self addSubview:_pageScrollView];
    
    CGFloat viewWidth    = self.bounds.size.width;
    CGFloat viewHeight   = self.bounds.size.height;
    CGFloat leftMargin   = 5.0f;
    CGFloat bottomMargin = 0.0f;
    CGRect labelFrame    = CGRectMake(leftMargin, (viewHeight-20-bottomMargin), viewWidth - 2*leftMargin, 20);
    
    self.pageInfoView    = [[[UIView alloc] initWithFrame:labelFrame] autorelease];
    _pageInfoView.backgroundColor = [UIColor clearColor];
    [self addSubview:_pageInfoView];
    
    self.pageControl = [[[UIPageControl alloc] initWithFrame:_pageInfoView.bounds] autorelease];
    self.pageControl.currentPageIndicatorTintColor = [[XMThemeManager sharedThemeManager] getAppThemeColor];
    self.pageControl.pageIndicatorTintColor = [LTools colorWithHexString:@"d6d6d6"];
    [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    
    self.pageLabel = [[[UILabel alloc] initWithFrame:_pageInfoView.bounds] autorelease];
    _pageLabel.backgroundColor  = [UIColor clearColor];
    _pageLabel.font             = K_FONT_SIZE(20);
//    _pageLabel.minimumFontSize  = 10.0f;
    if ([_pageLabel respondsToSelector:@selector(setMinimumScaleFactor:)]) {
        _pageLabel.minimumScaleFactor = 0.5f;
    } else {
        _pageLabel.minimumFontSize = 8.f;
    }
    
    
    
    _pageLabel.textColor        = [UIColor blackColor];
    _pageLabel.textAlignment    = NSTextAlignmentCenter;
    _pageLabel.adjustsFontSizeToFitWidth = YES;
    
    [_pageInfoView addSubview:_pageControl];
    [_pageInfoView addSubview:_pageLabel];
    
    _maxPageNumbersToShowPageControl = 30;
    
    [self dataInit];
}

- (void)pageChanged {
    self.pageControl.currentPage = [self realPageAtIndex:_currentPageIndex];
    NSInteger currentPage = _pageControl.currentPage;
    NSInteger totalPage   = [self totalPage];
    _pageLabel.text       = [NSString stringWithFormat:@"%ld/%ld", (long)(currentPage + 1), (long)totalPage];
    
    NSMutableArray *loadPages = [[NSMutableArray alloc] initWithCapacity:3];
    
    currentPage = _currentPageIndex;
    totalPage = [self realTotalPage];
    [loadPages addObject:@(currentPage - 1)];
    [loadPages addObject:@(currentPage)];
    [loadPages addObject:@(currentPage + 1)];
    
    if (self.onlyLoadVisibleCells) {
        for (UIView *subView in _pageScrollView.subviews) {
            if ([subView isKindOfClass:[EMPageItemView class]]) {
                EMPageItemView *itemView = (EMPageItemView *)subView;
                NSNumber *tmpNumber = @(itemView.page);
                if (![loadPages containsObject:tmpNumber]) {
                    [self addPageViewToReusableCache:itemView];
                    [itemView removeFromSuperview];
                    
                    if ([_delegate respondsToSelector:@selector(itemViewDidAddToCache:)]) {
                        [_delegate itemViewDidAddToCache:itemView];
                    }
                    
                } else {
                    [loadPages removeObject:tmpNumber];
                }
            }
        }
        
        if ([loadPages count] > 0) {
            int page = 0;
            for (NSNumber *pageNum in loadPages) {
                page = [pageNum intValue];
                if (page >= 0 && page < totalPage) {
                    EMPageItemView *itemView = [_delegate pageView:self itemViewForPage:[self realPageAtIndex:page]];
                    itemView.frame      = [self frameItemAtIndex:page];
                    itemView.page       = page;
                    itemView.delegate   = self;
                    itemView.userInteractionEnabled = YES;
                    [_pageScrollView addSubview:itemView];
                }
            }
        }
    } else {
        for (NSNumber *tmpPage in loadPages) {
            int page = [tmpPage intValue];
            BOOL pageExist = NO;
            for (UIView *subView in _pageScrollView.subviews) {
                if ([subView isKindOfClass:[EMPageItemView class]]) {
                    EMPageItemView *itemView = (EMPageItemView *)subView;
                    if (itemView.page == page) {
                        pageExist = YES;
                        break;
                    }
                }
            }
            
            if (!pageExist && page >= 0 && page < totalPage) {
                EMPageItemView *itemView = [_delegate pageView:self itemViewForPage:[self realPageAtIndex:page]];
                itemView.frame      = [self frameItemAtIndex:page];
                itemView.page       = page;
                itemView.delegate   = self;
                itemView.userInteractionEnabled = YES;
                [_pageScrollView addSubview:itemView];
            }
        }
    }
    
    if ([_delegate respondsToSelector:@selector(pageView:scrollToPage:)]) {
        [_delegate pageView:self scrollToPage:currentPage];
    }
    
    [loadPages release];
}

- (void)dataInit {
    _pageControl.numberOfPages  = [_delegate numbersOfPageInView:self];
    _pageScrollView.contentSize = CGSizeMake(_pageScrollView.bounds.size.width * [self realTotalPage], _pageScrollView.bounds.size.height);
    
    _pageScrollView.contentOffset = CGPointMake(self.currentPageIndex*_pageScrollView.width, 0);
    
    [self setMaxPageNumbersToShowPageControl:_maxPageNumbersToShowPageControl];
    
    [self pageChanged];
}

- (void)pageControlClicked:(id)sender {
    [self changeToPage:_pageControl.currentPage animated:YES];
}

- (CGRect)frameItemAtIndex:(NSInteger)index
{
    CGRect tmpFrame   = _pageScrollView.bounds;
    tmpFrame.origin.x = tmpFrame.size.width * index;
    return tmpFrame;
}

- (int)realPageAtIndex:(int)index
{
    int page = index;
    if (_circleSupported) {
        if (index == 0) {
            page = (int)_pageControl.numberOfPages - 1;
        } else if (index == _pageControl.numberOfPages + 1) {
            page = 0;
        } else {
            page = index - 1;
        }
    }
    return page;
}

- (int)realIndexForPage:(int)page
{
    int index = page;
    if (_circleSupported) {
        index = page + 1;
    }
    return index;
}

- (void)changeToPage:(NSInteger)page animated:(BOOL)animated {
    _manual = YES;
    self.currentPageIndex = [self realIndexForPage:(int)page];
//    NSLog(@"change to index: %d", _currentPageIndex);
    CGRect tmpFrame = [self frameItemAtIndex:_currentPageIndex];
//    NSLog(@"------------------scroll to frame : %@", NSStringFromCGRect(tmpFrame));
    [_pageScrollView scrollRectToVisible:tmpFrame animated:animated];
    [self pageChanged];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_manual) {
        return;
    }
    
    CGFloat pageWidth = _pageScrollView.frame.size.width;
    
    if (!_circleSupported && _pageScrollView.contentOffset.x > ([self realTotalPage] - 0.7) * pageWidth) {
        _crossed = YES;
    } else {
        int page = floor((_pageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if (page != _currentPageIndex) {
            self.currentPageIndex = page;
            _pageControl.currentPage = [self realPageAtIndex:page];
            [self pageChanged];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _crossed = NO;
    _manual  = NO;
    [self invalidateAutoScrollTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _manual = NO;
    if (_crossed && !_circleSupported && [_delegate respondsToSelector:@selector(scrollToEndOfView:)]) {
        [_delegate scrollToEndOfView:self];
    }
    
    [self checkEdgePageIndex];
    [self scheduleAutoScrollTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_crossed && !decelerate && _circleSupported && [_delegate respondsToSelector:@selector(scrollToEndOfView:)]) {
        [_delegate scrollToEndOfView:self];
    }
    
    if (!decelerate) {
        [self checkEdgePageIndex];
        [self scheduleAutoScrollTimer];
    }
}

- (void)checkEdgePageIndex
{
//    NSLog(@"---- check index: %d", _currentPageIndex);
    if (self.circleSupported) {
        if (self.currentPageIndex == 0) {
            [self jumpToPage:(_pageControl.numberOfPages - 1) animated:NO];
        } else if (self.currentPageIndex == ([self realTotalPage] - 1)) {
            [self jumpToPage:0 animated:NO];
        }
    }
}

#pragma mark - EMPageItemViewDelegate
- (void)clickAtPageItemView:(EMPageItemView *)itemView {
    if (itemView && [_delegate respondsToSelector:@selector(pageView:clickAtPage:)]) {
        [_delegate pageView:self clickAtPage:itemView];
    }
}

#pragma mark - public
- (EMPageItemView *)dequeueReusablePageViewWithIdentifier:(NSString *)aIdentifier {
    if (!_cacheEnabled) {
        return nil;
    }
    if (aIdentifier && aIdentifier.length > 0) {
        NSMutableArray *reusableViews = [_reusablePageViewDict objectForKey:aIdentifier];
        if ([reusableViews count] > 0) {
            EMPageItemView *itemView = [reusableViews lastObject];
            [itemView retain];
            [reusableViews removeLastObject];
            return [itemView autorelease];
        }
    }
    return nil;
}

- (void)setDelegate:(id<EMPageViewDelegate>)delegate {
    _delegate = delegate;
    [self dataInit];
}

- (void)setBackgroundImage:(UIImage *)bgImage {
    _bgImageView.image = bgImage;
}

- (void)setPageTextColor:(UIColor *)textColor {
    _pageLabel.textColor = textColor;
}

- (void)setPageTextFont:(UIFont *)textFont {
    _pageLabel.font = textFont;
}

- (void)showPageInfo:(BOOL)isShow {
    _pageInfoView.hidden = !isShow;
}

- (void)setMaxPageNumbersToShowPageControl:(NSInteger)maxPageNumbersToShowPageControl {
    if (_maxPageNumbersToShowPageControl != maxPageNumbersToShowPageControl) {
        _maxPageNumbersToShowPageControl = maxPageNumbersToShowPageControl;
    }
    
    if (_pageControl.numberOfPages > _maxPageNumbersToShowPageControl) {
        _pageControl.hidden = YES;
        _pageLabel.hidden   = NO;
    } else {
//        _pageControl.hidden = NO;
        _pageLabel.hidden   = YES;
        if (_pageControl.numberOfPages < 2) {
            _pageControl.hidden = YES;
        } else {
            _pageControl.hidden = NO;
        }
    }
}

- (void)jumpToPage:(NSInteger)page animated:(BOOL)animated {
//    NSLog(@"========== jump to page: %d", page);
    if (page < 0 || page >= _pageControl.numberOfPages) {
        return;
    }

    [self changeToPage:page animated:animated];
}

- (void)reloadData {
    for (UIView *tmpView in _pageScrollView.subviews) {
        if ([tmpView isKindOfClass:[EMPageItemView class]]) {
            [tmpView removeFromSuperview];
        }
    }
    
    [self dataInit];
}

- (void)clearCache {
    self.reusablePageViewDict = nil;
}

- (NSInteger)currentPage {
    return _pageControl.currentPage;
}

- (NSInteger)totalPage {
    return _pageControl.numberOfPages;
}

- (int)realTotalPage
{
    int totalPage = (int)_pageControl.numberOfPages;
    if (self.circleSupported) {
        totalPage += 2;
    }
    return totalPage;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _pageScrollView.scrollEnabled = scrollEnabled;
}

- (BOOL)scrollEnabled
{
    return _pageScrollView.scrollEnabled;
}

- (void)setScrollViewFrame:(CGRect)scrollViewFrame
{
    _pageScrollView.frame = scrollViewFrame;
}

- (CGRect)scrollViewFrame
{
    return _pageScrollView.frame;
}

- (EMPageItemView *)itemViewAtPage:(NSInteger)page
{
    NSArray *itemViews = _pageScrollView.subviews;
    
    for (UIView *aView in itemViews) {
        if ([aView isKindOfClass:[EMPageItemView class]]) {
            EMPageItemView *itemView = (EMPageItemView *)aView;
            if (itemView.page == page) {
                return itemView;
            }
        }
    }
    
    return nil;
}

- (NSInteger)pageAtPageIndex:(NSInteger)pageIndex
{
    NSInteger page = pageIndex;
    if (self.circleSupported) {
        if (pageIndex == 0) {
            page = [self totalPage] - 1;
        } else if (pageIndex == ([self realTotalPage] -1)) {
            page = 0;
        } else {
            page = pageIndex - 1;
        }
    }
    return page;
}

#pragma mark - auto scroll timer
- (void)scheduleAutoScrollTimer
{
    if (_autoScroll && !_autoScrollTimer) {
        self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_scrollDuration
                                                                target:self
                                                              selector:@selector(handleAutoScrollTimer:)
                                                              userInfo:nil
                                                               repeats:YES];
    }
}

- (void)invalidateAutoScrollTimer
{
    if (_autoScrollTimer) {
        [_autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

- (void)handleAutoScrollTimer:(NSTimer *)aTimer
{
    NSInteger tmpTotalPage = [self totalPage];
    
    if (tmpTotalPage > 1) {
        NSInteger tmpCurrentPage = [self currentPage] + 1;
        
        if (tmpCurrentPage >= tmpTotalPage) {
            tmpCurrentPage = 0;
        }
        
        [self jumpToPage:tmpCurrentPage animated:YES];
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    if (_autoScroll != autoScroll) {
        _autoScroll = autoScroll;
        [self invalidateAutoScrollTimer];
        if (_autoScroll) {
            [self scheduleAutoScrollTimer];
        }
    }
}

- (void)setAutoScroll:(BOOL)autoScroll scrollDuration:(NSTimeInterval)scrollDuration
{
    if (scrollDuration <= 0) {
        scrollDuration = 3.f;
    }
    self.scrollDuration = scrollDuration;
    [self setAutoScroll:autoScroll];
}

- (void)disableAutoScroll
{
    [self setAutoScroll:NO];
}

- (void)setOnlyLoadVisibleCells:(BOOL)onlyLoadVisibleCells
{
    if (_onlyLoadVisibleCells != onlyLoadVisibleCells) {
        _onlyLoadVisibleCells = onlyLoadVisibleCells;
        [self reloadData];
    }
}

- (void)setCircleSupported:(BOOL)circleSupported
{
    if (_circleSupported != circleSupported) {
        _circleSupported = circleSupported;
        if (_circleSupported) {
            self.currentPageIndex = 1;
        } else {
            self.currentPageIndex = 0;
        }
        [self reloadData];
    }
}

@end
