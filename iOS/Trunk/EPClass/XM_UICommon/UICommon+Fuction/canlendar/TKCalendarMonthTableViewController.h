//
//  Created by dengfang on 11-11-08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarMonthViewController.h"

@interface TKCalendarMonthTableViewController : TKCalendarMonthViewController <UITableViewDelegate, UITableViewDataSource>  {
	UITableView *_tableView;
}
@property (retain,nonatomic) UITableView *tableView;
- (void) updateTableOffset;
@end
