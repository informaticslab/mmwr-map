//
//  ArticleModalViewController.h
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

#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"
#import "MmwrArticle.h"


@interface ArticleModalViewController : UIViewController <UIWebViewDelegate, UIPopoverControllerDelegate> {
	id<ModalViewDelegate> delegate;
    IBOutlet UIWebView *webView;
    IBOutlet UINavigationBar *navbar;
	IBOutlet UINavigationItem *navTitle;
	UIPopoverController *popoverController;
	MmwrArticle *article;
	NSURL *url;

}

@property (nonatomic, assign) id<ModalViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIWebView *webView;
@property (nonatomic, assign) IBOutlet UINavigationBar *navbar;
@property (nonatomic, retain) IBOutlet UINavigationItem *navTitle;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *translateBtnItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *relatedNewsBtnItem;
@property (nonatomic, retain) MmwrArticle *article;
@property (nonatomic, retain) NSURL *url;

-(id)initWithArticle:(MmwrArticle *)article;

- (IBAction) btnDoneClicked: (id)sender;
- (void)translate:(id)sender;  
- (void)getRelatedNews:(id)sender;  

@end
