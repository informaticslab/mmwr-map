//
//  DateSearchViewController.h
//  MapApp
//
//
//  Copyright 2011  U.S. Centers for Disease Control and Prevention
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>


@interface DateSearchViewController : UIViewController <UITableViewDelegate> 
{
	
	UIDatePicker *datePicker;
	NSDateFormatter *dateFormatter;
	UITableView *dateSearchOptions;
	UITableViewCell *tvCell;
	UISwitch *allDatesSwitch;
	NSDate *startDate;
	NSDate *endDate;
	
}

@property (nonatomic, retain) IBOutlet UITableView *dateSearchOptions;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;
@property (nonatomic, retain) IBOutlet UISwitch *allDatesSwitch;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (IBAction)setDate:(id)sender;


@end
