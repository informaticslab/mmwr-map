//
//  MmwrArticle.m
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

#import "MmwrArticle.h"


@implementation MmwrArticle

@synthesize title, url, pubDate, isFiltered;

-(id)initWithTitle:(NSString *)newTitle 
               url:(NSString *)newUrl
           pubDate:(NSDate *)newPubDate    
           volume:(NSInteger)newVolume
             issue:(NSInteger)newIssue
              page:(NSInteger)newPage
{
    
	self.title = newTitle;
	self.url = newUrl;
    self.pubDate = newPubDate;
	volume = newVolume;
	issue = newIssue;
    page = newPage;
 	return self;
    
}

-(void)dealloc
{
    [title release];
    [url release];
    [pubDate release];
    [super dealloc];
}

@end
