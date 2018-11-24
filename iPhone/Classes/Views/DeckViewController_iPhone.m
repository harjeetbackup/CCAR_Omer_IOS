
//
//  DeckViewController.m
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeckCell_iPhone.h"
#import "CardDetails_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "DBAccess.h"
#import "FlashCard.h"
#import "CardList_iPhone.h"
#import "ModalViewCtrl_iPhone.h"
#import "DeckViewController_iPhone.h"
#import "SearchViewController_iPhone.h"
#import "IndexViewController_iPhone.h"
#import "MyCommentsViewController_iPhone.h"
#import "MyVoiceNotesViewController_iPhone.h"
#import "UIFont+Font.h"
#import "Utils.h"
#import "Reachability.h"
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import <Crashlytics/Crashlytics.h>
#import "Omer_Flash_Card-Swift.h"


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//static NSString *facebookAppId=@"153061968092263";
//static NSString *facebookAppSecretKey=@"5c0f38edb94a13f9592f2df6f46ca202";
// this app id is for spearhead flash cards
//static NSString *facebookAppId=@"136422206434654";
//static NSString *facebookAppSecretKey=@"d9b94a7b6157859be29f2556d00fadde";


@implementation DeckViewController_iPhone
@synthesize cardDecks = _cardDecks,isTappedTodaysReading;
bool navBar=YES;

NSArray *allDates;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height >= 812.0f) {
            NSLog(@"iPhone X");
            _BlessingToolBarHEight.constant = 60.0;
        }else {
            _BlessingToolBarHEight.constant = 44.0;
        }
    }
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    //[_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.contentInset = UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0);
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        //code here
        self.navigationController.navigationBarHidden = NO;
        UIImage *image = [UIImage imageNamed:@"background.png"];
        [self.dailyBlessingImgView setImage:image];
        self.dailyBlessingToolBar.tintColor = [UIColor blackColor];
        self.searchButton.tintColor = [UIColor whiteColor];
        self.indexButton.tintColor = [UIColor whiteColor];
        self.settingButton.tintColor = [UIColor whiteColor];
        self.helpButton.tintColor = [UIColor whiteColor];
        self.infoButton.tintColor = [UIColor whiteColor];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.view.backgroundColor = [UIColor clearColor];
        /* CGRect copyRight = self.coprrightLabel.frame;
         copyRight.origin.y = 505;
         self.coprrightLabel.frame = copyRight;*/
        
        // self.coprrightLabel.backgroundColor = [UIColor redColor];
        // UIImage *image = [UIImage imageNamed:@"Launching_iphone568@2x.png"];
        //[self.dailyBlessingImgView setImage:image];
        
        CGRect myFrameImg = self.dailyBlessingImg.frame;
        // myFrame.origin.x = 634;
        myFrameImg.origin.y = -2;
        self.dailyBlessingImg.frame = myFrameImg;
        
        CGRect myFrameTable = self.blessingTable.frame;
        myFrameTable.origin.y = 71;
        //self.blessingTable.frame = myFrameTable;
        //self.dailyBlessingsTable.backgroundColor = [UIColor whiteColor];
        
        CGRect myFrameTableHeight = self.blessingTable.frame;
        myFrameTableHeight.size.height = 395;
        //  self.blessingTable.frame = myFrameTableHeight;
    }
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.delegate = self;
    //self.title = @"Antibiotic Manual";
    //self.title = [Utils getValueForVar:kHeaderTitle];
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 250, 40)];
    tlabel.text=[Utils getValueForVar:kHeaderTitle];
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
    tlabel.font = [UIFont boldSystemFontOfSize:18];
    [tlabel setTextAlignment: UITextAlignmentCenter];
    [self getStartAndEndDates];
}



- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)getStartAndEndDates
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    [Server.shared getOmerDatesByYearWithId:yearString completion:^(NSArray * res, NSError * error) {
        if (res != NULL) {
            if (res.firstObject[@"date"] != NULL) {
                self.startDate = res.firstObject[@"date"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *now = [formatter dateFromString:self.startDate];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:now];
                self.startDateDay = [components day];
                self.startDateMonth = [components month];
                self.startDateYear = [components year];
            }
            if (res.lastObject[@"date"] != NULL) {
                self.endDate = res.lastObject[@"date"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *now = [formatter dateFromString:self.endDate];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:now];
                self.endDateDay = [components day];
                self.endDateMonth = [components month];
                self.endDateYear = [components year];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    navBar=YES;
    isTappedTodaysReading=NO;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [super viewWillAppear:animated];
        self.navigationItem.hidesBackButton=YES;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        [super viewWillAppear:animated];
    }
    if ([[AppDelegate_iPhone delegate] launchedFromLoacalNotification]) {
        AppDelegate_iPhone.delegate.launchedFromLoacalNotification = false;
        [self findMyCurrentLocation];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if(navBar)
            [self.navigationController setNavigationBarHidden:NO animated:animated];
        [super viewWillDisappear:animated];
    }

}

- (void)dealloc
{
    [_dailyBlessingImgView release];
    [_dailyBlessingToolBar release];
    [_searchButton release];
    [_indexButton release];
    [_settingButton release];
    [_helpButton release];
    [_infoButton release];
    [_coprrightLabel release];
    [_blessingTable release];
    [_dailyBlessingImg release];
    [_myLabelSeven release];
    [_dailyBlessingToolBar release];
    [_BlessingToolBarHEight release];
    [self.startDate release];
    [self.endDate release];
   
    
    [super dealloc];
}

#pragma mark -
#pragma mark UITableView delegates

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
        return _cardDecks.flashCardDeckList.count;
    return 4;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section>0)
        return 64;
    else
        return 56;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeckCell_iPhone* cell = nil;
    UIView *bgColorView = [[[UIView alloc] init] autorelease];
    [bgColorView setBackgroundColor:[[Utils colorFromString:[Utils getValueForVar:kSelectedDeckColor]]colorWithAlphaComponent:0.2]];
//  [bgColorView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    bgColorView.alpha=.2f;
    UITableViewCell* introCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    if(indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
                tableView.separatorColor = [UIColor whiteColor];
                //introCell.textLabel.text=@"Introduction";
                introCell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.introDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kIntroDeckColor]]];
                introCell.textLabel.textColor=[UIColor whiteColor];
                introCell.backgroundColor=[UIColor clearColor];
                introCell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bg_intro.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
                [introCell setSelectedBackgroundView:bgColorView];
                return introCell;
                break;
            case 1:
            {
                
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.todayReadingDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
                cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bg_today-reading.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
                break;
            }
            case 2:
                tableView.separatorColor = [UIColor whiteColor];
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.allCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kAllCardsTextColor]]];
                cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bg_all-card.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
                break;
                
            case 3:
                tableView.separatorColor = [UIColor whiteColor];
                cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:_cardDecks.bookMarkedCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
                cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bg_bookmark.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
                
                break;                
        }
    }
    else
    {     
        //tableView.separatorStyle=UITableViewCellSeparatorStyleNone;= 0;
        //tableView.separatorColor = [Utils colorFromString:@"180,180,180"];
        cell = [DeckCell_iPhone creatCellViewWithFlashCardDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row] withTextColor:[Utils colorFromString:[Utils getValueForVar:kDeckCardsTextColor]]];
        
    }
    
    
    [cell setSelectedBackgroundView:bgColorView];
    // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 && [[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"no"] && indexPath.row == 0)
        return;
    
    NSMutableArray* deckArray=nil;
    ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kcontentTypeIntro];
    if(indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
                navBar = NO;
                deckArray = nil;
                [model setParentCtrl:self];
                [self.navigationController pushViewController:model animated:YES];
                //[self presentModalViewController:model animated:YES];
                [model release];
                return;
                break;
                
            case 1:
            {
                [AppDelegate_iPhone delegate].isBookMarked = NO;
                deckArray = [_cardDecks.todayReadingDeck  getCardsList];
                Reachability* wifiReach = [Reachability reachabilityWithHostName: @"www.google.com"];
                NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
                
                if (!netStatus == NotReachable)
                {
                    [self findMyCurrentLocation];
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"You are no longer Connected to Internet. Please check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                    
                }
                break;
            }
                
            case 2:
                [AppDelegate_iPhone delegate].isBookMarked = NO;
                deckArray = [_cardDecks.allCardDeck  getCardsList];
                
                break;
                
            case 3:
                [AppDelegate_iPhone delegate].isBookMarked = YES;
                deckArray = [_cardDecks.bookMarkedCardDeck  getCardsList];
                if (deckArray == nil || deckArray.count <= 0)
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There are no bookmarks or notes yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return;
                }
                break;
  
        }
    }
    else
    {
        [AppDelegate_iPhone delegate].isBookMarked = NO;
        deckArray = [[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row]  getCardsList];
    }
    
    if([[[Utils getValueForVar:kCardList] lowercaseString] isEqualToString:@"yes"])
    {
        CardListIPhone* cardListView = [[CardListIPhone alloc] initWithNibName:@"CardList_iPhone" bundle:nil];
        
        if(indexPath.section == 1)
        {
            [self.navigationController pushViewController:cardListView animated:YES];
            [cardListView showCardsForDeck:indexPath.row+1];
        }
        else
        {
            if(indexPath.row == 2)
            {
                [self.navigationController pushViewController:cardListView animated:YES];
                [cardListView showAllCards];
            }
            else if(indexPath.row == 3)
            {
                [self.navigationController pushViewController:cardListView animated:YES];
                [cardListView showBookmarkCards];
            }
        }
        [cardListView release];
    }
    else
    {
        CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
        detail.arrCards=deckArray;
        [self.navigationController pushViewController:detail animated:YES];
        if([AppDelegate_iPhone delegate].isRandomCard == 1)
        {
            [Utils randomizeArray:deckArray];
        }
        
        //[detail loadArrayOfCards:deckArray];
        [detail release];
    }
    //  cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];    
}

- (void)getTodaysReading
{
     [self findMyCurrentLocation];
}

-(void)findMyCurrentLocation
{
    locationmanager=[[CLLocationManager alloc]init];
    locationmanager.delegate=self;
//  check before requesting, otherwise it might crash in older version
    if ([locationmanager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationmanager requestWhenInUseAuthorization];
    }
    [locationmanager stopUpdatingLocation];
    [locationmanager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(!isTappedTodaysReading)
    {
        isTappedTodaysReading=YES;
        NSLog(@"locations %@",locations);
        //CLLocation* location = [locations lastObject];
        [locationmanager stopUpdatingLocation];
        NSDateComponents *startDatecomps = [[NSDateComponents alloc] init];
        [startDatecomps setDay: self.startDateDay];
        [startDatecomps setMonth:self.startDateMonth];
        [startDatecomps setYear:self.startDateYear];
        
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
        [endDatecomps setDay:self.endDateDay];
        [endDatecomps setMonth:self.endDateMonth];
        [endDatecomps setYear:self.endDateYear];
        NSDate *endDate = [gregorian dateFromComponents:endDatecomps];
        EDSunriseSet *endDateSunInfo = [EDSunriseSet sunrisesetWithDate:endDate timezone:[NSTimeZone localTimeZone]
                                                               latitude:location.coordinate.latitude
                                                              longitude:location.coordinate.longitude];
        NSDate *endSunsetTime= endDateSunInfo.sunset;
        if ([dateInLocalTimezone compare:startSunsetTime] ==  NSOrderedAscending)
        {
            ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kcontentTypeBeforeCard];
            navBar=NO;
            [model setParentCtrl:self];
            [self.navigationController pushViewController:model animated:YES];
            [model release];
        }
        
        else if ([endSunsetTime compare:dateInLocalTimezone] ==  NSOrderedAscending)
        {
            ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kcontentTypeAfterCard];
            navBar = NO;
            [model setParentCtrl:self];
            [self.navigationController pushViewController:model animated:YES];
            [model release];
        }
        else
        {
            EDSunriseSet *sunInfo = [EDSunriseSet sunrisesetWithDate:[NSDate date] timezone:[NSTimeZone localTimeZone]
                                                            latitude:location.coordinate.latitude
                                                           longitude:location.coordinate.longitude];
            
            NSDate *sunsetTime= sunInfo.sunset;
            NSDateComponents *difference = [gregorian components:NSCalendarUnitDay
                                                        fromDate:startSunsetTime toDate:sunsetTime options:0];
            NSInteger dayDifference=[difference day];
            if(dayDifference>48)
                dayDifference=48;
    
            if ([startSunsetTime compare:sunsetTime] ==  NSOrderedSame && dayDifference==0)
            {
                NSMutableArray*  deckArray = [[AppDelegate_iPhone getDBAccess] getCardForTodaysReading:dayDifference+1];
                CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
                detail.arrCards=deckArray;
                detail._selectedCardIndex=0;
                detail.basicCall=YES;
                [self.navigationController pushViewController:detail animated:YES];
            }
            else if ([dateInLocalTimezone compare:sunsetTime] ==  NSOrderedAscending || dayDifference==48)
            {
                NSMutableArray*  deckArray = [[AppDelegate_iPhone getDBAccess] getCardForTodaysReading:dayDifference+1];
                CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
                detail.arrCards=deckArray;
                detail._selectedCardIndex=0;
                detail.basicCall=YES;
                [self.navigationController pushViewController:detail animated:YES];
            }
            else
            {
                NSMutableArray*  deckArray = [[AppDelegate_iPhone getDBAccess] getCardForTodaysReading:dayDifference+2];
                CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
                detail.arrCards=deckArray;
                detail._selectedCardIndex=0;
                detail.basicCall=YES;
                [self.navigationController pushViewController:detail animated:YES];
            }
        }
    }
}

-(void) getYearString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearStr = [formatter stringFromDate:[NSDate date]];
}
-(void) getMonthString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *monthStr = [formatter stringFromDate:[NSDate date]];
}

- (void) getDayString:( NSString *) value
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *dayStr = [formatter stringFromDate:[NSDate date]];
};


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        // longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        // latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}

- (IBAction)displaySettings
{
    navBar=NO;
    ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kContentTypeSetting];
    [model setParentCtrl:self];
    [self.navigationController pushViewController:model animated:YES];
    //[self presentModalViewController:model animated:YES];
    [model release];
}

- (IBAction)displayHelp
{
    navBar=NO;
    ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kContentTypeHelp];
    [model setParentCtrl:self];
    [self.navigationController pushViewController:model animated:YES];
    //[self presentModalViewController:model animated:YES];
    [model release];
}

- (IBAction)displayInfo
{
    navBar=NO;
    ModalViewCtrl_iPhone* model = [[ModalViewCtrl_iPhone alloc] initWithNibName:@"ModalView_iPhone" bundle:nil contentType:kContentTypeInfo];
    [model setParentCtrl:self];
    [self.navigationController pushViewController:model animated:YES];
    //[self presentModalViewController:model animated:YES];
    [model release];
}


- (IBAction)searchCards
{
    SearchViewController_iPhone* searchView = [[SearchViewController_iPhone alloc] initWithNibName:@"SearchView_iPhone" bundle:nil];
    [self.navigationController pushViewController:searchView animated:YES];
    [searchView release];
}

- (IBAction)cardIndex
{
    IndexViewController_iPhone* indexView = [[IndexViewController_iPhone alloc] initWithNibName:@"IndexView_iPhone" bundle:nil];
    [self.navigationController pushViewController:indexView animated:YES];
    [indexView release];
}

- (void) myComments{    
    MyCommentsViewController_iPhone* commentsView = [[MyCommentsViewController_iPhone alloc] initWithNibName:@"MyCommentsView_iPhone" bundle:nil];
    [self.navigationController pushViewController:commentsView animated:YES];
    [commentsView release];
    
}

- (void) myVoiceNotes{
    
    MyVoiceNotesViewController_iPhone* notesView = [[MyVoiceNotesViewController_iPhone alloc] initWithNibName:@"MyVoiceNotesView_iPhone" bundle:nil];
    [self.navigationController pushViewController:notesView animated:YES];
    [notesView release];
}


/* Added By Ravindra */

-(IBAction) showActionSheet{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    
    [actionSheet addButtonWithTitle:@"Info"];
    
    if ([AppDelegate_iPhone delegate].isVoiceNotesEnabled) {
        [actionSheet addButtonWithTitle:@"My Voice Notes"];
    }
    
    if ([AppDelegate_iPhone delegate].isCommentsEnabled) {
        [actionSheet addButtonWithTitle:@"My Text Notes"];
    }
    
    if ([AppDelegate_iPhone delegate].isFacebookEnabled) {
        [actionSheet addButtonWithTitle:@"Publish to Facebook"];
    }
    
    if ([AppDelegate_iPhone delegate].isTwitterEnabled) {
        [actionSheet addButtonWithTitle:@"Publish to Twitter"];
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Info"]) {
        [self displayInfo];
    }
    
    else if ([title isEqualToString:@"Publish to Facebook"]) {
        [self publishToFacebook];
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
    
    //[title release];
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

/* End of Updated Code By Ravindra */

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

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (void)viewDidUnload {
    [self setDailyBlessingTable:nil];
    [self setDailyBlessingImgView:nil];
    [self setDailyBlessingToolBar:nil];
    [self setSearchButton:nil];
    [self setIndexButton:nil];
    [self setSettingButton:nil];
    [self setHelpButton:nil];
    [self setInfoButton:nil];
    [self setCoprrightLabel:nil];
    [self setBlessingTable:nil];
    [self setDailyBlessingImg:nil];
    [self setMyLabelSeven:nil];
    [super viewDidUnload];
}
@end


