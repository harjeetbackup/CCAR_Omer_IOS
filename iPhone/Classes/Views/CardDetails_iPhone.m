//
//  CardDetails.m
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBAccess.h"
#import "FlashCard.h"
#import "CustomWebView_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "VideoGallaryViewController_iPhone.h"
#import "VoiceNotesViewController_iPhone.h"
#import "CommentsViewController_iPhone.h"
#import "SearchViewController_iPhone.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIFont+Font.h"
#import "CardDetails_iPhone.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation CardDetails_iPhone
UIButton *buttonPrevious;
UIButton *buttonNext;
@synthesize _selectedCardIndex;
@synthesize _searchText;
@synthesize mWindow;
@synthesize arrCards;
@synthesize basicCall;
NSInteger todayOmerIndex_iPhone=0;

- (void)viewDidLoad {
    buttonPrevious = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPrevious.tintColor = [UIColor blackColor];
    [buttonPrevious addTarget:self
                       action:@selector(loadPrevCardDetails:)
             forControlEvents:UIControlEventTouchUpInside];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [buttonPrevious setImage:[UIImage imageNamed:@"prev_btn.png"] forState:UIControlStateNormal];
    } else {
        [buttonPrevious setImage:[UIImage imageNamed:@"left_arw.png"] forState:UIControlStateNormal];
    }
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    buttonPrevious.frame = CGRectMake(40.0, 7.0, 30.0, 30.0);
    buttonPrevious.contentMode=UIViewContentModeScaleAspectFit;
    buttonPrevious.hidden = NO;
    
    [self.customToolBarBottom addSubview: buttonPrevious];
    buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonNext.tintColor = [UIColor blackColor];
    [buttonNext addTarget:self
                   action:@selector(loadNextCardDetails:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [buttonNext setImage:[UIImage imageNamed:@"right_arw.png"] forState:UIControlStateNormal];
    
    buttonNext.frame = CGRectMake(self.view.bounds.size.width - 40, 7.0, 30.0, 30.0);
    buttonNext.contentMode=UIViewContentModeScaleAspectFit;
    buttonNext.hidden = NO;
    
    [self.customToolBarBottom addSubview: buttonNext];
    UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 20)];
    [leftButtonImg setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
    
    [leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    
    self.navigationItem.leftBarButtonItem=leftButton;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    }
    
    [_prevButton setNeedsDisplay];
    _act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _act.center = self.view.center;
    UIView* topRightBarView = [[UIView alloc] init];
    topRightBarView.frame = CGRectMake(260, 0, 60, 44);
    
    favImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmarkTop_ic.png"]];
    [favImg setFrame:CGRectMake(5, 8, 25, 25)];
    
    knowDontKnowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iknowTop_ic.png"]];
    [knowDontKnowImg setFrame:CGRectMake(28, 8, 25, 25)];
    knowDontKnowImg.hidden = YES;
    
    if ([AppDelegate_iPhone delegate].isVoiceNotesEnabled || [AppDelegate_iPhone delegate].isCommentsEnabled) {
        aduioImg = [[UIButton alloc] initWithFrame:CGRectMake(52, 8, 25, 25)];
        flipCard = [[UIButton alloc] initWithFrame:CGRectMake(15, 8, 44, 26)];
    }
    else {
        aduioImg = [[UIButton alloc] initWithFrame:CGRectMake(80, 8, 25, 25)];
        flipCard = [[UIButton alloc] initWithFrame:CGRectMake(15, 8, 44, 26)];
        //flipCard.hidden = YES;
    }
    
    //aduioImg = [[UIButton alloc] initWithFrame:CGRectMake(52, 8, 25, 25)];
    [aduioImg setImage:[UIImage imageNamed:@"sound.png"] forState:UIControlStateNormal];
    [aduioImg addTarget:self action:@selector(playAudioFile) forControlEvents:UIControlEventTouchUpInside];
    aduioImg.hidden = YES;
    searchImg = [[UIButton alloc] initWithFrame:CGRectMake(80, 8, 25, 25)];
    
    [searchImg setImage:[UIImage imageNamed:@"zoom_btn.png"] forState:UIControlStateNormal];
    
    [searchImg addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    searchImg.hidden = YES;
    
    [flipCard setImage:[UIImage imageNamed:@"flip_front.png"] forState:UIControlStateNormal];
    [flipCard addTarget:self action:@selector(showCardBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [topRightBarView addSubview:flipCard];
    [topRightBarView addSubview:aduioImg];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:topRightBarView] autorelease];
    [self showBarButtonItem];
    [super viewDidLoad];
    [self updateCardDetails];
    _prevButton.enabled = NO;
    buttonPrevious.enabled = NO;
    _cardType = kCardTypeFront;
    [topRightBarView release];
    mWindow = (TapDetectingWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
    mWindow.controllerThatObserves = self;
    
    if(basicCall)
    {
        CGSize imageSize = CGSizeMake(320, 44);
        UIColor *fillColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3];
        UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [fillColor setFill];
        //CGContextSetAlpha(context, 0.5f);
        CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *navImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.navigationController.navigationBar setBackgroundImage:navImage
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
        self.navigationController.navigationBar.translucent = YES;
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.frame = CGRectMake(0, 0, 200, 30);
        [titleLable setTextAlignment:UITextAlignmentCenter];
        titleLable.text=@"Today's Reading";
        [titleLable setBackgroundColor:[UIColor clearColor]];
        [titleLable setTextColor:[UIColor whiteColor]];
        [titleLable setFont:[UIFont RobotoBoldFont:18]];
        self.navigationItem.titleView = titleLable;
        _nextButton.enabled = NO;
        _prevButton.enabled = NO;
        buttonPrevious.enabled = NO;
        buttonNext.enabled = NO;
        _scrlView.scrollEnabled = NO;
    }
}

- (void)loadPrevCardDetails:(id)sender
{
    _isDragging = NO;
    if(_selectedCardIndex - 1 >= 0)
    {
        --_selectedCardIndex;
        _cardType = kCardTypeFront;
        
        [self updateFlashCard];
        CGRect rect = self.view.frame;
        [_scrlView setContentOffset:CGPointMake(rect.size.width  * _selectedCardIndex, 0) animated:YES];
        [self updateFlashDetails];
    }
}

- (void)loadNextCardDetails:(id)sender {
    _isDragging = NO;
    
    if(_selectedCardIndex + 1 < [_arrayOfCards count])
    {
        ++_selectedCardIndex;
        
        _cardType = kCardTypeFront;
        
        [self updateFlashCard];
        CGRect rect = self.view.frame;
        [_scrlView setContentOffset:CGPointMake(rect.size.width * _selectedCardIndex, 0) animated:YES];
        [self updateFlashDetails];
    }
}

- (void)bookMarkeds:(id)sender
{
    FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
    card.isBookMarked = !card.isBookMarked;
    [self updateCardDetails];
    [[AppDelegate_iPhone getDBAccess] setBookmarkedCard:((card.isBookMarked) ? 1 : 0) ForCardId:card.cardID];
    
    if (([AppDelegate_iPhone delegate].isBookMarked && !card.isBookMarked) || ![[AppDelegate_iPhone getDBAccess] isCommentOrNotesAvailable:card.cardID])
    {
        if (_arrayOfCards.count > 1)
        {
            [_arrayOfCards removeObjectAtIndex:_selectedCardIndex];
            --_totalCard;
            if(_arrayOfCards.count==_selectedCardIndex)
                _selectedCardIndex = ((_selectedCardIndex - 1) < 0) ? 0 : (_selectedCardIndex - 1);
            [_scrlView setContentSize:CGSizeMake(320 * [_arrayOfCards count], _scrlView.frame.size.height)];
            
            [self updateFlashDetails];
            [self updateFlashCard];
        }
        else
        {
            FlashCardDeckList* deckList = [[FlashCardDeckList alloc] init];
            DeckViewController_iPhone* controller = [[DeckViewController_iPhone alloc] initWithNibName:@"DeckViewController_iPhone" bundle:nil];
            
            controller.cardDecks = deckList;
            [self.navigationController pushViewController:controller animated:YES];
            self.navigationItem.hidesBackButton=YES;
            [deckList release];
            [controller release];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadArrayOfCards:arrCards];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_scrlView setContentSize:CGSizeMake(_scrlView.contentSize.width, _scrlView.frame.size.height)];
}

- (void)viewWillDisappear:(BOOL)animatedm{
    [self updateCardDetails];
}

- (void)showBarButtonItem {
    UIImage* img = [UIImage imageNamed:@"backNew_1.png"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 7, 50, 30);
    [button setImage:img forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* cancelButton = [[[UIBarButtonItem alloc]initWithCustomView:button] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
}

- (void)popView {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)dealloc 
{
    [favImg release];
    [knowDontKnowImg release];
    [aduioImg release];
    [searchImg release];
    [_act release];
    [_scrlView release];
    [_playAudioFileButton release];
    [_searchButton release];
    [_favorite release];
    [_know release];
    
    [_toggleFavButton release];
    [_toggleKnowUnKnownButton release];
    
    [_prevButton release];
    [_nextButton release];
    
    [_viewTurnedBack release];
    
    [_arrayOfpages release];
    
    if(_moviePlayer != nil)
        [_moviePlayer release];
    
    [_arrayOfCards release];
    [_customToolBarBottom release];
    [_scrollViewScreenWidth release];
    [super dealloc];
}

#pragma mark -
#pragma mark Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player release];
}

- (IBAction)playAudioFile
{
    NSError* err = nil;
    Card* card = [[_arrayOfCards objectAtIndex: _selectedCardIndex] getCardOfType:_cardType];
    
    NSString* audioFileName = card.audioFile;
    
    if (audioFileName == nil)
        return;
    
    audioFileName = [[NSBundle mainBundle] pathForResource:audioFileName ofType:nil inDirectory:nil];
    
    if (audioFileName == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Associated file not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:
                             [NSURL fileURLWithPath:audioFileName]
                                                                   error:&err];
    [player play];
}

- (IBAction)search {
    SearchViewController_iPhone* searchView = [[SearchViewController_iPhone alloc] initWithNibName:@"SearchView_iPhone" bundle:nil];
    [self.navigationController pushViewController:searchView animated:YES];
    [searchView release];
}

- (void)loadArrayOfCards:(NSArray*)cards
{
    NSLog(@"%@",cards);
    _arrayOfCards = (NSMutableArray*)[cards retain];
    
    if (_arrayOfpages == nil) {
        _arrayOfpages = [[NSMutableArray alloc] init];
    }
    
    _totalCard = [_arrayOfCards count];
    int count = _arrayOfCards.count;
    CGRect rect = self.view.frame;
    
    _scrlView.frame = rect;
    _scrlView.contentSize = CGSizeMake(rect.size.width * ([_arrayOfCards count]), rect.size.height);
    _scrlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    _scrlView.scrollEnabled = YES;
    NSInteger index;
    NSInteger tempIndex = _selectedCardIndex;
    CGFloat deviceWidth = rect.size.width;

    for (int i = 0; i < count; i++) {
        index = tempIndex + i;
        
        rect.origin.x += index * deviceWidth;
        CustomWebView_iPhone* page = [[CustomWebView_iPhone alloc] initWithFrame:rect];
        Card* card = [[_arrayOfCards objectAtIndex:i] getCardOfType: kCardTypeFront];

        page.tag = 1000 + i;
        [page loadClearBgHTMLString:card.cardTitle];
        [_scrlView addSubview:page];
        [_arrayOfpages addObject:page];
        page.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        
        if (_searchText!=nil && [_searchText length] > 0) {
            page.searchText=_searchText;
        }
        if (i == 0){
            mWindow.viewToObserve = page;
        }
        [page release];
    }
    
    _scrlView.showsHorizontalScrollIndicator = NO;
    
    _nextButton.enabled = YES;
    _prevButton.enabled = NO;
    buttonPrevious.enabled = NO;
    buttonNext.enabled = YES;
    todayOmerIndex_iPhone=_selectedCardIndex;

    if (basicCall == NO) {
        self.title = [NSString stringWithFormat:@"%d of %d", _selectedCardIndex + 1, [_arrayOfCards count]];
    }
    
    //scrollview
    [self updateCardDetails];
    if (_totalCard >= 2 && _selectedCardIndex >= 1) {
        [self updateFlashCard];
        [self updateFlashDetails];
        
    } else if (_totalCard==1) {
        _nextButton.enabled=NO;
        buttonNext.enabled = NO;
    }
    
    [self updateFlashCard];
    [_scrlView setContentOffset:CGPointMake(rect.size.width * _selectedCardIndex, 0) animated:YES];
    [self updateFlashDetails];
}

- (void)userDidTapWebView:(id)tapPoint {
    if ([[[Utils getValueForVar:kFlipOnTap] lowercaseString] isEqualToString:@"yes"]) {
        //[self showCardBack];
    }
}

- (void)updateCardDetails
{
    Card* card = [[_arrayOfCards objectAtIndex:_selectedCardIndex] getCardOfType: _cardType];
    aduioImg.hidden = YES;
    _playAudioFileButton.hidden = YES;
    searchImg.hidden = YES;
    _searchButton.hidden = YES;
    
    if(card.audioFile != nil)
    {
        aduioImg.hidden = NO;
        _playAudioFileButton.hidden = NO;
    }
    
    if(card.vedioFile != nil)
    {
        searchImg.hidden = YES;
        _searchButton.hidden = NO;
    }
    
    [self updateNavBar];
}


-(void) updateFlashCardAtIndex:(int)index {
    CustomWebView_iPhone* webView = (CustomWebView_iPhone*)[_arrayOfpages objectAtIndex:index];
    CGRect rect = webView.frame;
    rect.origin.x = rect.size.width * index;
    webView.frame = rect;
    [webView loadClearBgHTMLString:[[_arrayOfCards objectAtIndex:index] getCardOfType: _cardType].cardTitle];
    mWindow.viewToObserve = webView;
    if (_searchText!=nil && [_searchText length] > 0) {
        webView.searchText=_searchText;
    }
}

- (void) updateFlashCard
{
    [flipCard setImage:[UIImage imageNamed:@"flip_front.png"] forState:UIControlStateNormal];
    _isDragging = NO;
    (_selectedCardIndex > 0) ? [self updateFlashCardAtIndex:(_selectedCardIndex - 1)] : -99;
    (_selectedCardIndex < (_totalCard - 1)) ? [self updateFlashCardAtIndex:(_selectedCardIndex + 1)] : -99;
    [self updateFlashCardAtIndex:_selectedCardIndex];
    
}

- (IBAction)showCardBack:(id)sender
{
    _cardType = (_cardType == kCardTypeBack) ? kCardTypeFront : kCardTypeBack;
    if(_cardType == kCardTypeFront)
        [flipCard setImage:[UIImage imageNamed:@"flip_front.png"] forState:UIControlStateNormal];
    else
        [flipCard setImage:[UIImage imageNamed:@"flip_back.png"] forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];
    
    [UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromLeft)
                           forView:_scrlView cache:NO];
    CGRect rect = self.view.frame;
    int tagVal = 1000 + _scrlView.contentOffset.x / rect.size.width;
    CustomWebView_iPhone* webView = (CustomWebView_iPhone*)[_scrlView viewWithTag:tagVal];
    [webView loadClearBgHTMLString:[[_arrayOfCards objectAtIndex:_selectedCardIndex] getCardOfType: _cardType].cardTitle];
    
    [UIView commitAnimations];
    [self updateCardDetails];
    
    if (_searchText!=nil && [_searchText length] > 0) {
        webView.searchText=_searchText;
    }
    
}

- (IBAction)bookMarked
{
    FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
    card.isBookMarked = !card.isBookMarked;
    [self updateCardDetails];
    [[AppDelegate_iPhone getDBAccess] setBookmarkedCard:((card.isBookMarked) ? 1 : 0) ForCardId:card.cardID];
    
    if ([AppDelegate_iPhone delegate].isBookMarked && !card.isBookMarked && ![[AppDelegate_iPhone getDBAccess] isCommentOrNotesAvailable:card.cardID])
    {
        if (_arrayOfCards.count > 1)
        {
            [_arrayOfCards removeObjectAtIndex:_selectedCardIndex];
            --_totalCard;
            if(_arrayOfCards.count==_selectedCardIndex)
                _selectedCardIndex = ((_selectedCardIndex - 1) < 0) ? 0 : (_selectedCardIndex - 1);
            [_scrlView setContentSize:CGSizeMake(320 * [_arrayOfCards count], _scrlView.frame.size.height)];
            
            [self updateFlashDetails];
            [self updateFlashCard];
        }
        else
        {
            FlashCardDeckList* deckList = [[FlashCardDeckList alloc] init];
            DeckViewController_iPhone* controller = [[DeckViewController_iPhone alloc] initWithNibName:@"DeckViewController_iPhone" bundle:nil];
            
            controller.cardDecks = deckList;
            [self.navigationController pushViewController:controller animated:YES];
            self.navigationItem.hidesBackButton=YES;
            [deckList release];
            [controller release];
        }
        
    }
}

- (IBAction)cardKnownUnKnown
{
    FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
    card.isKnown = !card.isKnown ;
    [self updateCardDetails];
    [[AppDelegate_iPhone getDBAccess] setProficiency:((card.isKnown) ? 1 : 0) ForCardId:card.cardID];
}

- (void)updateNavBar
{
    if(_selectedCardIndex < 0)
        return;
    
    FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        
        if(card.isBookMarked)
        {
            _favorite.hidden = NO;
            favImg.hidden = NO;
            [_toggleFavButton setImage:[UIImage imageNamed:@"bookmarked.png"] forState:UIControlStateNormal];
        }
        else
        {
            _favorite.hidden = YES;
            favImg.hidden = YES;
            [_toggleFavButton setImage:[UIImage imageNamed:@"bookmark.png"] forState:UIControlStateNormal];
        }
        
        if(card.isKnown)
        {
            knowDontKnowImg.hidden = YES;
            [_toggleKnowUnKnownButton setImage:[UIImage imageNamed:@"bottom_read_tick_btn"] forState:UIControlStateNormal];
            [_know setImage:[UIImage imageNamed:@"bottom_read_btn.png"]];
        }
        else
        {
            knowDontKnowImg.hidden = YES;
            [_toggleKnowUnKnownButton setImage:[UIImage imageNamed:@"bottom_read_btn.png"] forState:UIControlStateNormal];
            [_know setImage: [UIImage imageNamed:@"bottom_read_tick_btn"]];
        }
        
        if (card.cardID!=0 && [[AppDelegate_iPhone getDBAccess] isCommentOrNotesAvailable:card.cardID])
        {
            [_toggle_note_btn setImage:[UIImage imageNamed:@"bottom_noted_btn.png"] forState:UIControlStateNormal];
            
            
            
        }else {
            [_toggle_note_btn setImage:[UIImage imageNamed:@"bottom_note_btn.png"] forState:UIControlStateNormal];
        }
        //[flipCard setImage:[UIImage imageNamed:@"exter-green.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        if(card.isBookMarked)
        {
            _favorite.hidden = NO;
            favImg.hidden = NO;
            [_toggleFavButton setImage:[UIImage imageNamed:@"Unmark.png"] forState:UIControlStateNormal];
        }
        else
        {
            _favorite.hidden = YES;
            favImg.hidden = YES;
            [_toggleFavButton setImage:[UIImage imageNamed:@"bookmark_6.png"] forState:UIControlStateNormal];
        }
        
        if(card.isKnown)
        {
            knowDontKnowImg.hidden = YES;
            [_toggleKnowUnKnownButton setImage:[UIImage imageNamed:@"bottom_read_tick_btn"] forState:UIControlStateNormal];
            [_know setImage:[UIImage imageNamed:@"bottom_read_btn.png"]];
        }
        else
        {
            knowDontKnowImg.hidden = YES;
            [_toggleKnowUnKnownButton setImage:[UIImage imageNamed:@"bottom_read_btn.png"] forState:UIControlStateNormal];
            [_know setImage: [UIImage imageNamed:@"bottom_read_tick_btn"]];
        }
        if (card.cardID!=0 && [[AppDelegate_iPhone getDBAccess] isCommentOrNotesAvailable:card.cardID])
        {
            [_toggle_note_btn setImage:[UIImage imageNamed:@"bottom_noted_btn.png"] forState:UIControlStateNormal];
            
            
        }else {
            [_toggle_note_btn setImage:[UIImage imageNamed:@"bottom_note_btn.png"] forState:UIControlStateNormal];
        }
        
        //[flipCard setImage:[UIImage imageNamed:@"exter-green.png"] forState:UIControlStateNormal];
        
    }
    
}
- (void) updateFlashDetails
{
    if(_selectedCardIndex == 0)
    {
        buttonPrevious.enabled = NO;
        buttonNext.enabled = YES;
        _nextButton.enabled = YES;
        _prevButton.enabled = NO;
        
    }
    else if(_selectedCardIndex >= _arrayOfCards.count - 1)
    {
        buttonPrevious.enabled = YES;
        buttonNext.enabled = NO;
        _prevButton.enabled = YES;
        _nextButton.enabled = NO;
    }
    else
    {
        buttonPrevious.enabled = YES;
        buttonNext.enabled = YES;
        _nextButton.enabled = YES;
        _prevButton.enabled = YES;
    }
    
    [self updateNavBar];
    [self updateCardDetails];
    if(_selectedCardIndex < 0)
        return;
    if (basicCall == YES && todayOmerIndex_iPhone ==_selectedCardIndex) {
        
    }
    else
        self.title = [NSString stringWithFormat:@"%ld of %lu", _selectedCardIndex + 1, (unsigned long)[_arrayOfCards count]];
}


- (void)hideLoading
{
    [_act stopAnimating];
}

/// Comment to remove swipe feature from the application
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    CGRect rect = self.view.frame;
    _selectedCardIndex = scrollView.contentOffset.x / rect.size.width;
    _cardType = kCardTypeFront;
    [self updateFlashCard];
    [self updateFlashDetails];
    _isDragging = NO;
}

-(void) showActionSheet{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    //    if ([AppDelegate_iPhone delegate].isVoiceNotesEnabled) {
    //        [actionSheet addButtonWithTitle:@"Voice Notes"];
    //    }
    
    if ([AppDelegate_iPhone delegate].isCommentsEnabled) {
        [actionSheet addButtonWithTitle:@"Text Notes"];
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    
    
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Voice Notes"]) {
        //        // Load Voice Notes View
        //        VoiceNotesViewController_iPhone *detailViewController = [[VoiceNotesViewController_iPhone alloc] initWithNibName:@"VoiceNotesView_iPhone" bundle:nil];
        //        FlashCard* card=[_arrayOfCards objectAtIndex:_selectedCardIndex];
        //        [detailViewController setFlashCardId:[card cardID]];
        //        [detailViewController setParent:self];
        //        [self.navigationController presentModalViewController:detailViewController animated:YES];
        //        [detailViewController release];
        
    }
    
    else if ([title isEqualToString:@"Text Notes"]) {
        
        //Load Comments View
        CommentsViewController_iPhone *detailViewController = [[CommentsViewController_iPhone alloc] initWithNibName:@"CommentsView_iPhone" bundle:nil];
        [detailViewController setFlashCardId:[[_arrayOfCards objectAtIndex:_selectedCardIndex] cardID]];
        [detailViewController setParent:self];
        [self.navigationController presentModalViewController:detailViewController animated:YES];
        [detailViewController release];
        
    }
}

- (void)viewDidUnload {
    [self setCustomToolBarBottom:nil];
    [super viewDidUnload];
}

@end

