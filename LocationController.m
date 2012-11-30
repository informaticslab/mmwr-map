//
//  LocationController.m
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
#import "LocationController.h"

@implementation LocationController

@synthesize currentLocation;

static LocationController *sharedInstance;

+ (LocationController *)sharedInstance 
{
    @synchronized(self) {
        if (!sharedInstance)
            [[LocationController alloc] init];      
    }
    return sharedInstance;
}

+(id)alloc 
{
    @synchronized(self) {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton LocationController.");
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}

-(id) init 
{
    if ((self = [super init])) {
        self.currentLocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        // [self start];
        [self startSignificantChangeUpdates];
    }
    return self;
}

-(void) start 
{
    [locationManager startUpdatingLocation];
    
    
}

-(void) stop 
{
    [locationManager stopUpdatingLocation];
}


-(void)stopMonitoringSignificantLocationChanges
{
    
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
    
}
- (void)startSignificantChangeUpdates
{
    locationManager.delegate = self;
    [locationManager startMonitoringSignificantLocationChanges];
    
}

-(BOOL) locationKnown 
{ 
	if (round(currentLocation.speed) == -1) 
		return NO; 
	else 
		return YES; 
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
        self.currentLocation = newLocation;
        [self stopMonitoringSignificantLocationChanges];
    }
    // else skip the event and process the next one.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end