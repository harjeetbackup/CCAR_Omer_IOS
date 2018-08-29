//
//  ModalViewCtrl.h
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeckViewController;

@interface ModalViewCtrl : UIViewController 
{
	IBOutlet UIWebView*			_webView;
	IBOutlet UITableView*		_tableView;
	IBOutlet UINavigationItem*	_navItem;
	
	ContentType					_contentType;
	DeckViewController*			_parentCtrl;
	NSMutableArray*				_settingButtons;
	Boolean						_isRandomOption;
}

@property (retain, nonatomic) IBOutlet UIButton *settingButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentType:(ContentType) type;
- (IBAction) done:(id) sender;
- (void) setParentCtrl: (DeckViewController*) ctrl;
- (void)switchRandomChange:(id) sender;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@end
