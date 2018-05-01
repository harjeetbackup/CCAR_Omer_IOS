//
//  DeckViewController.h
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#include <CoreLocation/CLLocationManagerDelegate.h>
#include <CoreLocation/CLError.h>
#include <CoreLocation/CLLocation.h>
#include <CoreLocation/CLLocationManager.h>
#import "EDSunriseSet.h"
@class CardDetails;
@class FlashCardDeckList;
@class FlashCardDeck;
@class IndexViewController;

@interface CustomNavigationBar : UINavigationBar
{
}


@end


@interface DeckViewController : UIViewController <UITableViewDelegate, 
												UITableViewDataSource, 
												UINavigationControllerDelegate,
												UIActionSheetDelegate,CLLocationManagerDelegate>
{
    CLLocationManager* locationmanager;
    
    CLLocation* location;
	IBOutlet UITableView*			_tableView;
	IBOutlet UINavigationItem*		_extraNavigationItem;
	IBOutlet CustomNavigationBar*	_extraNavigationBar;
	IBOutlet UILabel *_navLabel;

	CardDetails*			_detail;
	IndexViewController*	_indexView;
	FlashCardDeckList*		_cardDecks;

}

@property (nonatomic, retain) FlashCardDeckList* cardDecks;
@property (nonatomic, retain) CardDetails*	_detail;
@property (nonatomic, retain) UILabel *_navLabel;
@property (nonatomic, assign) BOOL    isTappedTodaysReading;

@property (retain, nonatomic) IBOutlet UINavigationBar *aNavBar;
@property (retain, nonatomic) IBOutlet CustomDeckToolBar *dailyBlessingToolBar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *indexButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *settingButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *helpButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (retain, nonatomic) IBOutlet UIImageView *aImgView;
@property (retain, nonatomic) IBOutlet UITableView *aTableView;
@property (retain, nonatomic) IBOutlet UILabel *aLabel;
@property (retain, nonatomic) IBOutlet UILabel *lblCopyright;
@property (nonatomic,strong) EDSunriseSet *sunriset;

- (IBAction)displaySettings;
- (IBAction)displayHelp;
- (IBAction)displayInfo;
- (IBAction)showActionSheet;
- (IBAction)searchCards;
- (IBAction)cardIndex;

- (void) showDetailViewWithArray:(NSMutableArray*) array cardIndex:(NSInteger) index caller:(NSString *)strCaller;
- (void) showIndexViewForDeck:(FlashCardDeck *)objDeck;
- (void) showSearchViewForDeck:(NSMutableArray*)array cardIndex:(NSInteger) index search:(NSString *)text;

- (void)updateInfo;
- (void) publishToFacebook;
- (void) publishToTwitter;
- (void) myComments;
- (void) myVoiceNotes;
- (void) openFirstView;
- (void) clearView;
- (void) setSelectedIndex:(NSInteger) index;

@end
