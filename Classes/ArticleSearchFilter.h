//
//  ArticleSearchFilter.h
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

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface ArticleSearchFilter : NSObject {
    NSDate *startDate;
    NSDate *endDate;
	BOOL filterOnDates;
	BOOL filterOnLocationName;
	BOOL filterOnSelectedLocationDistance;
	BOOL filterOnCurrentLocationDistance;
	NSString *selectedLocation;
	NSNumber *withinDistance;
}

@property(retain, nonatomic) NSDate *startDate;
@property(retain, nonatomic) NSDate *endDate;
@property BOOL filterOnDates;
@property BOOL filterOnLocationName;
@property BOOL filterOnSelectedLocationDistance;
@property BOOL filterOnCurrentLocationDistance;
@property(retain, nonatomic) NSString *selectedLocation;
@property(retain, nonatomic) NSNumber *withinDistance;


- (id)initWithDateFilter:(NSDate *)newStartDate
           endDate:(NSDate *)newEndDate;
- (void)removeDateFilter;
- (void)removeLocationNameFilter;
- (void)setDateFilter:(NSDate *)aStartDate endDate:(NSDate *)aEndDate;
- (void)setLocationNameFilter:(NSString *)location;
- (void)setSelectedLocationDistanceFilter:(NSNumber *)distance;
- (void)setCurrentLocationDistanceFilter:(NSNumber *)distance;
- (BOOL)isFilteringActive;
- (BOOL)isLocationDistanceFilteringActive;
- (BOOL)isLocationNameFilteringActive;
- (BOOL)isLocationFilteringActive;
-(BOOL)isDateFilteringActive;

@end
