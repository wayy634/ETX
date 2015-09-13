//
//  Created by dengfang on 11-11-08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"

@class TKCalendarMonthView;
@protocol TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource;

@interface TKCalendarMonthViewController : LCBaseViewController <TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource> {
	TKCalendarMonthView *_monthView;
	BOOL _sundayFirst;
    BOOL mIsCanChooseNotInMonth;    //dengfang add
    BOOL mIsMarkToday;              //dengfang add
    BOOL mIsMarkDayWithBgImg;       //dengfang add
    NSDate *mSelectedDate;          //dengfang add
}

- (id) init;
- (id) initWithSunday:(BOOL)sundayFirst isCanChooseNotInMonth:(BOOL)isCanChooseNotInMonth isMarkToday:(BOOL)isMarkToday isMarkDayWithBgImg:(BOOL)isMarkDayWithBgImg selectedDate:(NSDate *)date;

@property (retain,nonatomic) TKCalendarMonthView *monthView;
@property (retain, nonatomic) NSDate *mSelectedDate;


@end

