//
//  MwwrLocation.h
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
#import "MmwrArticle.h"
#import "ArticleSearchFilter.h"
#import "AddressAnnotation.h"

@interface MmwrLocation : NSObject {
	NSString *placeName;
	NSString *placeType;
	CLLocationCoordinate2D location;
	NSMutableArray *articles;
	NSMutableArray *filteredArticles;
	AddressAnnotation *addressAnnotation;
	BOOL isFiltered;
}


@property(nonatomic, retain) AddressAnnotation *addressAnnotation;
@property(nonatomic, retain) NSString *placeName;
@property(nonatomic, retain) NSString *placeType;
@property(nonatomic, retain) NSMutableArray *articles;
@property(nonatomic, retain) NSMutableArray *filteredArticles;
@property BOOL isFiltered;
@property CLLocationCoordinate2D location;

-(id)initWithPlace:(NSString *)newPlace
       typeOfPlace:(NSString *)newPlaceType
          latitude:(NSNumber *)lat 
         longitude:(NSNumber *)lng;
-(void)addArticle:(MmwrArticle *)newArticle;
-(int)countOfArticles;
-(int)countOfFilteredArticles;
-(MmwrArticle *)articleAtIndex:(int)index;
-(MmwrArticle *)filteredArticleAtIndex:(int)index;
-(int)filterArticlesByDate:(ArticleSearchFilter *)articleFilter;
-(void)locationFiltered;


@end
