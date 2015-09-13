//
//  Created by dengfang on 11-11-08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TKCalendarMonthViewController.h"
#import "TKCalendarMonthView.h"


@implementation TKCalendarMonthViewController
@synthesize monthView = _monthView;
@synthesize mSelectedDate;

- (id) init {
    NSDate *today = [[[NSDate alloc] init] autorelease];
	return [self initWithSunday:YES isCanChooseNotInMonth:YES isMarkToday:NO isMarkDayWithBgImg:YES selectedDate:today];
    
}

- (id) initWithSunday:(BOOL)sundayFirst isCanChooseNotInMonth:(BOOL)isCanChooseNotInMonth isMarkToday:(BOOL)isMarkToday isMarkDayWithBgImg:(BOOL)isMarkDayWithBgImg selectedDate:(NSDate *)date {
	if(!(self = [super init])) return nil;
	_sundayFirst = sundayFirst;
    mIsCanChooseNotInMonth = isCanChooseNotInMonth;
    mIsMarkToday = isMarkToday;
    mIsMarkDayWithBgImg = isMarkDayWithBgImg;
    mSelectedDate = date;
	return self;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
	self.monthView.delegate = nil;
	self.monthView.dataSource = nil;
	self.monthView = nil;
    self.mSelectedDate = nil;
}
- (void) dealloc {
	self.monthView.delegate = nil;
	self.monthView.dataSource = nil;
	self.monthView = nil;
    self.mSelectedDate = nil;
    [super dealloc];
}


- (void) loadView{
	[super loadView];
	
    _monthView = [[TKCalendarMonthView alloc] initWithSundayAsFirst:_sundayFirst
                                              isCanChooseNotInMonth:mIsCanChooseNotInMonth
                                                        isMarkToday:mIsMarkToday
                                                 isMarkDayWithBgImg:mIsMarkDayWithBgImg
                                                       selectedDate:mSelectedDate];
	_monthView.delegate = self;
	_monthView.dataSource = self;
	[self.view addSubview:_monthView];
	[_monthView reload];
	
}


- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	return nil;
	
}


@end
