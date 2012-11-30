//
//  MapViewController.m
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

#import "MapViewController.h"
#import "AddressAnnotation.h"
#import "SettingsPopoverView.h"
#import "ArticlesPopoverViewController.h"
#import "DateSearchViewController.h"
#import "LocationSearchViewController.h"
#import "DistanceSearchVC.h"
#import "MmwrLocations.h"
#import "LocationController.h"
#import "Debug.h"
#import <MapKit/MapKit.h>
#import "AppManager.h"
#import "EulaViewController.h"

@implementation MapViewController
@synthesize popoverController;
@synthesize btnSettings;
@synthesize btnDateSearch;
@synthesize btnLocationSearch;
@synthesize btnDistanceSearch;

AppManager *appMgr;
AddressAnnotation *addAnnotation;
MmwrLocations *mmwrLocations; 
// LocationController *locationController;
bool initialMapLoad;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	
	[super viewDidLoad];
	appMgr = AppManager.singletonAppManager;
    mmwrLocations = [[MmwrLocations alloc] init]; 
	[mmwrLocations mapAnnotations:mapView];
	[mapView setShowsUserLocation:YES];
	appMgr.mapVC = self;
//	GSL - Comment out lines below to see if we can use the MapView's built-in support for user's current location 
    //locationController = LocationController.sharedInstance;
    
	
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self presentEulaModalView];

    
}

- (void)didDismissModalView {
    
    // Dismiss the modal view controller
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)presentEulaModalView
{
    
    if (appMgr.agreedWithEula == TRUE)
        return;
    
    // store the data
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currVersion = [NSString stringWithFormat:@"%@.%@", 
                             [appInfo objectForKey:@"CFBundleShortVersionString"], 
                             [appInfo objectForKey:@"CFBundleVersion"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersionEulaAgreed = (NSString *)[defaults objectForKey:@"agreedToEulaForVersion"];
    
    
    // was the version number the last time EULA was seen and agreed to the 
    // same as the current version, if not show EULA and store the version number
    if (![currVersion isEqualToString:lastVersionEulaAgreed]) {
        [defaults setObject:currVersion forKey:@"agreedToEulaForVersion"];
        [defaults synchronize];
        NSLog(@"Data saved");
        NSLog(@"%@", currVersion);
        
        // Create the modal view controller
        EulaViewController *eulaVC = [[EulaViewController alloc] initWithNibName:@"EulaViewController" bundle:nil];
        
        // we are the delegate that is responsible for dismissing the help view
        eulaVC.delegate = self;
        eulaVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentModalViewController:eulaVC animated:YES];
        
    }
    
}



- (IBAction)showCurrentLocation
{
	
	CLLocationCoordinate2D userLoc;
	userLoc.latitude = mapView.userLocation.location.coordinate.latitude;
	userLoc.longitude = mapView.userLocation.location.coordinate.longitude;
	mapView.region = MKCoordinateRegionMakeWithDistance(userLoc, 2000000, 2000000);
    
	
}


- (IBAction)showDateFilters
{  
	
	if ([self.popoverController isPopoverVisible] == YES ) 
		[popoverController dismissPopoverAnimated:YES];
	else {
		DebugLog(@"The Search by Date button has been hit.");
		
		DateSearchViewController *dateSearchPopover = [[DateSearchViewController alloc] initWithNibName:@"DateSearch" bundle:nil ];
        dateSearchPopover.contentSizeForViewInPopover = CGSizeMake(380,480);

		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:dateSearchPopover];
		self.popoverController = popover;
		popoverController.delegate = self;
		
		[popover release];
		[dateSearchPopover release];
		
		[popoverController presentPopoverFromBarButtonItem:btnDateSearch
								  permittedArrowDirections:UIPopoverArrowDirectionAny 
												  animated:YES];
		
	}
}

- (IBAction)showLocationFilters
{  
	
	if ([self.popoverController isPopoverVisible] == YES ) 
		[popoverController dismissPopoverAnimated:YES];
	else {
		DebugLog(@"The Search by Location button has been hit.");
		
		LocationSearchViewController *locationSearchPopover = [[LocationSearchViewController alloc] initWithLocations:mmwrLocations];
        locationSearchPopover.contentSizeForViewInPopover = CGSizeMake(508,421);

		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:locationSearchPopover];
		self.popoverController = popover;
		popoverController.delegate = self;
		[popover release];
		[locationSearchPopover release];
		
		[popoverController presentPopoverFromBarButtonItem:btnLocationSearch
								  permittedArrowDirections:UIPopoverArrowDirectionAny 
												  animated:YES];
		
	}
}

- (IBAction)showDistanceFilters
{  
	
	if ([self.popoverController isPopoverVisible] == YES ) 
		[popoverController dismissPopoverAnimated:YES];
	else {
		DebugLog(@"The Search by Location button has been hit.");
		
		DistanceSearchVC *distanceSearchPopover = [[DistanceSearchVC alloc] init];
        distanceSearchPopover.contentSizeForViewInPopover = CGSizeMake(349,428);

		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:distanceSearchPopover];
		self.popoverController = popover;
		popoverController.delegate = self;
		
		[popover release];
		[distanceSearchPopover release];
		
		[popoverController presentPopoverFromBarButtonItem:btnDistanceSearch
								  permittedArrowDirections:UIPopoverArrowDirectionAny 
												  animated:YES];
        
		
	}
}

- (void)showSettings:(id)sender
{
	if ([self.popoverController isPopoverVisible] == YES ) 
		[popoverController dismissPopoverAnimated:YES];
	else {
		DebugLog(@"The settings button has been hit.");
		
		SettingsPopoverView *settingsPopover = [[SettingsPopoverView alloc] initWithNibName:@"SettingsPopoverView" bundle:nil ];
        settingsPopover.contentSizeForViewInPopover = CGSizeMake(360,600);
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:settingsPopover];
		self.popoverController = popover;
		popoverController.delegate = self;
		
		[popover release];
		[settingsPopover release];
		
		[popoverController presentPopoverFromBarButtonItem:btnSettings
								  permittedArrowDirections:UIPopoverArrowDirectionAny 
												  animated:YES];
		
	}
	
}

- (void)updateMapWithFilter
{
    //	GSL - Comment out lines below to see if we can use the MapView's built-in support for user's current location 
//    LocationController *locationController = [LocationController sharedInstance];
//	CLLocation *myLocation = [locationController currentLocation];
//	if ([locationController locationKnown])
//		NSLog(@"Current location is %@", [myLocation description]);	
//	else
//		NSLog(@"Currrent location unknown.");

	[mmwrLocations applyFilters];
	[mmwrLocations mapAnnotations:mapView];
	if ([appMgr.searchFilter isLocationNameFilteringActive] == YES) 
	{
		MmwrLocation *selectedLocation = [mmwrLocations getMmwrLocation:appMgr.searchFilter.selectedLocation];
		
		[self showLocation:selectedLocation];
	}
	
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
     
}


- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    NSLog(@" didAddAnnotationViews with views count = %d", [views count]);

	MKAnnotationView *anView = [views objectAtIndex:0];
	
	id <MKAnnotation> mp = [anView annotation];
   NSLog(@" coordinates = %f, %f",[mp coordinate].latitude, [mp coordinate].longitude);
//	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 5000000, 5000000);
//	[mv setRegion:region animated:NO];
//    [mv setCenterCoordinate:[mp coordinate] animated:YES];

}


- (void)showLocation:(MmwrLocation *)mmwrLocation 
{
	
//	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.8;
	span.longitudeDelta=0.8;
	
    //	GSL - Comment out lines below to see if we can use the MapView's built-in support for user's current location 
	// CLLocationCoordinate2D location = mmwrLocation.location;
	CLLocationCoordinate2D location = [mapView userLocation].location.coordinate;
    [mapView setCenterCoordinate:location animated:TRUE];  
//	region.span=span;
//	region.center=location;
//	[mapView setRegion:region animated:FALSE];
//	[mapView regionThatFits:region];
	
}



- (IBAction) showAddress {
	
	//Hide the keypad
	[addressField resignFirstResponder];
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.2;
	span.longitudeDelta=0.2;
	
	CLLocationCoordinate2D location = [self addressLocation];
	region.span=span;
	region.center=location;
	if(addAnnotation != nil) {
		[mapView removeAnnotation:addAnnotation];
		[addAnnotation release];
		addAnnotation = nil;
	}
	addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location name:nil addressType:nil];
	//addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	[mapView addAnnotation:addAnnotation];
	[mapView setRegion:region animated:FALSE];
	[mapView regionThatFits:region];
	
}

-(CLLocationCoordinate2D) addressLocation 
{
	NSError *error;
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
						   [addressField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
	
    double latitude = 0.0;
    double longitude = 0.0;
	
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
		//Show error
    }
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
	
    return location;
}


- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (pinView == nil) {
        
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        pinView.frame = CGRectMake(0, 0, 25, 25);
    } else {
        
        pinView.annotation = annotation;
        
    }   
    pinView.animatesDrop=FALSE;
    pinView.canShowCallout = YES;
    pinView.calloutOffset = CGPointMake(-10, 10);

    if (pinView.annotation == theMapView.userLocation) {
		pinView.pinColor = MKPinAnnotationColorGreen;   
        NSLog(@"view for current location annotation with title: %@", [annotation title]);
        //	GSL - Comment out lines below to see if we can use the MapView's built-in support for user's current location 
        // [mapView setShowsUserLocation:FALSE];        
    } else {
		UIButton *disclosureBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		pinView.rightCalloutAccessoryView = disclosureBtn;
		pinView.pinColor = MKPinAnnotationColorPurple;   
        
    }

    NSLog(@"Setting view for annotation with title: %@", [annotation title]);
    return pinView;
}

- (void)mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	
	ArticlesPopoverViewController *locationArticlesVC;
	AddressAnnotation *addrView = (AddressAnnotation *)view.annotation;
	
	DebugLog(@"Disclosure button tapped for %@.", addrView.title);
	
	MmwrLocation *currentLocation = [mmwrLocations getMmwrLocationFromString:addrView.title];
	if (currentLocation != nil) {
		
		locationArticlesVC = [[ArticlesPopoverViewController alloc] initWithLocation:currentLocation];
		
		//create a popover controller
		UIPopoverController *popoverControllerDetail = [[UIPopoverController alloc] initWithContentViewController:locationArticlesVC];
		[popoverControllerDetail setPopoverContentSize:CGSizeMake(820,320)];
		
		
		
		// create frame so that popover can be placed in the correct spot
		CGPoint annotationPoint = [aMapView convertCoordinate:view.annotation.coordinate toPointToView:aMapView];
		float boxDY=annotationPoint.y;
		float boxDX=annotationPoint.x;
		CGRect box = CGRectMake(boxDX,boxDY,5,5);
		UILabel *displayLabel = [[UILabel alloc] initWithFrame:box];
		[popoverControllerDetail presentPopoverFromRect:displayLabel.frame inView:aMapView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		[displayLabel release];
		
	}
	else {
		NSLog(@"Can't find location for title %@s", addrView.title);
	}
	
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
        return YES;
    else 
        return NO;

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


- (void)dealloc 
{
    [mmwrLocations release];
    [super dealloc];
}


@end
