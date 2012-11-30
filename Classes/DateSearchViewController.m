//
//  DateSearchViewController.m
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

#import "DateSearchViewController.h"
#import "AppManager.h"

@implementation DateSearchViewController


@synthesize datePicker, dateSearchOptions, dateFormatter;
@synthesize startDate, endDate, selectedDate, tvCell, allDatesSwitch;

AppManager *appMgr;


BOOL allFilesFlag;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.dateFormatter = [[NSDateFormatter alloc] init];
	self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
	self.dateFormatter.dateFormat = @"MM/dd/yyyy";
	appMgr = AppManager.singletonAppManager;

	if ([appMgr.searchFilter isDateFilteringActive] == NO)
	{
		self.startDate = [self.dateFormatter dateFromString:@"01/01/2000"];
		self.endDate = [NSDate date];
		self.datePicker.enabled = NO;
		self.datePicker.alpha = 0.25;
		
	} 
	else 
	{
		self.startDate = appMgr.searchFilter.startDate;
		self.endDate = appMgr.searchFilter.endDate;
		self.datePicker.enabled = YES;
		self.datePicker.alpha = 1.0;

	}
		
	self.datePicker.datePickerMode = UIDatePickerModeDate;
	appMgr = AppManager.singletonAppManager;
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"dateSearchId";
	UITableViewCell *cell;
	
	// dequeue cell
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	// perform cell specific operations
	switch (indexPath.row) 
	{

		case 0:
			self.allDatesSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
			[cell.textLabel setText:@"All Dates"];
			cell.accessoryView = self.allDatesSwitch;
			if ([appMgr.searchFilter isDateFilteringActive]) 
				[(UISwitch *)cell.accessoryView setOn:NO];   
			else
				[(UISwitch *)cell.accessoryView setOn:YES];  
			
			[(UISwitch *)cell.accessoryView addTarget:self 
											   action:@selector(setAllDatesFlag:)
									 forControlEvents:UIControlEventValueChanged];
			break;

		case 1:
			[cell.textLabel setText:@"Start Date"];
			[cell.detailTextLabel setText:[self.dateFormatter stringFromDate:startDate]];
			break;
		
		case 2:
			[cell.textLabel setText:@"End Date"];
			[cell.detailTextLabel setText:[self.dateFormatter stringFromDate:endDate]];
			break;
		
		default:
			break;
	}
	
	return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.row) 
	{
			
		case 0:
			self.selectedDate = nil;
			break;
			
		case 1:
			self.selectedDate = self.startDate;
			 break;
			
		case 2:
			self.selectedDate = self.endDate;
			break;
			
		default:
			self.selectedDate = nil;
			break;
	}
	
	
}



- (IBAction)setDate:(id)sender 
{
	NSIndexPath *selIndexPath;
	
	if (self.selectedDate != nil)
	{
		if (self.selectedDate == self.startDate)
			self.startDate = [self.datePicker date];
		else if (self.selectedDate == self.endDate) {
			self.endDate = [self.datePicker date];
		}
		selIndexPath = [self.dateSearchOptions indexPathForSelectedRow];
		[self.dateSearchOptions reloadData];
		[self.dateSearchOptions selectRowAtIndexPath:selIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
		[self tableView:self.dateSearchOptions didSelectRowAtIndexPath:selIndexPath];
	}
	
}

- (void) setAllDatesFlag:(id)sender
{
	// test all files selection 
	if ([self.allDatesSwitch isOn]) {
		NSLog(@"setAllFileFlag selector set to On.");
		self.datePicker.enabled = NO;
		self.datePicker.alpha = 0.25;
		appMgr.searchFilter.filterOnDates = NO;
	} else {
		NSLog(@"setAllFileFlag selector set to Off.");
		self.datePicker.enabled = YES;
		self.datePicker.alpha = 1.0;
		appMgr.searchFilter.filterOnDates = YES;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Filter By Date", @"");
            break;
        case 1:
            title = NSLocalizedString(@"Filter By Publication", @"");
            break;
        default:
            break;
    }
    return title;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewWillDisappear:(BOOL)animated
{
	if ([self.allDatesSwitch isOn] == YES)
	{
		[appMgr.searchFilter removeDateFilter];
	}	
	else 
	{
		[appMgr.searchFilter setDateFilter:startDate endDate:endDate];
	}
	
	[appMgr.mapVC updateMapWithFilter];
	
	
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{   
	
	[super dealloc];
	
}


@end
