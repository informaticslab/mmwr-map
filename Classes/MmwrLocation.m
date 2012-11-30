//
//  MwwrLocation.m
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

#import "MmwrLocation.h"
#import <MapKit/MapKit.h>
#import "ArticleSearchFilter.h"

@implementation MmwrLocation

@synthesize addressAnnotation, placeName, placeType, articles, filteredArticles;
@synthesize isFiltered, location;

-(id)initWithPlace:(NSString *)newPlace 
	 typeOfPlace:(NSString *)newPlaceType
		latitude:(NSNumber *)lat
		longitude:(NSNumber *)lng
{

	self.placeName = newPlace;
	self.placeType = newPlaceType;
	location.latitude = [lat doubleValue];
	location.longitude = [lng doubleValue];
    self.addressAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location name:placeName addressType:placeType];
	self.articles = [[NSMutableArray alloc] init];
	self.filteredArticles = [[NSMutableArray alloc] init];
	self.isFiltered = NO;
		
	return self;
}

#pragma mark -
#pragma mark Article related methods
-(void)addArticle:(MmwrArticle *)newArticle
{
    [articles addObject:newArticle];
    [filteredArticles addObject:newArticle];
}

-(int)countOfArticles
{
    NSUInteger count = [articles count];
    return count;
}

-(int)countOfFilteredArticles
{
    return [filteredArticles count];
}

-(MmwrArticle *)articleAtIndex:(int)index
{
 
    return [articles objectAtIndex:index];
    
}

-(MmwrArticle *)filteredArticleAtIndex:(int)index
{

    return [filteredArticles objectAtIndex:index];
    
}

-(void)locationFiltered
{
	
    [filteredArticles removeAllObjects];
	self.isFiltered = YES;

}

-(int)filterArticlesByDate:(ArticleSearchFilter *)articleFilter
{
    [filteredArticles removeAllObjects];
    
    for (MmwrArticle *article in articles) 
    {
        // if the article's published date is after the filter's start date and
        // before the filter's end date then add the article to the filtered 
        // articles array
        if (article.pubDate == [article.pubDate laterDate:articleFilter.startDate]  ) 
            if (article.pubDate == [article.pubDate earlierDate:articleFilter.endDate]  )  
                [filteredArticles addObject:article];
    }
	
	if ([filteredArticles count] == 0)
		self.isFiltered = YES;
	else
		self.isFiltered = NO;
	
    // return the count of filtered articles
    return [filteredArticles count];

}

-(void)removeFilter
{
	[filteredArticles removeAllObjects];
	[filteredArticles addObjectsFromArray:articles];
	
}

-(void)dealloc
{
    [addressAnnotation release];
    [placeName release];
    [placeType release];
    [articles release];
    [filteredArticles release];
    [super dealloc];
    
}



@end
