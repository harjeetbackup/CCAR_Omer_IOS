    //
//  DeckViewController.m
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeckCell.h"
#import "CardDetails.h"
#import "AppDelegate_iPad.h"
#import "AppDelegate_iPhone.h"
#import "FlashCard.h"
#import "ModalViewCtrl.h"
#import "DBAccess.h"
#import "DeckViewController.h"
#import "SearchViewController.h"
#import "IndexViewController.h"
#import "MyCommentsViewController.h"
#import "MyVoiceNotesViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Omer_Flash_Card-Swift.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#define degreesToRadians(x) (M_PI * x / 180.0)
#import "SearchViewController.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation CustomNavigationBar

- (void) drawRect:(CGRect) rect
{
	/*UIImage* img = [UIImage imageNamed:@"TopBar"];
	[img drawInRect:rect];*/
}

@end

@implementation DeckViewController
@synthesize cardDecks = _cardDecks,isTappedTodaysReading;

@synthesize _detail,_navLabel;
NSString * startDate;
NSString * endDate ;
int startDateDay;
int startDateMonth;
int startDateYear;
int endDateDay;
int endDateMonth;
int endDateYear;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidAppear:(BOOL)animated
{
	[_extraNavigationBar setNeedsDisplay];
	[super viewDidAppear:animated];
    if ([[AppDelegate_iPad delegate] launchedFromLoacalNotification]) {
        AppDelegate_iPhone.delegate.launchedFromLoacalNotification = false;
        [self findMyCurrentLocation];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    isTappedTodaysReading=NO;
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton=YES;
}

// This method will display the card details page for a particular index
- (void) showDetailViewWithArray:(NSMutableArray*) array cardIndex:(NSInteger) index caller:(NSString *)strCaller
{	
	_detail = [[CardDetails alloc] initWithNibName:@"CardDetailsiPad" bundle:nil] ;
	if ([strCaller isEqualToString:@"self"]) {
		_detail.basicCall = YES;
	}
	else {
		_detail.basicCall = NO;
	}

	[_detail setParentViewCtrl:self];
	_detail._selectedCardIndex=index;
	_detail.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
	[_detail loadArrayOfCards:array withParentViewC:self];
    
   /* _detail.view.tag = 1;
    if([self.view viewWithTag:1]!=nil)
    {
        [[self.view viewWithTag:1] removeFromSuperview];
    }*/
	[self.view addSubview:_detail.view];
}


- (void) showIndexViewForDeck:(FlashCardDeck *)objDeck
{
	_indexView = [[IndexViewController alloc] initWithNibName:@"IndexViewiPad" bundle:nil forDeck:objDeck];	
	[_indexView setParentViewCtrl:self];
     if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
     {
	   _indexView.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
         //CGRectMake(382, 0, kDetailViewWidth+40, 768);
     }
    else
    {
         _indexView.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
        //CGRectMake(382, 0, kDetailViewWidth, 768);
    }
   //_indexView.view.frame = CGRectMake(382, 44, 980, 700);
    _indexView.view.tag = 2;
    if([self.view viewWithTag:2]!=nil)
    {
        [[self.view viewWithTag:2] removeFromSuperview];
    }
	[self.view addSubview:_indexView.view];
    
}

- (void) showSearchViewForDeck:(NSMutableArray*) array cardIndex:(NSInteger) index search:(NSString *)text
{	
	_detail = [[CardDetails alloc] initWithNibName:@"CardDetailsiPad" bundle:nil];
	_detail.basicCall = NO;
	[_detail setParentViewCtrl:self];
	_detail._selectedCardIndex=index;
	_detail._searchText=text;
	_detail.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
    //CGRectMake(384, 0, kDetailViewWidth, 768);
	_detail.basicCall = NO;
	[_detail loadArrayOfCards:array withParentViewC:self];
    _detail.view.tag = 3;
    if([self.view viewWithTag:3]!=nil)
    {
        [[self.view viewWithTag:3] removeFromSuperview];
    }
	[self.view addSubview:_detail.view];
}


- (void)viewDidLoad 
{    [super viewDidLoad];
    _tableView.contentInset = UIEdgeInsetsMake(-1.0, 0.0, 57.0, 0.0);
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
 

	self.navigationController.navigationBarHidden = NO;
	self.navigationController.delegate = self;
  //self.title = @"Meggs";
	self.title = [Utils getValueForVar:kHeaderTitle];
	_navLabel.text = [Utils getValueForVar:kHeaderTitle];
    [_navLabel setHidden:YES];
    [_aLabel setHidden:YES];
	[self performSelector:@selector(openFirstView) withObject:self afterDelay:0.3];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getStartAndEndDates];
    });
}

- (void)getStartAndEndDates
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    [Server.shared getOmerDatesByYearWithId:yearString completion:^(NSArray * res, NSError * error) {
        if (res != NULL) {
            if (res.firstObject[@"date"] != NULL) {
                startDate = res.firstObject[@"date"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *now = [formatter dateFromString:startDate];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:now];
                startDateDay = [components day];
                startDateMonth = [components month];
                startDateYear = [components year];
            }
            if (res.lastObject[@"date"] != NULL) {
                endDate = res.lastObject[@"date"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *now = [formatter dateFromString:endDate];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:now];
                endDateDay = [components day];
                endDateMonth = [components month];
                endDateYear = [components year];
            }
        }
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setProperRotation:(BOOL)animated
{
	//UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.0];
	}
	
	if (orientation == UIDeviceOrientationPortraitUpsideDown) {
		self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(180));}
	
	else if (orientation == UIDeviceOrientationLandscapeLeft)
		self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(90));
	
	else if (orientation == UIDeviceOrientationLandscapeRight)
		self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(-90));
	
	else if(orientation==UIDeviceOrientationUnknown) {
		self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(-90));
	}
    
	if (animated)
		[UIView commitAnimations];
	
}

- (void) openFirstView
{
    ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kcontentTypeIntro];
    [model setParentCtrl:self];
     model.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
    //CGRectMake(382, 0, kDetailViewWidth+2, 768);
    model.view.tag = 1;
    if([self.view viewWithTag:1]!=nil)
    {
        [[self.view viewWithTag:1] removeFromSuperview];
    }
    [self.view addSubview:model.view];

	/*[AppDelegate_iPad delegate].isBookMarked = NO;
	NSMutableArray* deckArray = [_cardDecks.allCardDeck  getCardsList];
	
	[self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];*/
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}

- (void)dealloc
{
    [_aNavBar release];
    [_aImgView release];
    [_aTableView release];
    [_dailyBlessingToolBar release];
    [_dailyBlessingToolBar release];
    [_searchButton release];
    [_indexButton release];
    [_settingButton release];
    [_helpButton release];
    [_infoButton release];
    [_aImgView release];
    [_aTableView release];
    [_aLabel release];
    [_lblCopyright release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableView delegates

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if([[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"])
    {
        if(section == 1)
            return _cardDecks.flashCardDeckList.count;
        return 4;
    }
    else
    {
        if(section == 1)
            return _cardDecks.flashCardDeckList.count;
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section>0)
        return (tableView.frame.size.height - 292.0 )/ 7.0;
    else
       return 73;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{       
	DeckCell* cell = nil;
    UIView *bgColorView = [[[UIView alloc] init] autorelease];
    [bgColorView setBackgroundColor:[[Utils colorFromString:[Utils getValueForVar:kSelectedDeckColor]]colorWithAlphaComponent:0.2]];
    //[bgColorView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    bgColorView.alpha=.2f;
    UITableViewCell* introCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	if(indexPath.section==0)
	{
            switch (indexPath.row)
            {
            case 0:
                tableView.separatorColor = [UIColor whiteColor];
                //introCell.textLabel.text=@"Introduction";
                introCell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.introDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kIntroDeckColor]]];
                introCell.textLabel.textColor=[UIColor whiteColor];
                introCell.backgroundColor=[UIColor clearColor];
                introCell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bg_intro.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
                [introCell setSelectedBackgroundView:bgColorView];
                return introCell;
                break;
		case 1:
                cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.todayReadingDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
                cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bg_today-reading.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
          	break;
		case 2:
                tableView.separatorColor = [UIColor whiteColor];
                cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.allCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kAllCardsTextColor]]];
                cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bg_all-card.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
            //tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
			//tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
		
                break;
        case 3:
            tableView.separatorColor = [UIColor whiteColor];
            cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.bookMarkedCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bg_bookmark.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
                    
                    break;
    		}
    }
		else
        {
            //tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
			//tableView.separatorColor = [Utils colorFromString:@"180,180,180"];
			cell = [DeckCell creatCellViewWithFlashCardDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row] withTextColor:[Utils colorFromString:[Utils getValueForVar:kDeckCardsTextColor]]];

        }
    [cell setSelectedBackgroundView:bgColorView];
   // cell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.section == 2 && [[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"no"] && indexPath.row == 0))
		return;
		
	NSMutableArray* deckArray=nil;
    if([[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"])
    {
        if (indexPath.section==0)
        {
            switch (indexPath.row)
            {
            case 0:
                deckArray = nil;
                ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kcontentTypeIntro];
                [model setParentCtrl:self];
                model.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
                model.view.tag = 1;
                if([self.view viewWithTag:1]!=nil)
                {
                    [[self.view viewWithTag:1] removeFromSuperview];
                }
                [self.view addSubview:model.view];
                return;
                break;
                
            case 1:
                [AppDelegate_iPad delegate].isBookMarked = NO;
                    deckArray = [_cardDecks.allCardDeck  getCardsList];
                    Reachability* wifiReach = [Reachability reachabilityWithHostName: @"www.google.com"];
                    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
                    
                    if (!netStatus==NotReachable)
                    {
                        [self findMyCurrentLocation];
                    }
                    else
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"You are no longer Connected to Internet. Please check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        [alert show];
                        
                    }
                break;
                case 2:
                    [AppDelegate_iPad delegate].isBookMarked = NO;
                    deckArray = [_cardDecks.allCardDeck  getCardsList];
                    [self showIndexViewForDeck:_cardDecks.allCardDeck];
                    break;
            case 3:
                [AppDelegate_iPad delegate].isBookMarked = YES;
                deckArray = [_cardDecks.bookMarkedCardDeck  getCardsList];
                if (deckArray == nil || deckArray.count <= 0)
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There are no bookmarks or notes yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return;
                }
                    else
                        [self showIndexViewForDeck:_cardDecks.bookMarkedCardDeck];
                break;
            
            }
        }
            else
            {
                [AppDelegate_iPad delegate].isBookMarked = NO;
                deckArray = [[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row]  getCardsList];
                [self showIndexViewForDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row]];
            }
        
       /* if ([[[Utils getValueForVar:kCardList] lowercaseString] isEqualToString:@"yes"])
        {
            if(indexPath.section == 1)
            [self showIndexViewForDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row]];
            else
            {
            if(indexPath.row == 1)
                    [self showIndexViewForDeck:_cardDecks.todayReadingDeck];
            else if(indexPath.row == 2)
                [self showIndexViewForDeck:_cardDecks.allCardDeck];
            else if(indexPath.row == 3)
                [self showIndexViewForDeck:_cardDecks.bookMarkedCardDeck];
            
            }
        }
        
        else	// Take to the card details page
        {
            // Randomize the cards if the random property is set
            if([AppDelegate_iPad delegate].isRandomCard == 1)
            {
                [Utils randomizeArray:deckArray];
            }
            [self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];
        }*/
    }
}


- (IBAction)displaySettings
{
	ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeSetting];
	[model setParentCtrl:self];
	model.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
    model.view.tag = 4;
    if([self.view viewWithTag:4]!=nil)
    {
        [[self.view viewWithTag:4] removeFromSuperview];
    }
	[self.view addSubview:model.view];
}

- (IBAction)displayHelp
{
	ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeHelp];
	[model setParentCtrl:self];
	model.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
    model.view.tag = 5;
    if([self.view viewWithTag:5]!=nil)
    {
        [[self.view viewWithTag:5] removeFromSuperview];
    }
	[self.view addSubview:model.view];
	
}

- (IBAction)displayInfo
{
	ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeInfo];
	[model setParentCtrl:self];
	model.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
    //CGRectMake(382, 0, kDetailViewWidth+2, 768);
    model.view.tag = 6;
    if([self.view viewWithTag:6]!=nil)
    {
        [[self.view viewWithTag:6] removeFromSuperview];
    }
	[self.view addSubview:model.view];
	
}

- (IBAction)searchCards
{
	SearchViewController* searchView = [[SearchViewController alloc] initWithNibName:@"SearchViewiPad" bundle:nil];
	[searchView setParentViewCtrl:self];
	searchView.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
    //CGRectMake(382, 0, kDetailViewWidth, 768);
    searchView.view.tag = 7;
    if([self.view viewWithTag:7]!=nil)
    {
        [[self.view viewWithTag:7] removeFromSuperview];
    }
	[self.view addSubview:searchView.view];
}


- (IBAction)cardIndex
{
	IndexViewController* indexView = [[IndexViewController alloc] initWithNibName:@"IndexViewiPad" bundle:nil forDeck:nil];
	[indexView setParentViewCtrl:self];
	indexView.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
   // CGRectMake(382, 0, kDetailViewWidth, 768);
    indexView.view.tag = 8;
    if([self.view viewWithTag:8]!=nil)
    {
        [[self.view viewWithTag:8] removeFromSuperview];
    }
	[self.view addSubview:indexView.view];
	

}


- (void) myComments{
	
	MyCommentsViewController* commentsView = [[MyCommentsViewController alloc] initWithNibName:@"MyCommentsViewiPad" bundle:nil];
	commentsView.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
    //CGRectMake(382, 0, kDetailViewWidth, 768);
    commentsView.view.tag = 9;
    if([self.view viewWithTag:9]!=nil)
    {
        [[self.view viewWithTag:9] removeFromSuperview];
    }
	[self.view addSubview:commentsView.view];
	
}

- (void) myVoiceNotes{
	
	MyVoiceNotesViewController* notesView = [[MyVoiceNotesViewController alloc] initWithNibName:@"MyVoiceNotesViewiPad" bundle:nil];
	notesView.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
    //CGRectMake(382, 0, kDetailViewWidth, 768);
    notesView.view.tag = 10;
    if([self.view viewWithTag:10]!=nil)
    {
        [[self.view viewWithTag:10] removeFromSuperview];
    }
	[self.view addSubview:notesView.view];
	
}


/* Added By Ravindra */
-(IBAction) showActionSheet{
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
	
	
	[actionSheet addButtonWithTitle:@"Info"];
	
	if ([AppDelegate_iPad delegate].isVoiceNotesEnabled) {
		[actionSheet addButtonWithTitle:@"My Voice Notes"];
	}
	
	if ([AppDelegate_iPad delegate].isCommentsEnabled) {
		[actionSheet addButtonWithTitle:@"My Text Notes"];
	}
	
	
	if ([AppDelegate_iPad delegate].isFacebookEnabled) {
		[actionSheet addButtonWithTitle:@"Publish to Facebook"];
	}
	
	if ([AppDelegate_iPad delegate].isTwitterEnabled) {
		[actionSheet addButtonWithTitle:@"Publish to Twitter"];
	}
	
	[actionSheet addButtonWithTitle:@"Cancel"];
	
	[actionSheet showFromRect:CGRectMake(200, 700, 300, 100) inView:self.view animated:YES];
	[actionSheet release]; 	

	
	
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex==-1) return;
	
	NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
	if ([title isEqualToString:@"Info"]) {
		[self displayInfo];
	}

	else if ([title isEqualToString:@"Publish to Twitter"]) {
		[self publishToTwitter];
	}
	
	else if ([title isEqualToString:@"My Voice Notes"]) {
		[self myVoiceNotes];
	}
	
	else if ([title isEqualToString:@"My Text Notes"]) {
		[self myComments];
	}

}
-(void)findMyCurrentLocation
{
    locationmanager=[[CLLocationManager alloc]init];
    locationmanager.delegate=self;
    // check before requesting, otherwise it might crash in older version
    if ([locationmanager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [locationmanager requestWhenInUseAuthorization];
    }
    [locationmanager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(!isTappedTodaysReading) {
        NSLog(@"locations %@",locations);
    //CLLocation* location = [locations lastObject];
        [locationmanager stopUpdatingLocation];
        NSDateComponents *startDatecomps = [[NSDateComponents alloc] init];
        [startDatecomps setDay:startDateDay];
        [startDatecomps setMonth:startDateMonth];
        [startDatecomps setYear:startDateYear];
        NSDate *currentDateTime=[NSDate date];
        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        NSDate *dateInLocalTimezone = [currentDateTime dateByAddingTimeInterval:timeZoneSeconds];
        NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *startDate = [gregorian dateFromComponents:startDatecomps];
        EDSunriseSet *startDateSunInfo = [EDSunriseSet sunrisesetWithDate:startDate timezone:[NSTimeZone localTimeZone]
                                                    latitude:location.coordinate.latitude
                                                   longitude:location.coordinate.longitude];
        NSDate *startSunsetTime= startDateSunInfo.sunset;
        NSDateComponents *endDatecomps = [[NSDateComponents alloc] init];
        [endDatecomps setDay:endDateDay];
        [endDatecomps setMonth:endDateMonth];
        [endDatecomps setYear:endDateYear];
        NSDate *endDate = [gregorian dateFromComponents:endDatecomps];
        EDSunriseSet *endDateSunInfo = [EDSunriseSet sunrisesetWithDate:endDate timezone:[NSTimeZone localTimeZone]
                                                             latitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude];
        NSDate *endSunsetTime= endDateSunInfo.sunset;
        if ([dateInLocalTimezone compare:startSunsetTime] ==  NSOrderedAscending)
        {
            ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kcontentTypeBeforeCard];
            [model setParentCtrl:self];
            model.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
        //CGRectMake(382, 0, kDetailViewWidth+2, 768);
            model.view.tag = 1;
        if([self.view viewWithTag:1]!=nil)
            {
                [[self.view viewWithTag:1] removeFromSuperview];
            }
                [self.view addSubview:model.view];
        }
    
        else if ([endSunsetTime compare:dateInLocalTimezone] ==  NSOrderedAscending)
        {
            ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kcontentTypeAfterCard];
            [model setParentCtrl:self];
            model.view.frame = CGRectMake(_tableView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width, UIScreen.mainScreen.bounds.size.height);
       // CGRectMake(382, 0, kDetailViewWidth+2, 768);
            model.view.tag = 1;
        if([self.view viewWithTag:1]!=nil)
        {
            [[self.view viewWithTag:1] removeFromSuperview];
        }
            [self.view addSubview:model.view];
    }
    else
    {
        EDSunriseSet *sunInfo = [EDSunriseSet sunrisesetWithDate:dateInLocalTimezone timezone:[NSTimeZone localTimeZone]
                                                        latitude:location.coordinate.latitude
                                                       longitude:location.coordinate.longitude];
   
        NSDate *sunsetTime= sunInfo.sunset;
        NSDateComponents *difference = [gregorian components:NSCalendarUnitDay
                                                    fromDate:startSunsetTime toDate:sunsetTime options:0];
        NSInteger dayDifference=[difference day];
        if(dayDifference>48)
            dayDifference=48;
      //  if(dayDifference>39)
          //  dayDifference=dayDifference-1;
     // NSMutableArray*  deckArray = [[AppDelegate_iPhone getDBAccess] getCardForTodaysReading:dayDifference -1];
      //  NSMutableArray*  deckArray = [[AppDelegate_iPhone getDBAccess] getCardForTodaysReading:dayDifference+1];
       // [self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];
        if ([startSunsetTime compare:sunsetTime] ==  NSOrderedSame || dayDifference==0)
        {
            NSMutableArray*  deckArray = [[AppDelegate_iPhone getDBAccess] getCardForTodaysReading:dayDifference+1];
            [self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];
        }
        else if ([dateInLocalTimezone compare:sunsetTime] ==  NSOrderedAscending || dayDifference==48)
        {
            NSMutableArray*  deckArray = [[AppDelegate_iPhone getDBAccess] getCardForTodaysReading:dayDifference+1];
            [self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];
        }
        else
        {
             NSMutableArray*  deckArray = [[AppDelegate_iPhone getDBAccess] getCardForTodaysReading:dayDifference+1];
        
             [self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
       // longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
       // latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}
-(void) publishToFacebook{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:[Utils getValueForVar:kFacebookMessage]];
        
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }  
}

-(void) publishToTwitter{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[Utils getValueForVar:kTwitterMessage]];
        [self presentModalViewController:tweetSheet animated:YES];
    }
}

- (void)updateInfo
{
	[_cardDecks updateProficiency];
	[_tableView reloadData];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if (viewController == self)
		[self updateInfo];
}

- (void) clearView{
	[_detail.view removeFromSuperview];
}

- (void) setSelectedIndex:(NSInteger) index{
	_detail._selectedCardIndex=index;
}

- (void)viewDidUnload {
[self setANavBar:nil];
    [self setAImgView:nil];
    [self setATableView:nil];
    [self setDailyBlessingToolBar:nil];
    [self setDailyBlessingToolBar:nil];
    [self setSearchButton:nil];
    [self setIndexButton:nil];
    [self setSettingButton:nil];
    [self setHelpButton:nil];
    [self setInfoButton:nil];
    [self setAImgView:nil];
    [self setATableView:nil];
    [self setALabel:nil];
[super viewDidUnload];
}
@end
