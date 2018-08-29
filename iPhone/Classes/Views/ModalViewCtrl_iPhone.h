//
//  ModalViewCtrl.h
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeckViewController_iPhone;

@interface ModalViewCtrl_iPhone : UIViewController 
{
	IBOutlet UIWebView*			_webView;
	IBOutlet UITableView*		_tableView;
	IBOutlet UINavigationItem*	_navItem;
	ContentType					_contentType;
	DeckViewController_iPhone*	_parentCtrl;
	NSMutableArray*				_settingButtons;
	Boolean						_isRandomOption;
}
@property (retain, nonatomic) IBOutlet UINavigationBar *myNavBar;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *myBackButton;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentType:(ContentType) type;

- (IBAction) done:(id) sender;
- (void) setParentCtrl: (DeckViewController_iPhone*) ctrl;
- (void)switchRandomChange:(id)sender;
@end
