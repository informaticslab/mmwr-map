//
//  LocationSearchViewController.h
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
#import "MmwrLocations.h"


@interface LocationSearchViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate> 
{

	UITableView *locationSearchOptions;
    UIPickerView *locationPicker;
	NSArray *dataSource;
	UISegmentedControl *segmentedControl;
	UIBarButtonItem *btnDone;
	UISwitch *allLocationsSwitch;
	NSString *selectedLocation;
}

@property (nonatomic, retain) IBOutlet UITableView *locationSearchOptions;
@property (nonatomic, retain) IBOutlet UIPickerView *locationPicker;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,retain) UIBarButtonItem *btnDone;
@property (nonatomic,retain) UISwitch *allLocationsSwitch;
@property (nonatomic, retain) NSString *selectedLocation;

- (id)initWithLocations:(MmwrLocations *)mmwrLocations;
- (IBAction) segmentedControlIndexChanged:(id)sender;
- (IBAction) btnDone:(id)sender;
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void) disableLocationControls;
- (void) enableLocationControls;



@end
