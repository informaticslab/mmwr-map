    //
//  SettingsPopoverView.m
//  mmwrMockup
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

#import "SettingsPopoverView.h"
#import "Debug.h"

@implementation SettingsPopoverView



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There are six sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
	int rows = 0;
    // There are six sections.
    switch (section) {
		case 0:
			rows = 4;
			break;
		case 1:
			rows = 4;
			break;
		case 2:
			rows = 1;
			break;
		case 3:
			rows = 1;
			break;
		default:
			break;
	}
	return rows;
}

#pragma mark -
#pragma mark Rotation support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	DebugLog(@" answer is yes");
    return YES;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"SettingsCellIdentifier";
	UISwitch *uiSwitch;
	UISlider *slider;
	UITextField *textField;
	UIButton *button;
	CGRect rect;
	
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		// switch on sections and then rows
		switch (indexPath.section) {
			case 0:
				// Reading Preferences
				switch (indexPath.row) {
					case 0:
						[cell.textLabel setText:@"Offline Reading"];
						uiSwitch = [[[UISwitch alloc] init] autorelease];
						cell.accessoryView = uiSwitch;
						break;
					case 1:
						[cell.textLabel setText:@"Store Loaded Content"];
						uiSwitch = [[[UISwitch alloc] init] autorelease];
						//[cell addSubview:mySwitch];
						cell.accessoryView = uiSwitch;
						break;
					case 2:
						[cell.textLabel setText:@"Brightness"];
						rect = CGRectMake(20.0, 2.0, 200.0, 40.0);
						slider = [[[UISlider alloc] initWithFrame:rect] autorelease];
						slider.maximumValue = 100;
						slider.minimumValue = 0;
						slider.value = 50;
						[cell addSubview:slider];
						cell.accessoryView = slider;
						break;
					case 3:
						[cell.textLabel setText:@"Font Size"];
						rect = CGRectMake(20.0, 2.0, 200.0, 40.0);
						slider = [[[UISlider alloc] initWithFrame:rect] autorelease];
						slider.maximumValue = 100;
						slider.minimumValue = 0;
						slider.value = 50;
						[cell addSubview:slider];
						cell.accessoryView = slider;
						break;
					default:
						break;
				}
				break;
				
			case 1:
				// Reading Preferences
				switch (indexPath.row) {
					case 0:
						[cell.textLabel setText:@"Send Email"];
						uiSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
						[cell addSubview:uiSwitch];
						cell.accessoryView = uiSwitch;
						break;
					case 1:
						[cell.textLabel setText:@"Send Text Message"];
						uiSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
						[cell addSubview:uiSwitch];
						cell.accessoryView = uiSwitch;
						break;
					case 2:
						[cell.textLabel setText:@"Email"];
						rect = CGRectMake(20.0, 4.0, 200.0, 40.0);
						textField = [[[UITextField alloc] initWithFrame:rect] autorelease];
						textField.text = @"Joe@bloggs.com";
						[textField setTextAlignment:UITextAlignmentRight];
						[textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
						[cell addSubview:textField];
						cell.accessoryView = textField;
						break;
					case 3:
						[cell.textLabel setText:@"Phone"];
						rect = CGRectMake(20.0, 4.0, 200.0, 40.0);
						textField = [[[UITextField alloc] initWithFrame:rect] autorelease];
						textField.text = @"404-123-1234";
						[textField setTextAlignment:UITextAlignmentRight];
						[textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
						[cell addSubview:textField];
						cell.accessoryView = textField;
						break;
					default:
						break;
				}
				break;
				
				
			case 2:
				// Reading Preferences
				switch (indexPath.row) {
					case 0:
						[cell.textLabel setText:@"Vital Signs"];
						cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
						break;
					default:
						break;
				}
				break;
				
			case 3:
				// Reading Preferences
				switch (indexPath.row) {
					case 0:
						//rect = CGRectMake(20.0, 4.0, 200.0, 40.0);
						//UIButton *button = [[UIButton alloc] init];
						button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
						[button setTitle:@"Give Feedback" forState:UIControlStateNormal];
						button.frame = CGRectMake(10.0, 0.0, 340.0, 46.0);
						[cell addSubview:button];
						//cell.accessoryView = button;
						break;
					default:
						break;
				}
				break;
			default:
				break;
		}
	}
    
    // Set the text in the cell for the section/row.
    return cell;
}


#pragma mark -
#pragma mark Section header titles

/*
 HIG note: In this case, since the content of each section is obvious, there's probably no need to provide a title, but the code is useful for illustration.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Reading Preferences", @"");
            break;
        case 1:
            title = NSLocalizedString(@"Notification Preferences", @"");
            break;
        case 2:
            title = NSLocalizedString(@"On Startup", @"");
            break;
        case 3:
            title = NSLocalizedString(@"", @"");
            break;
        default:
            break;
    }
    return title;
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


@end
