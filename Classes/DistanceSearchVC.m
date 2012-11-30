//
//  DistanceSearchVC.m
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

#import "DistanceSearchVC.h"
#import "AppManager.h"

@implementation DistanceSearchVC

@synthesize tvOptions, pvDistance, selectedDistance, distanceOptions;
@synthesize useSelectedLocation, useCurrentLocation;

AppManager *appMgr;
NSNumberFormatter *numFormat;

-(id)init
{
	if ((self = [super initWithNibName:@"DistanceSearchView" bundle:nil]) )
	{
		self.distanceOptions = [[NSArray alloc] initWithObjects:@"5 meters", @"10 meters", @"25 meters", @"50 meters",
								@"100 meters", @"250 meters", @"500 meters", @"1000 meters", nil];
		appMgr = AppManager.singletonAppManager;
		self.selectedDistance = appMgr.searchFilter.withinDistance;
		numFormat = [[NSNumberFormatter alloc] init];
		[numFormat setNumberStyle:NSNumberFormatterDecimalStyle];

	}
	
	return self;
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
	
	if ([self.useCurrentLocation isOn] == YES)
	{
		[appMgr.searchFilter setCurrentLocationDistanceFilter:self.selectedDistance];
	}	
	else 
	{
		[appMgr.searchFilter setSelectedLocationDistanceFilter:self.selectedDistance];
	}
	
	[appMgr.mapVC updateMapWithFilter];
}


- (void)viewDidAppear:(BOOL)animated
{
	self.useCurrentLocation = [[UISwitch alloc] initWithFrame:CGRectZero];
	self.useSelectedLocation = [[UISwitch alloc] initWithFrame:CGRectZero];
	
//	if (appMgr.searchFilter.allLocations) {
//		[self disableLocationControls];
//	}
//	
//	else {
//		[self enableLocationControls];
//	}
	
}


#pragma mark -
#pragma mark UIPickerViewDataSource Methods

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
    return 1;
}
- (NSInteger) pickerView: (UIPickerView *) pickerView numberOfRowsInComponent: (NSInteger) component {
    return [self.distanceOptions count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate Methods

- (NSString *) pickerView: (UIPickerView *) pickerView
              titleForRow: (NSInteger) row forComponent: (NSInteger) component {
    return [self.distanceOptions objectAtIndex:row];
}


- (void) pickerView: (UIPickerView *) pickerView
       didSelectRow: (NSInteger) row inComponent: (NSInteger) component 
{
	NSIndexPath *selIndexPath;
    self.selectedDistance = [numFormat numberFromString:[self.distanceOptions objectAtIndex:row]];
	selIndexPath = [self.tvOptions indexPathForSelectedRow];
	[self.tvOptions reloadData];
	[self.tvOptions selectRowAtIndexPath:selIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
	[self tableView:self.tvOptions didSelectRowAtIndexPath:selIndexPath];
	
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
    
	static NSString *CellIdentifier = @"locationSearchId";
	UITableViewCell *cell;
	
	// dequeue cell
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	
	// perform cell specific operations
	switch (indexPath.row) 
	{
			
		case 0:
			[cell.textLabel setText:@"Use Current Location"];
			if (appMgr.searchFilter.filterOnCurrentLocationDistance) 
				[self.useCurrentLocation setOn:YES];   
			else
				[self.useCurrentLocation setOn:NO];   
			[self.useCurrentLocation addTarget:self 
										action:@selector(setUseCurrentLocationFlag:)
							  forControlEvents:UIControlEventValueChanged];
			cell.accessoryView = self.useCurrentLocation;
			break;
			
		case 1:
			[cell.textLabel setText:@"Use Selected Location"];
			if (appMgr.searchFilter.filterOnSelectedLocationDistance) 
				[self.useSelectedLocation setOn:YES];   
			else
				[self.useSelectedLocation setOn:NO];   
			[self.useSelectedLocation addTarget:self 
										action:@selector(setUseSelectedLocationFlag:)
							  forControlEvents:UIControlEventValueChanged];
			cell.accessoryView = self.useSelectedLocation;
			break;
			
		case 2:
			[cell.textLabel setText:@"Distance from Location"];
			[cell.detailTextLabel setText:[numFormat stringFromNumber:self.selectedDistance]];
			break;
			
		default:
			break;
	}
	
	return cell;
	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


- (void) setUseCurrentLocationFlag:(id)sender
{
	// test all files selection 
	if ([self.useCurrentLocation isOn]) {
		NSLog(@"setUseCurrentLocationsFlag selector set to On.");
		[self.useSelectedLocation setOn:NO];
		appMgr.searchFilter.filterOnCurrentLocationDistance = YES;
		appMgr.searchFilter.filterOnSelectedLocationDistance = NO;
	} else {
		NSLog(@"setUseCurrentLocationsFlag selector set to Off.");
		appMgr.searchFilter.filterOnCurrentLocationDistance = NO;
	}
}

- (void) setUseSelectedLocationFlag:(id)sender
{
	// test all files selection 
	if ([self.useSelectedLocation isOn]) {
		NSLog(@"setUseSelectedLocationsFlag selector set to On.");
		[self.useCurrentLocation setOn:NO];
		appMgr.searchFilter.filterOnSelectedLocationDistance = YES;
		appMgr.searchFilter.filterOnCurrentLocationDistance = NO;
	} else {
		NSLog(@"setUseCurrentSelectedFlag selector set to Off.");
		appMgr.searchFilter.filterOnSelectedLocationDistance = NO;
	}
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

