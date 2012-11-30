//
//  ArticleModalViewController.m
//  mmwrMockup
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

#import "ArticleModalViewController.h"
#import "Debug.h"
#import "AppManager.h"
#import "LoadingView.h"
#import "TranslatePopover.h"


@implementation ArticleModalViewController

@synthesize delegate, webView, navbar, navTitle;
@synthesize popoverController, translateBtnItem, relatedNewsBtnItem;
@synthesize article, url;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithArticle:(MmwrArticle *)newArticle
{
	self = [super initWithNibName:@"ArticleModalView" bundle:nil];
	if (self)
	{
		self.article = newArticle;
		self.url = [NSURL URLWithString:self.article.url];
	}
	
	return self;
}



-(void)viewWillAppear:(BOOL)animated
{
	
	NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 10.0];
	self.navTitle.title = self.article.title;

	webView.delegate = self;
	[webView loadRequest:req];
		
}
- (void)viewDidLoad {
	
	
}

- (void)webViewDidStartLoad:(UIWebView *)webview {
	
	LoadingView *loadingView = [LoadingView loadingViewInView:self.webView];
	[loadingView performSelector:@selector(removeView) withObject:nil afterDelay:2.0];
	
	
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.navigationController.navigationItem.leftBarButtonItem = nil;
	//	[self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='105%'"];
	[self.webView stringByEvaluatingJavaScriptFromString:@"CDC.TextSizer.resize(3)"];
	
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
	DebugLog(@" answer is yes");
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	DebugLog(@"received didRotate.");	
}


- (IBAction)btnDoneClicked: (id)sender {
	
	NSLog(@"Modal View Done button hit");
	if ([self.popoverController isPopoverVisible] == YES ) 
		[popoverController dismissPopoverAnimated:YES];
	if (webView)
		[self.webView loadHTMLString:@"" baseURL:nil];
	[delegate didDismissModalView];
	
}

- (void)translate:(id)sender {  
	
    DebugLog(@"The translate button has been hit.");  
	
	if ([self.popoverController isPopoverVisible] == YES ) 
		[popoverController dismissPopoverAnimated:YES];
	else {
		
		TranslatePopover *translatePopover = [[TranslatePopover alloc] initWithNibName:@"TranslatePopover" bundle:nil ];
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:translatePopover];
		self.popoverController = popover;
		popoverController.delegate = self;
		
		[popover release];
		[translatePopover release];
		
		[popoverController presentPopoverFromBarButtonItem:self.translateBtnItem
								  permittedArrowDirections:UIPopoverArrowDirectionAny 
												  animated:YES];
		
	}
	
}  

- (void)getRelatedNews:(id)sender {  
	
    DebugLog(@"The related news button has been hit.");  
	
	if ([self.popoverController isPopoverVisible] == YES ) 
		[popoverController dismissPopoverAnimated:YES];
	else {
		
		TranslatePopover *translatePopover = [[TranslatePopover alloc] initWithNibName:@"TranslatePopover" bundle:nil ];
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:translatePopover];
		self.popoverController = popover;
		popoverController.delegate = self;
		
		[popover release];
		[translatePopover release];
		
		[popoverController presentPopoverFromBarButtonItem:self.relatedNewsBtnItem
								  permittedArrowDirections:UIPopoverArrowDirectionAny 
												  animated:YES];
		
	}
	
}  


- (void)dealloc {
    [super dealloc];
}


@end
