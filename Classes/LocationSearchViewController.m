//
//  LocationSearchViewController.m
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

#import "LocationSearchViewController.h"
#import "AppManager.h"
#import "AppDelegate.h"

@implementation LocationSearchViewController


@synthesize locationPicker, dataSource, segmentedControl, btnDone;
@synthesize locationSearchOptions, allLocationsSwitch,selectedLocation;

MmwrLocations *locations;
AppManager *appMgr;

- (id)initWithLocations:(MmwrLocations *)mmwrLocations
{
    if ((self = [super initWithNibName:@"LocationSearchView" bundle:nil]))    {
		locations = mmwrLocations;
        self.dataSource = [mmwrLocations getCountries];  
		self.selectedLocation = [self.dataSource objectAtIndex:0];
		appMgr = AppManager.singletonAppManager;

    }
    
    return self;
}

-(void)viewDidLoad
{
    [self.segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBezeled];
    
}


- (void)viewDidAppear:(BOOL)animated
{

	if ([appMgr.searchFilter isLocationNameFilteringActive]) 
		[self enableLocationControls];
	else 
		[self disableLocationControls];
	
}

- (void) disableLocationControls
{
	self.locationPicker.alpha = 0.30;
	self.segmentedControl.enabled = NO;
    self.segmentedControl.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.3];

}

- (void) enableLocationControls
{
    
	self.locationPicker.alpha = 1.0;
	self.segmentedControl.enabled = YES;
    self.segmentedControl.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    
	
}

-(IBAction) segmentedControlIndexChanged:(id)sender
{
    
	switch (self.segmentedControl.selectedSegmentIndex) 
	{
		case 0:
			self.dataSource = [locations getCountries];
			break;
		case 1:
			self.dataSource = [locations getStates];
			break;
		case 2:
			self.dataSource = [locations getCounties];
			break;
		case 3:
			self.dataSource = [locations getTowns];
			break;
		case 4:
			self.dataSource = [locations getPois];
			break;
		default:
			break;

	}
	[self.locationPicker reloadAllComponents];
	self.selectedLocation = [dataSource objectAtIndex:0];

}

-(IBAction) btnDone:(id)sender
{
	
}

- (void) setAllLocationsFlag:(id)sender
{
	// test all files selection 
	if ([self.allLocationsSwitch isOn]) {
		NSLog(@"setAllLocationsFlag selector set to On.");
		[self disableLocationControls];
		appMgr.searchFilter.filterOnLocationName = NO;
	} else {
		NSLog(@"setAllLocationsFlag selector set to Off.");
		[self enableLocationControls];
		appMgr.searchFilter.filterOnLocationName = YES;
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 2;
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
			self.allLocationsSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
			[cell.textLabel setText:@"Search All Locations"];
			cell.accessoryView = self.allLocationsSwitch;
			if ([appMgr.searchFilter isLocationNameFilteringActive]) 
				[(UISwitch *)cell.accessoryView setOn:NO];   
			else
				[(UISwitch *)cell.accessoryView setOn:YES
				 ];   
			[(UISwitch *)cell.accessoryView addTarget:self 
											   action:@selector(setAllLocationsFlag:)
									 forControlEvents:UIControlEventValueChanged];
			break;
			
		case 1:
			[cell.textLabel setText:@"Search Selected Location"];
			[cell.detailTextLabel setText:self.selectedLocation];
			break;
			
		default:
			break;
	}
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	switch (indexPath.row) 
	{
		case 0:
			break;
			
		case 1:
			break;
			
		case 2:
			break;
			
		default:
			break;
	}
}


#pragma mark -
#pragma mark UIPickerViewDataSource Methods

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
    return 1;
}
- (NSInteger) pickerView: (UIPickerView *) pickerView numberOfRowsInComponent: (NSInteger) component {
    return [dataSource count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate Methods

- (NSString *) pickerView: (UIPickerView *) pickerView
              titleForRow: (NSInteger) row forComponent: (NSInteger) component {
    return [dataSource objectAtIndex:row];
}
- (void) pickerView: (UIPickerView *) pickerView
       didSelectRow: (NSInteger) row inComponent: (NSInteger) component 
{
	NSIndexPath *selIndexPath;
	
    self.selectedLocation = [dataSource objectAtIndex:row];
	selIndexPath = [self.locationSearchOptions indexPathForSelectedRow];
	[self.locationSearchOptions reloadData];
	[self.locationSearchOptions selectRowAtIndexPath:selIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
	[self tableView:self.locationSearchOptions didSelectRowAtIndexPath:selIndexPath];
	
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


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(void)viewWillDisappear:(BOOL)animated
{
	
	if (self.allLocationsSwitch.on == YES)
	{
		[appMgr.searchFilter removeLocationNameFilter];
	}	
	else 
	{
		[appMgr.searchFilter setLocationNameFilter:self.selectedLocation];
	}
	
	[appMgr.mapVC updateMapWithFilter];
}

@end
