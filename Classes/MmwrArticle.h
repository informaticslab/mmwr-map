//
//  MmwrArticle.h
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


@interface MmwrArticle : NSObject {
    NSString *title;
    NSString *url;
    NSDate *pubDate;
    NSInteger volume;
    NSInteger issue;
    NSInteger page;
	BOOL isFiltered;
    
}

@property(retain, nonatomic) NSString *title;
@property(retain, nonatomic) NSString *url;
@property(retain, nonatomic) NSDate *pubDate;
@property BOOL isFiltered;


-(id)initWithTitle:(NSString *)newTitle 
               url:(NSString *)newUrl
           pubDate:(NSDate *)newPubDate    
            volume:(NSInteger)newVolume
             issue:(NSInteger)newIssue
              page:(NSInteger)newPage;

@end
