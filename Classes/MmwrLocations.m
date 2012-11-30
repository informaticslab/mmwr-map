//
//  MmwrLocations.m
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

#import "MmwrLocations.h"
#import "MmwrArticle.h"
#import "Debug.h"
#import "AddressAnnotation.h"
#import "AppManager.h"

@implementation MmwrLocations

AppManager *appMgr;

AddressAnnotation *addAnnotation;
NSDictionary *addAnnotations;
NSMutableDictionary *allLocations;
NSMutableDictionary *filteredLocations;
NSMutableArray *filteredDates;
NSMutableArray *allDates;
NSMutableSet *countries;
NSMutableSet *states;
NSMutableSet *towns;
NSMutableSet *counties;
NSMutableSet *pois;

- (id)init
{
	allLocations = [[NSMutableDictionary alloc] init];
	appMgr = AppManager.singletonAppManager;
	countries = [[NSMutableSet alloc] initWithCapacity:100];
	states = [[NSMutableSet alloc] init];
	towns = [[NSMutableSet alloc] init];
	counties = [[NSMutableSet alloc] init];
	pois = [[NSMutableSet alloc] init];
	[self readMmwrLocationsFile];
	return self;

}


- (void)readMmwrLocationsFile
{
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	CLLocationCoordinate2D location;
    MmwrLocation *currMmwrLocation;
    MmwrArticle *currMmwrArticle;
    NSDate *date;
    NSString *dateString;
    NSDateFormatter *dateFormatter;
	Boolean newLocation = NO;

    // set up date formatter
    dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
	span.latitudeDelta=0.2;
	span.longitudeDelta=0.2;
	region.span=span;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mmwrplaces" ofType:@"txt"];
	NSString *fileContents = [NSString stringWithContentsOfFile: filePath usedEncoding: NULL error: NULL];
	NSArray  *lines = [fileContents componentsSeparatedByString:@"\n"];
	
	for(int i = 0; i < [lines count]; i++)
	{
        NSArray *lineContents = [[lines objectAtIndex:i] componentsSeparatedByString: @"|"];
		
		if ( [lineContents count] == 12) 
		{
			
			NSString *placeName = [lineContents objectAtIndex:1];
			NSString *placeType = [lineContents objectAtIndex:2];
            [self storeLocationName:placeName placeType:placeType];
			NSNumber *lat = [[NSNumber alloc] initWithDouble: [ [lineContents objectAtIndex:3]doubleValue]];
			NSNumber *lng = [[NSNumber alloc] initWithDouble: [ [lineContents objectAtIndex:4]doubleValue]];

			NSString *url = [lineContents objectAtIndex:0];
			NSNumber *volume = [lineContents objectAtIndex:5];
			NSNumber *issue = [lineContents objectAtIndex:6];
			NSNumber *page = [lineContents objectAtIndex:7];
			NSString *year = [lineContents objectAtIndex:8];
			NSString *month = [lineContents objectAtIndex:9];
			NSString *day = [lineContents objectAtIndex:10];
            NSString *title = [lineContents objectAtIndex:11];
            
			DebugLog(@"Place = %@,%@,%@,%@", placeName, placeType, lat, lng);
            DebugLog(@"Article = %@,%@,%@,%@,%@,%@,%@", volume, issue, page, year,month, day, title);
            
            // create published date object from strings
            dateString = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
            date = [dateFormatter dateFromString:dateString];
			DebugLog(@"Created date object %@ for date string %@", date, dateString);
            
            // if location does not exist yet, create it
            currMmwrLocation = [allLocations objectForKey:placeName];
            if ( currMmwrLocation == nil ) {
				newLocation = YES;
                currMmwrLocation = [[MmwrLocation alloc] initWithPlace:placeName typeOfPlace:placeType latitude:lat longitude:lng];
            } 
			currMmwrArticle = [[MmwrArticle alloc] initWithTitle:title url:url pubDate:date volume:[volume integerValue] issue:[issue integerValue] page:[page integerValue]];
            [currMmwrLocation addArticle:currMmwrArticle];
			location.latitude = [lat doubleValue];
			location.longitude = [lng doubleValue];
						
			if (newLocation) {
				[allLocations setObject:currMmwrLocation forKey:placeName];
                [currMmwrLocation release];
				newLocation = NO;
				[self storeLocationName:placeName placeType:placeType];
			}
			[lat release];
			[lng release];
            [currMmwrArticle release];
			
		}
		
		
		NSString *key;
		MmwrLocation *location;
		for (key in allLocations) {
			location = [allLocations objectForKey:key];
			//location.addressAnnotation.subtitle = [NSString stringWithFormat:@"%d MMWR Articles", [location countOfArticles]];
		}

	}
    
}

-(void)storeLocationName:(NSString *)placeName placeType:(NSString *)placeType
{
	
	if ([placeType isEqualToString:@"Country"])
		[countries addObject:placeName];
	else if ([placeType isEqualToString:@"State"])
		[states addObject:placeName];
	else if ([placeType isEqualToString:@"County"])
		[counties addObject:placeName];
	else if ([placeType isEqualToString:@"Town"])
		[towns addObject:placeName];
	else if ([placeType isEqualToString:@"POI"])
		[pois addObject:placeName];

}

-(NSArray *)getCountries
{
    NSArray *temp = [[countries allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return temp;
	
}

-(NSArray *)getStates
{
    NSArray *temp = [[states allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return temp;
	
}

-(NSArray *)getCounties
{
    NSArray *temp = [[counties allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return temp;
	
}

-(NSArray *)getTowns
{
    NSArray *temp = [[towns allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return temp;
	
}

-(NSArray *)getPois
{
    NSArray *temp = [[pois allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return temp;
	
}

-(MmwrLocation *)getMmwrLocation:(NSString *)locationName
{
	
	MmwrLocation *namedLocation;
	
	namedLocation = [allLocations objectForKey:locationName];
	return namedLocation;
	
}

-(void)mmwrLocationWithinDistance
{

	
}

-(void)mapAnnotations:(MKMapView *)mapView
{
	NSString *key;
	MmwrLocation *location;
	
	for (key in allLocations) {
		
		location = [allLocations objectForKey:key];
		if ([appMgr.searchFilter isFilteringActive]) 
		{
			if (location.isFiltered == NO) {
				[mapView addAnnotation:location.addressAnnotation];
				location.addressAnnotation.subtitle = [NSString stringWithFormat:@"%d MMWR Articles", [location countOfFilteredArticles]];
			}
			else
				[mapView removeAnnotation:location.addressAnnotation];
		}	
		else 
		{
			[mapView addAnnotation:location.addressAnnotation];
			location.addressAnnotation.subtitle = [NSString stringWithFormat:@"%d MMWR Articles", [location countOfArticles]];

		}

	}
	
}

-(void)applyFilters
{
	
	NSString *key;
	MmwrLocation *location;
	MmwrLocation *selectedLocation;
	ArticleSearchFilter *filter = appMgr.searchFilter;
	
	// are we using any location based search filters?
	if ([filter isLocationFilteringActive]) 
	{
		// are using a location name search filter?
		if ([filter isLocationNameFilteringActive]) {
			selectedLocation = [allLocations objectForKey:filter.selectedLocation];
			[selectedLocation filterArticlesByDate:appMgr.searchFilter];
			for (key in allLocations) {
				location = [allLocations objectForKey:key];
				if ([location isEqual:selectedLocation] == NO) 
					[location locationFiltered];
			}
		}
		
		// 
		
	
	}
	else {
		for (key in allLocations) {
			location = [allLocations objectForKey:key];
			[location filterArticlesByDate:appMgr.searchFilter];
		}
		
	}

}


-(MmwrLocation *)getMmwrLocationFromString:(NSString *)locationString
{
		
	MmwrLocation *location = [allLocations valueForKey:locationString];
	return location;
	
}


- (NSPredicate *)dateWithinLast30DaysPredicate
{
	//
	// get the current date
	//
	NSDate *now = [NSDate date];
	
	//
	// get the date 30 days prior to current date
	//
	// because CoreData uses NSDate rather than NSCalendarDate, we'll use
	// an NSCalendar to do the math;
	//
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComps = [[NSDateComponents alloc] init];
	[dateComps setDay:-30];
	NSDate *date30DaysAgo = [calendar
							 dateByAddingComponents:dateComps
							 toDate:now options:0];
	[dateComps release];
	
	//
	// alternatively, we could use:
	//
	// NSCalendarDate *now = [NSCalendarDate calendarDate];
	// NSCalendarDate *date30DaysAgo = [now
	//      dateByAddingYears:0
	//      months:0 days:-30
	//      hours:0 minutes:0
	//      seconds:0];
	//
	
	//
	// create the predicate, assuming that the entity with which the predicate
	// will be evaluated has a "dateToCompare" attribute
	//
	NSPredicate *dateInLast30DaysPredicate = [NSPredicate
											  predicateWithFormat:@"dateToCompare > %@", date30DaysAgo];
	
	return dateInLast30DaysPredicate;
}


-(void)dealloc
{
    [allLocations release];
    [super dealloc];
    
}

@end
