//
//  Created by dengfang on 11-11-08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TKCalendarMonthTableViewController.h"
#import "NSDate+TKCategory.h"

@implementation TKCalendarMonthTableViewController
@synthesize tableView = _tableView;

- (void) viewDidUnload {
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
	self.tableView = nil;
}
- (void) dealloc {
	self.tableView = nil;
    [super dealloc];
}

- (void) loadView{
	[super loadView];
	
	float y,height;
	y = self.monthView.frame.origin.y + self.monthView.frame.size.height;
	height = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - y;
	
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, 320, height) style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	[self.view sendSubviewToBack:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 0;	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];//dengfang
//        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    return cell;
}


- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)d{
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthDidChange:(NSDate*)d selectedDate:(NSDate *)sDate {
	[self updateTableOffset];
}

- (void) updateTableOffset{
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	
	float y = self.monthView.frame.origin.y + self.monthView.frame.size.height;
	self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, y, self.tableView.frame.size.width, self.view.frame.size.height - y );
	
	[UIView commitAnimations];
}







@end
