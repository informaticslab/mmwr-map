//
//  MapViewController.h
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
#import <MapKit/MapKit.h>
#import "MmwrLocation.h"
#import "ModalViewDelegate.h"

@interface MapViewController : UIViewController<MKMapViewDelegate, UIPopoverControllerDelegate,  ModalViewDelegate> 
{
	
	IBOutlet UITextField *addressField;
	IBOutlet UIButton *goButton;
	IBOutlet MKMapView *mapView;
	UIBarButtonItem *btnSettings;
	UIBarButtonItem *btnDateSearch;
	UIBarButtonItem *btnLocationSearch;
	UIBarButtonItem *btnDistanceSearch;
	UIPopoverController *popoverController;

}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnSettings;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnDateSearch;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnLocationSearch;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnDistanceSearch;
@property (nonatomic, retain) UIPopoverController *popoverController;

- (CLLocationCoordinate2D) addressLocation;
- (IBAction) showAddress;
- (IBAction) showDateFilters;
- (IBAction) showLocationFilters;
- (IBAction) showCurrentLocation;
- (IBAction)showDistanceFilters;
- (void)showSettings:(id)sender;
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation;
- (void)updateMapWithFilter;
- (void) showLocation:(MmwrLocation *)mmwrLocation;

@end
