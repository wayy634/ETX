//
//  Created by dengfang on 11-11-08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (TKCategory)

struct TKDateInformation {
	NSInteger day;
	NSInteger month;
	NSInteger year;
	
	NSInteger weekday;
	
	NSInteger minute;
	NSInteger hour;
	NSInteger second;
	
};
typedef struct TKDateInformation TKDateInformation;

- (TKDateInformation) dateInformation;
- (TKDateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz;
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info;
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info timeZone:(NSTimeZone*)tz;


@property (readonly,nonatomic) NSString *month;
@property (readonly,nonatomic) NSString *year;
@property (readonly,nonatomic) NSInteger weekdayWithMondayFirst;
@property (readonly,nonatomic) BOOL isToday;


- (BOOL) isSameDay:(NSDate*)anotherDate;
- (NSInteger) differenceInDaysTo:(NSDate *)toDate;
- (NSInteger) differenceInMonthsTo:(NSDate *)toDate;

- (int) daysBetweenDate:(NSDate*)d;



- (NSString*) dateDescription;
- (NSDate *) dateByAddingDays:(NSUInteger)days;
+ (NSDate *) dateWithDatePart:(NSDate *)aDate andTimePart:(NSDate *)aTime;

+ (NSString*) dateInformationDescriptionWithInformation:(TKDateInformation)info;

@end
