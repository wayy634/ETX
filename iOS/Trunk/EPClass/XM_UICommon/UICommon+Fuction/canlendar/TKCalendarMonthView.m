//
//  Created by dengfang on 11-11-08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TKCalendarMonthView.h"
#import "TKGlobal.h"
#import "NSDate+TKCategory.h"
#import "UIImage+TKCategory.h"

//#define kCalendImagesPath @"TapkuLibrary.bundle/Images/calendar/"

@interface NSString (CalendarCategory)
- (NSDate *)stringToNSDateWithFormat:(NSString *)format;
@end

@implementation NSString (CalendarCategory)
- (NSDate *)stringToNSDateWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:format];
    
	NSString *tmpString = [[NSString alloc] initWithString:self];
    NSDate *date = [formatter dateFromString:tmpString];
	[tmpString release];
    [formatter release];
    return date;
}
@end

@interface NSDate (calendarcategory)

- (NSDate*) firstOfMonth;
- (NSDate*) nextMonth;
- (NSDate*) previousMonth;
- (NSString *)dateToNSStringWithFormat:(NSString *)format;  //dengfang 

@end

@implementation NSDate (calendarcategory)

- (NSDate*) firstOfMonth{
	TKDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info.day = 1;
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	return [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
}
- (NSDate *) nextMonth {
    TKDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info.month++;
	if(info.month>12){
		info.month = 1;
		info.year++;
	}
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	
	return [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
}
- (NSDate *) previousMonth {
    TKDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info.month--;
	if(info.month<1){
		info.month = 12;
		info.year--;
	}
	
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	return [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
}

- (NSString *)dateToNSStringWithFormat:(NSString *)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[formatter setDateFormat:format];
	NSString *s = [formatter stringFromDate:self];
	[formatter release];
	return s;
}
@end




@interface TKCalendarMonthTiles : UIView {
	
	id target;
	SEL action;
	
	NSInteger firstOfPrev,lastOfPrev;
	NSArray *marks;
	NSInteger today;
	BOOL markWasOnToday;
	
	NSInteger selectedDay,selectedPortion;
	
	NSInteger firstWeekday, daysInMonth;
	UILabel *dot;
	UILabel *currentDay;
	UIImageView *selectedImageView;
	BOOL startOnSunday;
    BOOL mIsCanChooseNotInMonth;    //dengfang
    BOOL mIsMarkToday;              //dengfang
    BOOL mIsMarkDayWithBgImg;       //dengfang 使用背景标注
    NSDate *mSelectedDate;           //dengfang +已经选择的日子（非当月也存储）
	NSDate *monthDate;
}
@property (nonatomic, retain) NSDate *mSelectedDate;
@property (readonly) NSDate *monthDate;

- (id)initWithMonth:(NSDate*)date 
              marks:(NSArray*)marks 
   startDayOnSunday:(BOOL)sunday 
isCanChooseNotInMonth:(BOOL)isCanChooseNotInMonth
        isMarkToday:(BOOL)isMarkToday 
 isMarkDayWithBgImg:(BOOL)isMarkDayWithBgImg
        selectedDate:(NSDate *)selectedDate;

- (void) setTarget:(id)target action:(SEL)action;

- (void) selectDay:(NSInteger)day;
- (NSDate*) dateSelected;

+ (NSArray*) rangeOfDatesInMonthGrid:(NSDate*)date startOnSunday:(BOOL)sunday;

@end

#define dotFontSize 18.0
#define dateFontSize 22.0

@interface TKCalendarMonthTiles (private)

@property (readonly) UIImageView *selectedImageView;
@property (readonly) UILabel *currentDay;
@property (readonly) UILabel *dot;
@end

@implementation TKCalendarMonthTiles
@synthesize mSelectedDate;
@synthesize monthDate;


+ (NSArray*) rangeOfDatesInMonthGrid:(NSDate*)date startOnSunday:(BOOL)sunday{
	
	NSDate *firstDate, *lastDate;
	
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info.day = 1;
	info.hour = 0;
	info.minute = 0;
	info.second = 0;
	
	NSDate *currentMonth = [NSDate dateFromDateInformation:info
                                                  timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info = [currentMonth dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	NSDate *previousMonth = [currentMonth previousMonth];
	NSDate *nextMonth = [currentMonth nextMonth];
	
	if(info.weekday > 1 && sunday){
		TKDateInformation info2 = [previousMonth dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		
		int preDayCnt = [previousMonth daysBetweenDate:currentMonth];		
		info2.day = preDayCnt - info.weekday + 2;
		firstDate = [NSDate dateFromDateInformation:info2 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		
	}else if(!sunday && info.weekday != 2){
		
		TKDateInformation info2 = [previousMonth dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		int preDayCnt = [previousMonth daysBetweenDate:currentMonth];
		if(info.weekday==1){
			info2.day = preDayCnt - 5;
		}else{
			info2.day = preDayCnt - info.weekday + 3;
		}
		firstDate = [NSDate dateFromDateInformation:info2 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		
	}else{
		firstDate = currentMonth;
	}	
	
	int daysInMonth = [currentMonth daysBetweenDate:nextMonth];		
	info.day = daysInMonth;
	NSDate *lastInMonth = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	TKDateInformation lastDateInfo = [lastInMonth dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	if(lastDateInfo.weekday < 7 && sunday){
		
		lastDateInfo.day = 7 - lastDateInfo.weekday;
		lastDateInfo.month++;
		lastDateInfo.weekday = 0;
		if(lastDateInfo.month>12){
			lastDateInfo.month = 1;
			lastDateInfo.year++;
		}
		lastDate = [NSDate dateFromDateInformation:lastDateInfo 
                                          timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	}else if(!sunday && lastDateInfo.weekday != 1){
		lastDateInfo.day = 8 - lastDateInfo.weekday;
		lastDateInfo.month++;
		if(lastDateInfo.month>12){ lastDateInfo.month = 1; lastDateInfo.year++; }
		
		lastDate = [NSDate dateFromDateInformation:lastDateInfo 
                                          timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

	}else{
		lastDate = lastInMonth;
	}
	
	return [NSArray arrayWithObjects:firstDate,lastDate,nil];
}

- (id)initWithMonth:(NSDate*)date marks:(NSArray*)markArray 
   startDayOnSunday:(BOOL)sunday isCanChooseNotInMonth:(BOOL)isCanChooseNotInMonth
        isMarkToday:(BOOL)isMarkToday isMarkDayWithBgImg:(BOOL)isMarkDayWithBgImg
       selectedDate:(NSDate *)selectedDate {
    
	if(![super initWithFrame:CGRectZero]) return nil;

	firstOfPrev = -1;
	marks = [markArray retain];
	monthDate = [date retain];
    mSelectedDate = [selectedDate retain];
    
	startOnSunday = sunday;
    mIsCanChooseNotInMonth = isCanChooseNotInMonth;
	mIsMarkToday = isMarkToday;
    mIsMarkDayWithBgImg = isMarkDayWithBgImg;
    
	TKDateInformation dateInfo = [monthDate dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	firstWeekday = dateInfo.weekday;
	
	NSDate *prev = [monthDate previousMonth];
	//NSDate *next = [monthDate nextMonth];
	
	daysInMonth = [[monthDate nextMonth] daysBetweenDate:monthDate];
	
	NSInteger row = (daysInMonth + dateInfo.weekday - 1);
	if(dateInfo.weekday==1&&!sunday) row = daysInMonth + 6;
	if(!sunday) row--;
	

	row = (row / 7) + ((row % 7 == 0) ? 0:1);
	float h = 44 * row;
	
	TKDateInformation todayInfo = [[NSDate date] dateInformation];
    if (mIsMarkToday) {
        today = (dateInfo.month == todayInfo.month && dateInfo.year == todayInfo.year) ? todayInfo.day : 0;
    } else {
        today = 0;
    }
    
	int preDayCnt = [prev daysBetweenDate:monthDate];		
	if(firstWeekday>1 && sunday){
		firstOfPrev = preDayCnt - firstWeekday+2;
		lastOfPrev = preDayCnt;
	}else if(!sunday && firstWeekday != 2){
		
		if(firstWeekday ==1){
			firstOfPrev = preDayCnt - 5;
		}else{
			firstOfPrev = preDayCnt - firstWeekday+3;
		}
		lastOfPrev = preDayCnt;

	}
	
    self.frame = CGRectMake(0, 1, 320, h+1);
	
	[self.selectedImageView addSubview:self.currentDay];
    if (!mIsMarkDayWithBgImg) {
        [self.selectedImageView addSubview:self.dot];
    }
	self.multipleTouchEnabled = NO;
	
	return self;
}
- (void) setTarget:(id)t action:(SEL)a{
	target = t;
	action = a;
}


- (CGRect) rectForCellAtIndex:(NSInteger)index{
	
	NSInteger row = index / 7;
	NSInteger col = index % 7;
	
	return CGRectMake(col*46, row*44+6, 47, 45);
}

- (void) drawTileInRect:(CGRect)r day:(NSInteger)day mark:(BOOL)mark font:(UIFont*)f1 font2:(UIFont*)f2 isMarkDayWithBgImg:(BOOL)isMarkDayWithBgImg {
    
    if (isMarkDayWithBgImg && mark) {
        CGRect rect = CGRectMake(r.origin.x, r.origin.y -7, r.size.width, r.size.height);
        [[UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Mark Tile.png")] drawInRect:rect];
    }
	
    NSString *str = [NSString stringWithFormat:@"%ld", (long)day];
    r.size.height -= 2;
	[str drawInRect: r
		   withFont: f1
	  lineBreakMode: NSLineBreakByWordWrapping
		  alignment: NSTextAlignmentCenter];
    
    if (!mIsMarkDayWithBgImg && mark) {
        r.size.height = 10;
		r.origin.y += 18;
		
		[@"•" drawInRect: r
				withFont: f2
		   lineBreakMode: NSLineBreakByWordWrapping
			   alignment: NSTextAlignmentCenter];
    }
}

- (void)drawTileInRect:(CGRect)r day:(NSInteger)day mark:(BOOL)mark font:(UIFont*)f1 font2:(UIFont*)f2
    isMarkDayWithBgImg:(BOOL)isMarkDayWithBgImg isNextMonth:(BOOL)isNextMonth {
    
    if (isMarkDayWithBgImg && mark) {
        CGRect rect = CGRectMake(r.origin.x, r.origin.y -7, r.size.width, r.size.height);
        [[UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Mark Tile.png")] drawInRect:rect];
    }
    
    int sYear = [[mSelectedDate dateToNSStringWithFormat:@"yyyy"] intValue];
    int sMonth = [[mSelectedDate dateToNSStringWithFormat:@"MM"] intValue];
    int sDay = [[mSelectedDate dateToNSStringWithFormat:@"dd"] intValue];
    int currentYear = [[monthDate dateToNSStringWithFormat:@"yyyy"] intValue];
    int currentMonth = [[monthDate dateToNSStringWithFormat:@"MM"] intValue];
    
//    NSLog(@"selectedDate: %d.%d.%d,  currentDate: %d.%d.%d", sYear, sMonth, sDay, currentYear, currentMonth, day);
    
    if ((sYear == currentYear && sDay == day)
        && ((!isNextMonth && sMonth == currentMonth -1) || (isNextMonth && sMonth == currentMonth +1))) {
        
        CGRect rect = CGRectMake(r.origin.x, r.origin.y -7, r.size.width, r.size.height);
        [[UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile Selected.png")] drawInRect:rect];
    }
    
    NSString *str = [NSString stringWithFormat:@"%ld", (long)day];
    r.size.height -= 2;
	[str drawInRect: r
		   withFont: f1
	  lineBreakMode: NSLineBreakByWordWrapping
		  alignment: NSTextAlignmentCenter];
    
    if (!mIsMarkDayWithBgImg && mark) {
        r.size.height = 10;
		r.origin.y += 18;
		
		[@"•" drawInRect: r
				withFont: f2
		   lineBreakMode: NSLineBreakByWordWrapping
			   alignment: NSTextAlignmentCenter];
    }
//    [self drawTileInRect:r day:day mark:mark font:f1 font2:f2 isMarkDayWithBgImg:isMarkDayWithBgImg];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIImage *tile = [UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile.png")];
	CGRect r = CGRectMake(0, 0, 46, 44);
	CGContextDrawTiledImage(context, r, tile.CGImage);
	
	if(today > 0){
		NSInteger pre = firstOfPrev > 0 ? lastOfPrev - firstOfPrev + 1 : 0;
		NSInteger index = today +  pre-1;
		CGRect r =[self rectForCellAtIndex:index];
		r.origin.y -= 7;
		[[UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Today Tile.png")] drawInRect:r];
	}
	
	int index = 0;
	
	UIFont *font = [UIFont boldSystemFontOfSize:dateFontSize];
	UIFont *font2 =[UIFont boldSystemFontOfSize:dotFontSize];
	UIColor *color = [UIColor grayColor];
	
	if(firstOfPrev>0){
		[color set];
		for(NSInteger i = firstOfPrev; i <= lastOfPrev; i++){
			r = [self rectForCellAtIndex:index];
            [self drawTileInRect:r day:i mark:NO font:font font2:font2 isMarkDayWithBgImg:NO];
            
			if ([marks count] > 0) {
                [self drawTileInRect:r day:i mark:[[marks objectAtIndex:index] boolValue]
                                font:font font2:font2 isMarkDayWithBgImg:mIsMarkDayWithBgImg isNextMonth:NO];
            } else {
                [self drawTileInRect:r day:i mark:NO font:font font2:font2 isMarkDayWithBgImg:NO isNextMonth:NO];
            }
			index++;
		}
	}
	
	color = [UIColor colorWithRed:59/255.0 green:73/255.0 blue:88/255.0 alpha:1];
	[color set];
	for(int i = 1; i <= daysInMonth; i++){
		r = [self rectForCellAtIndex:index];
		if(today == i) [[UIColor whiteColor] set];
		
		if ([marks count] > 0) {
			[self drawTileInRect:r day:i mark:[[marks objectAtIndex:index] boolValue] font:font font2:font2 isMarkDayWithBgImg:mIsMarkDayWithBgImg];
		} else {
			[self drawTileInRect:r day:i mark:NO font:font font2:font2 isMarkDayWithBgImg:NO];
        }
		if(today == i) [color set];
		index++;
	}
	
	[[UIColor grayColor] set];
	int i = 1;
	while(index % 7 != 0) {
		r = [self rectForCellAtIndex:index] ;
		if ([marks count] > 0) {
			[self drawTileInRect:r day:i mark:[[marks objectAtIndex:index] boolValue]
                            font:font font2:font2 isMarkDayWithBgImg:mIsMarkDayWithBgImg isNextMonth:YES];
		} else {
			[self drawTileInRect:r day:i mark:NO font:font font2:font2 isMarkDayWithBgImg:NO isNextMonth:YES];
        }
		i++;
		index++;
	}
}

- (void) selectDay:(NSInteger)day {
	NSInteger pre = firstOfPrev < 0 ?  0 : lastOfPrev - firstOfPrev + 1;
	NSInteger tot = day + pre;
	NSInteger row = tot / 7;
	NSInteger column = (tot % 7)-1;
	
	selectedDay = day;
	selectedPortion = 1;
    
	if(day == today){
		self.currentDay.shadowOffset = CGSizeMake(0, 1);
		self.dot.shadowOffset = CGSizeMake(0, 1);
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Today Selected Tile.png")];
		markWasOnToday = YES;
        
	}else if(markWasOnToday){
		self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile Selected.png")];
		markWasOnToday = NO;
	}
	
	[self addSubview:self.selectedImageView];
	self.currentDay.text = [NSString stringWithFormat:@"%ld",(long)day];
    
    if (mIsMarkDayWithBgImg) {
        [self.dot removeFromSuperview];
        
    } else {
        if ([marks count] > 0) {
            if([[marks objectAtIndex: row * 7 + column ] boolValue]){
                [self.selectedImageView addSubview:self.dot];
            }else{
                [self.dot removeFromSuperview];
            }
            
        }else{
            [self.dot removeFromSuperview];
        }
    }
	
	if(column < 0){
		column = 6;
		row--;
	}
	
	CGRect r = self.selectedImageView.frame;
	r.origin.x = (column*46);
	r.origin.y = (row*44)-1;
	self.selectedImageView.frame = r;
}

- (NSDate*) dateSelected{
	if(selectedDay < 1 || selectedPortion != 1) return nil;
    
	TKDateInformation info = [monthDate dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info.hour = 0;
	info.minute = 0;
	info.second = 0;
	info.day = selectedDay;
	NSDate *d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	return d;
}

- (void) reactToTouch:(UITouch*)touch down:(BOOL)down{
	
	CGPoint p = [touch locationInView:self];
	if(p.y > self.bounds.size.height || p.y < 0) return;
	
	int column = p.x / 46, row = p.y / 44;
	NSInteger day = 1, portion = 0;
	
	if(row == (int) (self.bounds.size.height / 44)) row --;
	
	NSInteger fir = firstWeekday - 1;
	if(!startOnSunday && fir == 0) fir = 7;
	if(!startOnSunday) fir--;
	
	
	if(row==0 && column < fir){
		day = firstOfPrev + column;
        
	}else{
		portion = 1;
		day = row * 7 + column  - firstWeekday+2;
		if(!startOnSunday) day++;
		if(!startOnSunday && fir==6) day -= 7;

	}
	if(portion > 0 && day > daysInMonth){
		portion = 2;
		day = day - daysInMonth;
	}
	
	
	if(portion != 1){
        if (!mIsCanChooseNotInMonth) {
            return;
        }
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile Gray.png")];
		markWasOnToday = YES;
        
	}else if(portion==1 && day == today){
		self.currentDay.shadowOffset = CGSizeMake(0, 1);
		self.dot.shadowOffset = CGSizeMake(0, 1);
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Today Selected Tile.png")];
		markWasOnToday = YES;
        
	}else if(markWasOnToday){
		self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile Selected.png")];
		markWasOnToday = NO;
	}
	
	[self addSubview:self.selectedImageView];
	self.currentDay.text = [NSString stringWithFormat:@"%ld",(long)day];
	
    if (mIsMarkDayWithBgImg) {
        [self.dot removeFromSuperview];
    } else {
        if ([marks count] > 0) {
            if([[marks objectAtIndex: row * 7 + column] boolValue])
                [self.selectedImageView addSubview:self.dot];
            else
                [self.dot removeFromSuperview];
            
        } else {
            [self.dot removeFromSuperview];
        }
    }
	
	CGRect r = self.selectedImageView.frame;
	r.origin.x = (column*46);
	r.origin.y = (row*44)-1;
	self.selectedImageView.frame = r;
	
	if(day == selectedDay && selectedPortion == portion) return;
	
	if(portion == 1){
		selectedDay = day;
		selectedPortion = portion;
		[target performSelector:action withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:day]]];
		
	}
	else if(down){
		[target performSelector:action withObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:day],[NSNumber numberWithInteger:portion],nil]];
		selectedDay = day;
		selectedPortion = portion;
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self reactToTouch:[touches anyObject] down:NO];
} 

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[self reactToTouch:[touches anyObject] down:NO];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self reactToTouch:[touches anyObject] down:YES];
}

- (UILabel *) currentDay{
	if(currentDay==nil){
		CGRect r = self.selectedImageView.bounds;
		r.origin.y -= 2;
		currentDay = [[UILabel alloc] initWithFrame:r];
		currentDay.text = @"1";
		currentDay.textColor = [UIColor whiteColor];
		currentDay.backgroundColor = [UIColor clearColor];
		currentDay.font = [UIFont boldSystemFontOfSize:dateFontSize];
		currentDay.textAlignment = NSTextAlignmentCenter;
		currentDay.shadowColor = [UIColor darkGrayColor];
		currentDay.shadowOffset = CGSizeMake(0, -1);
	}
	return currentDay;
}
- (UILabel *) dot{
	if(dot==nil){
		CGRect r = self.selectedImageView.bounds;
		r.origin.y += 29;
		r.size.height -= 31;
		dot = [[UILabel alloc] initWithFrame:r];
		
		dot.text = @"•";
		dot.textColor = [UIColor whiteColor];
		dot.backgroundColor = [UIColor clearColor];
		dot.font = [UIFont boldSystemFontOfSize:dotFontSize];
		dot.textAlignment = NSTextAlignmentCenter;
		dot.shadowColor = [UIColor darkGrayColor];
		dot.shadowOffset = CGSizeMake(0, -1);
	}
	return dot;
}
- (UIImageView *) selectedImageView{
	if(selectedImageView==nil){
		selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedTK:@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile Selected"]];
	}
	return selectedImageView;
}

- (void)dealloc {
	[currentDay release];
	[dot release];
	[selectedImageView release];
	[marks release];
	[monthDate release];
    [mSelectedDate release];
    [super dealloc];
}


@end



@interface TKCalendarMonthView (private)

@property (readonly) UIScrollView *tileBox;
@property (readonly) UIImageView *topBackground;
@property (readonly) UILabel *monthYear;
@property (readonly) UIButton *leftArrow;
@property (readonly) UIButton *rightArrow;
@property (readonly) UIImageView *shadow;

@end



@implementation TKCalendarMonthView
@synthesize delegate,dataSource;

- (id) init {
    NSDate *today = [[[NSDate alloc] init] autorelease];
	return [self initWithSundayAsFirst:YES isCanChooseNotInMonth:YES isMarkToday:NO isMarkDayWithBgImg:YES selectedDate:today];
    
}

- (id) initWithSundayAsFirst:(BOOL)s isCanChooseNotInMonth:(BOOL)isCanChooseNotInMonth isMarkToday:(BOOL)isMarkToday isMarkDayWithBgImg:(BOOL)isMarkDayWithBgImg selectedDate:(NSDate *)date {
	
	if (!(self = [super initWithFrame:CGRectZero])) return nil;
	sunday = s;
	mIsCanChooseNotInMonth = isCanChooseNotInMonth;
	mIsMarkToday = isMarkToday;
    mIsMarkDayWithBgImg = isMarkDayWithBgImg;
	currentTile = [[[TKCalendarMonthTiles alloc] initWithMonth:[[NSDate date] firstOfMonth]
                                                         marks:nil startDayOnSunday:sunday
                                         isCanChooseNotInMonth:mIsCanChooseNotInMonth
                                                   isMarkToday:mIsMarkToday
                                            isMarkDayWithBgImg:mIsMarkDayWithBgImg
                                                  selectedDate:date] autorelease];
	[currentTile setTarget:self action:@selector(tile:)];
	CGRect r = CGRectMake(0, 0, self.tileBox.bounds.size.width, self.tileBox.bounds.size.height + self.tileBox.frame.origin.y);

	
	self.frame = r;
	[currentTile retain];
    
	[self addSubview:self.topBackground];
	[self.tileBox addSubview:currentTile];
	[self addSubview:self.tileBox];
	
	self.monthYear.text = [NSString stringWithFormat:@"%@ %@",[date month], [date year]];
	[self addSubview:self.monthYear];
	
	
	[self addSubview:self.leftArrow];
	[self addSubview:self.rightArrow];
	
	[self addSubview:self.shadow];
	self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
	
	self.backgroundColor = [UIColor grayColor];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"eee"];
	[dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	
	TKDateInformation sund;
	sund.day = 5;
	sund.month = 12;
	sund.year = 2010;
	sund.hour = 0;
	sund.minute = 0;
	sund.second = 0;
	
	
	NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:0];
	NSString * sun = [dateFormat stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 6;
	NSString *mon = [dateFormat stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 7;
	NSString *tue = [dateFormat stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 8;
	NSString *wed = [dateFormat stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 9;
	NSString *thu = [dateFormat stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 10;
	NSString *fri = [dateFormat stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	sund.day = 11;
	NSString *sat = [dateFormat stringFromDate:[NSDate dateFromDateInformation:sund timeZone:tz]];
	
	[dateFormat release];


	
	NSArray *ar;
	if(sunday) ar = [NSArray arrayWithObjects:sun,mon,tue,wed,thu,fri,sat,nil];
	else ar = [NSArray arrayWithObjects:mon,tue,wed,thu,fri,sat,sun,nil];
	
	int i = 0;
	for(NSString *s in ar){
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(46 * i, 29, 46, 15)];
		[self addSubview:label];
		label.text = s;
		label.textAlignment = NSTextAlignmentCenter;
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);
        label.font = K_FONT_SIZE(10);
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor colorWithRed:59/255.0 green:73/255.0 blue:88/255.0 alpha:1];

		i++;
		[label release];
	}
	
	return self;
}
- (void) dealloc {
	[shadow release];
	[topBackground release];
	[leftArrow release];
	[monthYear release];
	[rightArrow release];
	[tileBox release];
	[currentTile release];
    [super dealloc];
}

- (void) changeMonthAnimation:(UIView*)sender{
	
	BOOL isNext = (sender.tag == 1);
	NSDate *nextMonth = isNext ? [currentTile.monthDate nextMonth] : [currentTile.monthDate previousMonth];
	
	TKDateInformation nextInfo = [nextMonth dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *localNextMonth = [NSDate dateFromDateInformation:nextInfo];
	
	
	NSArray *dates = [TKCalendarMonthTiles rangeOfDatesInMonthGrid:nextMonth startOnSunday:sunday];
	NSArray *ar = [dataSource calendarMonthView:self marksFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
	TKCalendarMonthTiles *newTile = [[TKCalendarMonthTiles alloc] initWithMonth:nextMonth
                                                                          marks:ar
                                                               startDayOnSunday:sunday
                                                          isCanChooseNotInMonth:mIsCanChooseNotInMonth
                                                                    isMarkToday:mIsMarkToday
                                                             isMarkDayWithBgImg:mIsMarkDayWithBgImg
                                                                   selectedDate:currentTile.mSelectedDate];
	[newTile setTarget:self action:@selector(tile:)];
	
	int overlap =  0;
	if(isNext){
		overlap = [newTile.monthDate isEqualToDate:[dates objectAtIndex:0]] ? 0 : 44;
	}else{
		overlap = [currentTile.monthDate compare:[dates lastObject]] !=  NSOrderedDescending ? 44 : 0;
	}
	
	float y = isNext ? currentTile.bounds.size.height - overlap : newTile.bounds.size.height * -1 + overlap;
	
	newTile.frame = CGRectMake(0, y, newTile.frame.size.width, newTile.frame.size.height);
	[self.tileBox addSubview:newTile];
	[self.tileBox bringSubviewToFront:currentTile];
	
    self.userInteractionEnabled = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(animationEnded)];
	[UIView setAnimationDuration:0.4];
	
	currentTile.alpha = 0.0;
	
	if(isNext) {
		currentTile.frame = CGRectMake(0, -1 * currentTile.bounds.size.height + overlap, currentTile.frame.size.width, currentTile.frame.size.height);
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMake(self.tileBox.frame.origin.x, self.tileBox.frame.origin.y, self.tileBox.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
		
		self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
		
		
	}else{
		
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMake(self.tileBox.frame.origin.x, self.tileBox.frame.origin.y, self.tileBox.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
		currentTile.frame = CGRectMake(0,  newTile.frame.size.height - overlap, currentTile.frame.size.width, currentTile.frame.size.height);
		
		self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
		
	}
	
	
	[UIView commitAnimations];
	
	oldTile = currentTile;
	currentTile = newTile;
    currentTile.mSelectedDate = newTile.mSelectedDate;
	
	
	
	monthYear.text = [NSString stringWithFormat:@"%@ %@",[localNextMonth month],[localNextMonth year]];
	
	

}
- (void) changeMonth:(UIButton *)sender{
	[self changeMonthAnimation:sender];
	if([delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:selectedDate:)]) {
        [delegate calendarMonthView:self monthDidChange:currentTile.monthDate selectedDate:currentTile.mSelectedDate];
    }
}
- (void) animationEnded{
	self.userInteractionEnabled = YES;
	[oldTile release];
	oldTile = nil;
}

- (NSDate*) dateSelected{
	return [currentTile dateSelected];
}
- (NSDate*) monthDate{
	return [currentTile monthDate];
}

- (void)selectDate:(NSDate *)date {
    currentTile.mSelectedDate = date;
//    NSLog(@"selectDate ========= %@", [currentTile.mSelectedDate description]);
    
	TKDateInformation info = [date dateInformation];
	NSDate *month = [date firstOfMonth];
	if([month isEqualToDate:[currentTile monthDate]]){
		[currentTile selectDay:info.day];
		return;
        
	}else {
		//NSDate *month = [self firstOfMonthFromDate:date];
		NSArray *dates = [TKCalendarMonthTiles rangeOfDatesInMonthGrid:month startOnSunday:sunday];
		NSArray *data = [dataSource calendarMonthView:self marksFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
        
        TKCalendarMonthTiles *newTile = [[TKCalendarMonthTiles alloc] initWithMonth:month
                                                                              marks:data
                                                                   startDayOnSunday:sunday
                                                              isCanChooseNotInMonth:mIsCanChooseNotInMonth
                                                                        isMarkToday:mIsMarkToday
                                                                 isMarkDayWithBgImg:mIsMarkDayWithBgImg
                                                                       selectedDate:date];
		[newTile setTarget:self action:@selector(tile:)];
        
		[currentTile removeFromSuperview];
		[currentTile release];
		currentTile = newTile;
		[self.tileBox addSubview:currentTile];
		self.tileBox.frame = CGRectMake(0, 44, newTile.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                                self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
		self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21,
                                       self.shadow.frame.size.width, self.shadow.frame.size.height);
		self.monthYear.text = [NSString stringWithFormat:@"%@ %@",[month month],[month year]];
		[currentTile selectDay:info.day];
	}
}
- (void)reload {
	NSArray *dates = [TKCalendarMonthTiles rangeOfDatesInMonthGrid:[currentTile monthDate] startOnSunday:sunday];
	NSArray *ar = [dataSource calendarMonthView:self marksFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
	
	TKCalendarMonthTiles *refresh = [[[TKCalendarMonthTiles alloc] initWithMonth:[currentTile monthDate]
                                                                           marks:ar
                                                                startDayOnSunday:sunday
                                                           isCanChooseNotInMonth:mIsCanChooseNotInMonth
                                                                     isMarkToday:mIsMarkToday
                                                              isMarkDayWithBgImg:mIsMarkDayWithBgImg
                                                                    selectedDate:currentTile.mSelectedDate] autorelease];
	[refresh setTarget:self action:@selector(tile:)];
	
	[self.tileBox addSubview:refresh];
	[currentTile removeFromSuperview];
	[currentTile release];
	currentTile = [refresh retain];
}

- (void)tile:(NSArray*)ar {
	if([ar count] < 2){
        if([delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)]) {
            int currentMonth = [[currentTile.monthDate dateToNSStringWithFormat:@"MM"] intValue];
            int selectedMonth = [[currentTile.mSelectedDate dateToNSStringWithFormat:@"MM"] intValue];
            if (currentMonth != selectedMonth) {
//                NSLog(@"\n\n <<<<<   currentMonth != selectedMonth  [[[[[ refresh ]]]]]!!!\n\n");
                [self selectDate:[self dateSelected]];
                [currentTile setMSelectedDate:[self dateSelected]];
                [self reload];
                [self selectDate:currentTile.mSelectedDate];
                
            } else {
//                NSLog(@"\n\n <<<<<   currentMonth ======== selectedMonth\n\n");
                [currentTile setMSelectedDate:[self dateSelected]];
                [self selectDate:currentTile.mSelectedDate];
            }
			[delegate calendarMonthView:self didSelectDate:[self dateSelected]];
        }
	
	} else {
        int direction = [[ar lastObject] intValue];
		UIButton *b = direction > 1 ? self.rightArrow : self.leftArrow;
		[self changeMonthAnimation:b];
        
		int day = [[ar objectAtIndex:0] intValue];
        TKDateInformation info = [[currentTile monthDate] dateInformation];
        info.day = day;
        NSDate *dateForMonth = [NSDate dateFromDateInformation:info];
		[currentTile selectDay:day];
        
        //dengfang set mSelectedDate
        int tmpYear = [[currentTile.monthDate dateToNSStringWithFormat:@"yyyy"] intValue];
        int tmpMonth = [[currentTile.monthDate dateToNSStringWithFormat:@"MM"] intValue];
        NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%d-%d-%d", tmpYear, tmpMonth, day];
        currentTile.mSelectedDate = [tmpString stringToNSDateWithFormat:@"yyyy-MM-dd"];
//        NSLog(@"currentTile.mSelectedDate ===========================1111111111 %@", [currentTile.mSelectedDate description]);
        [tmpString release];
        
		if([delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:selectedDate:)]) {
			[delegate calendarMonthView:self monthDidChange:dateForMonth selectedDate:currentTile.mSelectedDate];
        }
        if([delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)]) {
            [self selectDate:currentTile.mSelectedDate];
//			[delegate calendarMonthView:self didSelectDate:[self dateSelected]];
            [delegate calendarMonthView:self didSelectDate:currentTile.mSelectedDate];
        }
	}
}

- (UIImageView *) topBackground{
	if(topBackground==nil){
		topBackground = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Grid Top Bar.png")]];
	}
	return topBackground;
}
- (UILabel *) monthYear{
	if(monthYear==nil){
		monthYear = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tileBox.frame.size.width, 38)];
		
		monthYear.textAlignment = NSTextAlignmentCenter;
		monthYear.backgroundColor = [UIColor clearColor];
		monthYear.font = [UIFont boldSystemFontOfSize:22];
		monthYear.textColor = [UIColor colorWithRed:59/255.0 green:73/255.0 blue:88/255.0 alpha:1];
	}
	return monthYear;
}
- (UIButton *) leftArrow{
	if(leftArrow==nil){
		leftArrow = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		leftArrow.tag = 0;
		[leftArrow addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
		[leftArrow setImage:[UIImage imageNamedTK:@"TapkuLibrary.bundle/Images/calendar/Month Calendar Left Arrow"] forState:0];
		
		leftArrow.frame = CGRectMake(0, 0, 48, 38);
	}
	return leftArrow;
}
- (UIButton *) rightArrow{
	if(rightArrow==nil){
		rightArrow = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		rightArrow.tag = 1;
		[rightArrow addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
		rightArrow.frame = CGRectMake(320-45, 0, 48, 38);
		


		[rightArrow setImage:[UIImage imageNamedTK:@"TapkuLibrary.bundle/Images/calendar/Month Calendar Right Arrow"] forState:0];
		
	}
	return rightArrow;
}
- (UIScrollView *) tileBox{
	if(tileBox==nil){
		tileBox = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, currentTile.frame.size.height)];
	}
	return tileBox;
}
- (UIImageView *) shadow{
	if(shadow==nil){
		shadow = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Shadow.png")]];
	}
	return shadow;
}
@end
