//
//  ArticlesPopoverViewController.m
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

#import "ArticlesPopoverViewController.h"
#import "ArticleModalViewController.h"
#import "MmwrLocation.h"
#import "Debug.h"
#import "AppManager.h"

@implementation ArticlesPopoverViewController

@synthesize location;

AppManager *appMgr;


#pragma mark -
#pragma mark Initialization


- (id)initWithLocation:(MmwrLocation *)currLocation {

	self = [super initWithNibName:@"LocationArticlesPopover" bundle:nil];
	if (self )
	{
		appMgr = [AppManager singletonAppManager];
		self.location = currLocation;
		DebugLog(@"current location = %@", location.placeName);
	}
	return self;
		
 }



#pragma mark -
#pragma mark View lifecycle


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	DebugLog(@"article count =  %d", [location countOfFilteredArticles]);

    return [location countOfFilteredArticles];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ArticlePopoverCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	else {
		DebugLog(@"reusing cell = %@.", cell);
	}

	DebugLog(@"getting cell for indexPath.row = %d", indexPath.row);
	MmwrArticle *article = [location filteredArticleAtIndex:indexPath.row];
	[cell.textLabel setText:article.title];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// set current article
    //[appManager.contentController setCurrentArticleWithIndex:indexPath.row];	
	MmwrArticle *article = [location filteredArticleAtIndex:indexPath.row];

	ArticleModalViewController *viewController = [[ArticleModalViewController alloc] initWithArticle:article];
	
	viewController.delegate = self;
	viewController.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentModalViewController:viewController animated:YES];
	
	// clean up resources
	[viewController release];	
}

#pragma mark Modal delegate
- (void)didDismissModalView {
    
    // Dismiss the modal view controller
    [self dismissModalViewControllerAnimated:YES];
	//[popoverController release];
    
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

