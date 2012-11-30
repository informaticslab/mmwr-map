//
//  ArticleSearchFilter.m
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

#import "ArticleSearchFilter.h"

@implementation ArticleSearchFilter

@synthesize startDate, endDate, filterOnDates;
@synthesize selectedLocation, filterOnLocationName;
@synthesize withinDistance, filterOnCurrentLocationDistance;
@synthesize filterOnSelectedLocationDistance;

-(id)init
{
	if ((self = [super init]))
	{
		[self removeDateFilter];
		[self removeLocationNameFilter];
		filterOnCurrentLocationDistance = NO;
		filterOnSelectedLocationDistance = NO;
		filterOnDates = NO;
		filterOnLocationName = NO;
		withinDistance = [[NSNumber alloc] initWithInteger:1000];
	}
	
	return self;
	
}

-(id)initWithDateFilter:(NSDate *)newStartDate
           endDate:(NSDate *)newEndDate
{
    [self init];
    endDate = newEndDate;
    startDate = newStartDate;
	filterOnDates = YES;
	return self;
}

-(void)removeDateFilter
{
	self.filterOnDates = NO;
	self.startDate = nil;
	self.endDate = nil;
}

-(void)setDateFilter:(NSDate *)aStartDate endDate:(NSDate *)aEndDate
{
	self.startDate = aStartDate;
	self.endDate = aEndDate;
	self.filterOnDates = YES;
}

-(BOOL)isDateFilteringActive
{
	if (self.filterOnDates == NO)
		return NO;
	else 
		return YES;
}



-(void)removeLocationNameFilter
{
	self.filterOnLocationName = NO;
	self.selectedLocation = nil;
}

-(void)setLocationNameFilter:(NSString *)location
{
	self.selectedLocation = location;
	self.filterOnLocationName = YES;
}

-(void)setCurrentLocationDistanceFilter:(NSNumber *)distance
{

	self.filterOnCurrentLocationDistance = YES;
	self.filterOnSelectedLocationDistance = NO;
	self.withinDistance = distance;
	
}

-(void)removeCurrentLocationDistanceFilter
{
	
	self.filterOnCurrentLocationDistance = NO;
	self.filterOnSelectedLocationDistance = NO;

}

-(void)setSelectedLocationDistanceFilter:(NSNumber *)distance
{
	self.filterOnSelectedLocationDistance = YES;
	self.filterOnCurrentLocationDistance = NO;
	self.withinDistance = distance;
	
}

-(void)removeSelectedLocationDistanceFilter
{
	
	self.filterOnCurrentLocationDistance = NO;
	self.filterOnSelectedLocationDistance = NO;

}

-(void)removeDistanceFilter
{
	self.filterOnSelectedLocationDistance = NO;
	self.filterOnCurrentLocationDistance = NO;
}


-(BOOL)isFilteringActive
{
	if (self.filterOnDates == YES)
		return YES;
	if (self.filterOnLocationName == YES)
		return YES;
	if (self.filterOnSelectedLocationDistance == YES)
		return YES;
	if (self.filterOnCurrentLocationDistance == YES)
		return YES;
	
	return NO;	
}

-(BOOL)isLocationDistanceFilteringActive
{
	if (self.filterOnCurrentLocationDistance == NO && self.filterOnSelectedLocationDistance == NO )
		return NO;
	else {
		return YES;
	}
}

-(BOOL)isLocationNameFilteringActive
{
	if (self.filterOnLocationName == NO)
		return NO;
	else 
		return YES;

}

-(BOOL)isLocationFilteringActive
{
	if (([self isLocationNameFilteringActive] == NO) && ([self isLocationDistanceFilteringActive] == NO))
		return NO;
	else {
		return YES;
	}
}

@end
