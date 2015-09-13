//
//  Created by dengfang on 11-11-08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKCalendarMonthTiles;
@protocol TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource;


@interface TKCalendarMonthView : UIView {

	TKCalendarMonthTiles *currentTile,*oldTile;
	UIButton *leftArrow, *rightArrow;
	UIImageView *topBackground, *shadow;
	UILabel *monthYear;
	UIScrollView *tileBox;
	BOOL sunday;
    BOOL mIsCanChooseNotInMonth;    //dengfang add 当前月内的非当前月日期（灰色日期）是否可选
    BOOL mIsMarkToday;              //dengfang add "今天"是否标记显示
    BOOL mIsMarkDayWithBgImg;       //dengfang add 使用背景图片标注
	id <TKCalendarMonthViewDelegate> delegate;
	id <TKCalendarMonthViewDataSource> dataSource;
}

@property (nonatomic,assign) id <TKCalendarMonthViewDelegate> delegate;
@property (nonatomic,assign) id <TKCalendarMonthViewDataSource> dataSource;

- (id)initWithSundayAsFirst:(BOOL)sunday isCanChooseNotInMonth:(BOOL)isCanChooseNotInMonth 
                isMarkToday:(BOOL)isMarkToday isMarkDayWithBgImg:(BOOL)isMarkDayWithBgImg
               selectedDate:(NSDate *)date; // or Monday

- (NSDate *)dateSelected;
- (NSDate *)monthDate;
- (void)selectDate:(NSDate *)date;
- (void)reload;

@end


@protocol TKCalendarMonthViewDelegate <NSObject>

@optional
- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)date;
- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)date selectedDate:(NSDate *)sDate;

@end

@protocol TKCalendarMonthViewDataSource <NSObject>
- (NSArray *)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate;
@end