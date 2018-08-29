//
//  CustomWebView.h
//  FlashCardDB
//
//  Created by Friends on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomWebView_iPhone : UIWebView <UIWebViewDelegate>
{
	UIActivityIndicatorView* act;
	NSString* searchText;
}

@property (nonatomic,retain) NSString* searchText;

///- (void)loadHTMLString:(NSString *)str;

- (void)loadClearBgHTMLString:(NSString *)str;
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;

@end
