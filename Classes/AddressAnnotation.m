//
//  AddressAnnotation.m
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

#import "AddressAnnotation.h"


@implementation AddressAnnotation


@synthesize coordinate, title, subtitle, addrType;


-(id)initWithCoordinate:(CLLocationCoordinate2D)c name:(NSString *)placeName addressType:(NSString *)placeType
{
	coordinate=c;
	[self setTitle:placeName];
	
	if ([placeType isEqualToString:@"Country"])
		self.addrType = COUNTRY;
	else if ([placeType isEqualToString:@"State"])
		self.addrType = STATE;
	else if ([placeType isEqualToString:@"Town"])
		self.addrType = TOWN;

	NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}

-(void) dealloc
{
    [title release];
    [subtitle release];
    [super dealloc];
    
}
@end
