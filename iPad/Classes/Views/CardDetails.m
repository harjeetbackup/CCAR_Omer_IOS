//
//  CardDetails.m
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBAccess.h"
#import "FlashCard.h"
#import "CustomWebView.h"
#import "AppDelegate_iPad.h"
#import "VideoGallaryViewController.h"
#import "VoiceNotesViewController.h"
#import "CommentsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

#import "CardDetails.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation CardDetails

@synthesize _selectedCardIndex;
@synthesize _searchText;
@synthesize _parentView;
@synthesize mWindow;
@synthesize basicCall;
@synthesize popoverController;
NSInteger todayOmerIndex=0;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    /*  CGRect aFrameCardDetailNavBar = self.aCardDetailNavBar.frame;
     aFrameCardDetailNavBar.origin.y = 64;
     self.aCardDetailNavBar.frame = aFrameCardDetailNavBar;
     
     CGRect aFrameView = self.myView.frame;
     aFrameView.size.height = 64;
     self.myView.frame = aFrameView;*/
    
    
    /* UIButton *leftButtonImgseven = [[[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)] autorelease];
     [leftButtonImgseven setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [leftButtonImgseven addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchDown];*/
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    
    
	UIButton *leftButtonImg = [[[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 20)] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(3, 7, 50, 30)];
        [leftButtonImg setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        [self.preButton setImage:[UIImage imageNamed:@"left_arw.png"] forState:UIControlStateNormal];
        [self.nexButton setImage:[UIImage imageNamed:@"right_arw.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(13, 12, 50, 20)];
        
        [leftButtonImg setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
        [self.nexButton setImage:[UIImage imageNamed:@"next_btn.png"] forState:UIControlStateNormal];
        [self.preButton setImage:[UIImage imageNamed:@"prev_btn.png"] forState:UIControlStateNormal];
    }
    
    
    
	//[leftButtonImg setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchDown];
	leftButtonImg.tag = 1;
    
	//UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
	//self.navigationItem.leftBarButtonItem=leftButton;
	if (basicCall == NO) {
        if([self.view viewWithTag:1]!=nil)
        {
            [[self.view viewWithTag:1] removeFromSuperview];
        }
        // if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"6.0"))
        // {
		[self.view addSubview:leftButtonImg];
        // }
        // else{
        //   [self.view addSubview:leftButtonImgseven];
        //}
	}
    
	[_prevButton setNeedsDisplay];
	_act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	_act.center = self.view.center;
	
	UIView* topRightBarView = [[[UIView alloc] init] autorelease];
	topRightBarView.frame = CGRectMake(90, 0, 130, 44);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        favImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [favImg setFrame:CGRectMake(0, 8, 30, 30)];
        
    }
    else{
	
	favImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmarkTop_ic.png"]];
	[favImg setFrame:CGRectMake(0, 8, 30, 30)];
    }
	
	knowDontKnowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iknowTop_ic.png"]];
	[knowDontKnowImg setFrame:CGRectMake(32, 8, 30, 30)];
	knowDontKnowImg.hidden = YES;
	
	aduioImg = [[UIButton alloc] initWithFrame:CGRectMake(64, 8, 30, 30)];
	[aduioImg setImage:[UIImage imageNamed:@"audio.png"] forState:UIControlStateNormal];
	[aduioImg addTarget:self action:@selector(playAudioFile) forControlEvents:UIControlEventTouchUpInside];
	aduioImg.hidden = YES;
	
	videoImg = [[UIButton alloc] initWithFrame:CGRectMake(-32, 8, 30, 30)];
	[videoImg setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
	[videoImg addTarget:self action:@selector(playVideoFile) forControlEvents:UIControlEventTouchUpInside];
	videoImg.hidden = YES;
	
	flipCard = [[UIButton alloc] initWithFrame:CGRectMake(96, 8, 44, 26)];
	[flipCard setImage:[UIImage imageNamed:@"flip_front.png"] forState:UIControlStateNormal];
	[flipCard addTarget:self action:@selector(showCardBack:) forControlEvents:UIControlEventTouchUpInside];
    favImg.tag=2;
    knowDontKnowImg.tag=3;
    aduioImg.tag=4;
    videoImg.tag=5;
    flipCard.tag=6;
	if([self.view viewWithTag:2]!=nil)
    {
        [[self.view viewWithTag:2] removeFromSuperview];
    }
    if([self.view viewWithTag:3]!=nil)
    {
        [[self.view viewWithTag:3] removeFromSuperview];
    }
    if([self.view viewWithTag:4]!=nil)
    {
        [[self.view viewWithTag:4] removeFromSuperview];
    }
    if([self.view viewWithTag:5]!=nil)
    {
        [[self.view viewWithTag:5] removeFromSuperview];
    }
    
	[topRightBarView addSubview:favImg];
	[topRightBarView addSubview:knowDontKnowImg];
	[topRightBarView addSubview:aduioImg];
	[topRightBarView addSubview:videoImg];

        if([self.view viewWithTag:6]!=nil)
        {
            [[self.view viewWithTag:6] removeFromSuperview];
        }
		[topRightBarView addSubview:flipCard];
    
	_extraNavigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:topRightBarView] autorelease];
	
	[self showBarButtonItem];
    [super viewDidLoad];
	
	[self updateCardDetails];
	_prevButton.enabled = NO;
	
	//_selectedCardIndex = 0;
	_cardType = kCardTypeFront;
	//[topRightBarView release];
	
	mWindow = (TapDetectingWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
	mWindow.controllerThatObserves = self;
	
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)popView{
	//[self.navigationController popViewControllerAnimated:YES];
    
	[self.view removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[_scrlView setContentOffset:CGPointZero];
	[self updateCardDetails];
}

- (void)showBarButtonItem
{
	UIImage* img = [UIImage imageNamed:@"back_btn.png"];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    // if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"6.0"))
    // {
	button.frame = CGRectMake(0, 0, 54, 30);
	[button setImage:img forState:UIControlStateNormal];
    // }
	[button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* cancelButton = [[[UIBarButtonItem alloc]initWithCustomView:button] autorelease];
    // if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"6.0"))
    // {
	self.navigationItem.leftBarButtonItem = cancelButton;
    // }
}

/*
 - (void)popView
 {
 [self.navigationController popViewControllerAnimated:YES];
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}

- (void)dealloc
{
	[favImg release];
	[knowDontKnowImg release];
	[aduioImg release];
	[videoImg release];
	[_act release];
	
	[_scrlView release];
	[_playAudioFileButton release];
	[_playVideoFileButton release];
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
    [_aCardDetailNavBar release];
    [_myView release];
    [_preButton release];
    [_nexButton release];
    [_titleLabel release];
    [_toggle_note_btn release];
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
	//Card* card = [[_arrayOfCards objectAtIndex: _selectedCardIndex] getCardOfType:_cardType];
	Card* card = [[_arrayOfCards objectAtIndex:_selectedCardIndex] getCardOfType: _cardType];
	NSString* audioFileName = card.audioFile;
	
	if (audioFileName == nil)
		return;
	
	audioFileName = [[NSBundle mainBundle] pathForResource:audioFileName ofType:nil inDirectory:nil];
	
	NSLog(@"%@", audioFileName);
	
	if (audioFileName == nil)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Associated file not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:
							 [NSURL fileURLWithPath:audioFileName] error:&err];
	//player.delegate = self;
	[player play];
}

- (IBAction)playVideoFile
{
	Card* card = [[_arrayOfCards objectAtIndex: _selectedCardIndex] getCardOfType:_cardType];
	NSString* videoFileName = card.vedioFile;
	
	if (videoFileName == nil)
		return;
	
	// Setup the player
	_moviePlayer = [[VideoGallaryViewController alloc] init];
	
	videoFileName = [[NSBundle mainBundle] pathForResource:videoFileName ofType:nil inDirectory:nil];
	
	NSLog(@"%@", videoFileName);
	
	if(videoFileName == nil)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Associated file not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSURL* url = [NSURL fileURLWithPath:videoFileName];
	
	_moviePlayer.movieURL = url;
	
	[_moviePlayer readyPlayer];
	
	[self presentModalViewController:_moviePlayer animated:YES];
}

- (void)loadArrayOfCards:(NSArray*)cards withParentViewC:(DeckViewController*) prntViewC
{
	_arrayOfCards = (NSMutableArray*)[cards retain];
	_parentView = prntViewC;
	
	if (_arrayOfpages == nil)
	{
		_arrayOfpages = [[NSMutableArray alloc] initWithCapacity:3];
	}
	
	_totalCard = [_arrayOfCards count];
	
	int count = (_arrayOfCards.count > 3) ? 3 : _arrayOfCards.count;
	[_scrlView setContentSize:CGSizeMake(kDetailViewWidth * [_arrayOfCards count], _scrlView.frame.size.height)];
	///	_scrlView.scrollEnabled = NO;
	
	NSInteger index=0;
	NSInteger tempIndex=_selectedCardIndex;
	
	if (_selectedCardIndex >= 1 && _selectedCardIndex >= [_arrayOfCards count]-2) {
		tempIndex=_selectedCardIndex-1;
	}
	
	if (_totalCard > 2 && _selectedCardIndex > 1) {
		tempIndex=_selectedCardIndex-2;
	}
    Card* card;  
	//CustomWebView* page=[[[CustomWebView alloc] init] autorelease] ;
	for (int i = 0; i < count; i++)
	{
		index = tempIndex	+ i;
        CustomWebView* page = [[CustomWebView alloc] initWithFrame:CGRectMake(kDetailViewWidth * i, 0, kDetailViewWidth, _scrlView.frame.size.height)];
        card = [[_arrayOfCards objectAtIndex:index] getCardOfType: kCardTypeFront];
        //page.frame = CGRectMake(kDetailViewWidth * i, 0, kDetailViewWidth, _scrlView.frame.size.height);
        
		//page.tag = 1100 + i;
		[page loadClearBgHTMLString:card.cardTitle];
        /*if([_arrayOfpages objectAtIndex:index]!=nil)
         {
         [_arrayOfpages removeObjectAtIndex:index];
         }*/
        //page.tag=10;
        
		[_scrlView addSubview:page];
		[_arrayOfpages addObject:page];
		
		if (_searchText!=nil && [_searchText length] > 0) {
			page.searchText=_searchText;
		}
		
		if (i == 0)
		{
			mWindow.viewToObserve = page;
		}
	}
    
	
	_scrlView.showsHorizontalScrollIndicator = NO;
	
	_nextButton.enabled = YES;
	_prevButton.enabled = NO;
	
	//_extraNavigationItem.title = [NSString stringWithFormat:@"%d of %lu", _selectedCardIndex + 1, (unsigned long)[_arrayOfCards count]];
    if (basicCall == YES) {
        _titleLabel.text=@"Today's Reading";
        todayOmerIndex=_selectedCardIndex;
        _nextButton.enabled = NO;
        _prevButton.enabled = NO;
    }
    else
    _titleLabel.text=[NSString stringWithFormat:@"%ld of %lu", _selectedCardIndex + 1, (unsigned long)[_arrayOfCards count]];
	//scrollview
    [self updateFlashCard];
	[self updateCardDetails];
	
	if (_totalCard >= 2 && _selectedCardIndex >= 1) {
		[self updateFlashCard];
		[_scrlView setContentOffset:CGPointMake(kDetailViewWidth * _selectedCardIndex, 0)];
		[self updateFlashDetails];
		
	}else if (_totalCard==1) {
		_nextButton.enabled=NO;
	}
    
}

- (void)userDidTapWebView:(id)tapPoint
{
    if ([[[Utils getValueForVar:kFlipOnTap] lowercaseString] isEqualToString:@"yes"]) {
		[self showCardBack];
	}
	
}

- (void)updateCardDetails
{
	if ([_arrayOfCards count]==0) {
		return;
	}
	
	Card* card = [[_arrayOfCards objectAtIndex:_selectedCardIndex] getCardOfType: _cardType];
	
	aduioImg.hidden = YES;
	_playAudioFileButton.hidden = YES;
	videoImg.hidden = YES;
	_playVideoFileButton.hidden = YES;
	
	if(card.audioFile != nil)
	{
		aduioImg.hidden = NO;
		_playAudioFileButton.hidden = NO;
	}
	
	if(card.vedioFile != nil)
	{
		videoImg.hidden = NO;
		_playVideoFileButton.hidden = NO;
	}
	
	[self updateNavBar];
}

- (void) updateFlashCardAtIndex:(int) index
{
	NSInteger tempIndex=(index % 3);
	CustomWebView* webView = (CustomWebView*)[_arrayOfpages objectAtIndex:tempIndex];
	webView.frame = CGRectMake(kDetailViewWidth * index, 0, kDetailViewWidth, _scrlView.frame.size.height);
	webView.tag = 1100 + index;
	mWindow.viewToObserve = webView;
	[webView loadClearBgHTMLString:[[_arrayOfCards objectAtIndex:index] getCardOfType: _cardType].cardTitle];
	
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

- (IBAction)loadNextCardDetails
{
	_isDragging = NO;
	
	if(_selectedCardIndex + 1 < [_arrayOfCards count])
	{
		++_selectedCardIndex;
		_cardType = kCardTypeFront;
		
		[_scrlView setContentOffset:CGPointMake(kDetailViewWidth * _selectedCardIndex, 0) animated:YES];
		[_cardTimer invalidate];
		[_cardTimer release];
		_cardTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateFlashCard) userInfo:nil repeats:NO] retain];
		[self updateFlashDetails];
	}
	
}

- (IBAction)loadPrevCardDetails
{
	_isDragging = NO;
	if(_selectedCardIndex - 1 >= 0)
	{
		--_selectedCardIndex;
		_cardType = kCardTypeFront;
		
		[_scrlView setContentOffset:CGPointMake(kDetailViewWidth * _selectedCardIndex, 0) animated:YES];
		[_cardTimer invalidate];
		[_cardTimer release];
		_cardTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateFlashCard) userInfo:nil repeats:NO] retain];
		[self updateFlashDetails];
	}
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
	
	int tagVal = 1100 + _scrlView.contentOffset.x / kDetailViewWidth;
	CustomWebView* webView = (CustomWebView*)[_scrlView viewWithTag:tagVal];
	[webView loadClearBgHTMLString:[[_arrayOfCards objectAtIndex:_selectedCardIndex] getCardOfType: _cardType].cardTitle];
	
	[UIView commitAnimations];
	[self updateCardDetails];
	///	[self updateFlashDetails];
	
	if (_searchText!=nil && [_searchText length] > 0) {
		webView.searchText=_searchText;
	}
	
}

- (IBAction)bookMarked
{
	FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
	card.isBookMarked = !card.isBookMarked;
	[self updateCardDetails];
	[[AppDelegate_iPad getDBAccess] setBookmarkedCard:((card.isBookMarked) ? 1 : 0) ForCardId:card.cardID];
	
	if ([AppDelegate_iPad delegate].isBookMarked && !card.isBookMarked && ![[AppDelegate_iPad getDBAccess] isCommentOrNotesAvailable:card.cardID])
	{
		if (_arrayOfCards.count > 1)
		{
			[_arrayOfCards removeObjectAtIndex:_selectedCardIndex];
			--_totalCard;
            if(_arrayOfCards.count==_selectedCardIndex)
                _selectedCardIndex = ((_selectedCardIndex - 1) < 0) ? 0 : (_selectedCardIndex - 1);
            // if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"6.0"))
            // {
			[_scrlView setContentSize:CGSizeMake(kDetailViewWidth * [_arrayOfCards count], _scrlView.frame.size.height)];
            //}
            // else
            // {
            // [_scrlView setContentSize:CGSizeMake(680 * [_arrayOfCards count], _scrlView.frame.size.height)];
            
            //}
			[self updateFlashDetails];
			[self updateFlashCard];
		}
		else
		{
			[_parentView openFirstView];
		}
		
	}
	[_parentView updateInfo];
}

- (IBAction)cardKnownUnKnown
{
	FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
	card.isKnown = !card.isKnown ;
	[self updateCardDetails];
	[[AppDelegate_iPad getDBAccess] setProficiency:((card.isKnown) ? 1 : 0) ForCardId:card.cardID];
	[_parentView updateInfo];
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
        
        if (card.cardID!=0 && [[AppDelegate_iPad getDBAccess] isCommentOrNotesAvailable:card.cardID])
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
        if (card.cardID!=0 && [[AppDelegate_iPad getDBAccess] isCommentOrNotesAvailable:card.cardID])
        {
            [_toggle_note_btn setImage:[UIImage imageNamed:@"bottom_noted_btn.png"] forState:UIControlStateNormal];
            
            
            
        }else {
            [_toggle_note_btn setImage:[UIImage imageNamed:@"bottom_note_btn.png"] forState:UIControlStateNormal];
        }
       
            //[flipCard setImage:[UIImage imageNamed:@"exter-green.png"] forState:UIControlStateNormal];
        
        
    }
	
}

- (void) updateActionImage{
	//[flipCard setImage:[UIImage imageNamed:@"exter-green.png"] forState:UIControlStateNormal];
}


- (void) updateFlashDetails
{
	if(_selectedCardIndex == 0)
	{
		_nextButton.enabled = YES;
		_prevButton.enabled = NO;
	}
	else if(_selectedCardIndex >= _arrayOfCards.count - 1)
	{
		_prevButton.enabled = YES;
		_nextButton.enabled = NO;
	}
	else
	{
		_nextButton.enabled = YES;
		_prevButton.enabled = YES;
	}
	
	[self updateNavBar];
	[self updateCardDetails];
	if(_selectedCardIndex < 0)
		return;
	
	//_extraNavigationItem.title = [NSString stringWithFormat:@"%d of %lu", _selectedCardIndex + 1, (unsigned long)[_arrayOfCards count]];
    if (basicCall == YES && todayOmerIndex ==_selectedCardIndex) {
        _titleLabel.text=@"Today's Reading";
        _nextButton.enabled = NO;
        _prevButton.enabled = NO;
    }
    else
    _titleLabel.text=[NSString stringWithFormat:@"%ld of %lu", _selectedCardIndex + 1, (unsigned long)[_arrayOfCards count]];
}


- (void)hideLoading
{
	[_act stopAnimating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	_isDragging = YES;
	if([scrollView isKindOfClass:[UITableView class]] == NO)
	{
		if (_isDragging)
		{
			[_cardTimer invalidate];
			[_cardTimer release];
			_cardTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(slidingAction:) userInfo:scrollView repeats:NO] retain];
		}
	}
}

- (void) slidingAction:(NSTimer*)timer
{
	UIScrollView* scrollView = [timer userInfo];
	_selectedCardIndex = scrollView.contentOffset.x / kDetailViewWidth;
	_cardType = kCardTypeFront;
	[self updateFlashCard];
	[self updateFlashDetails];
	_isDragging = NO;
}


- (IBAction)showActionSheet:(id)sender {
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    
    if ([AppDelegate_iPad delegate].isVoiceNotesEnabled) {
        [actionSheet addButtonWithTitle:@"Voice Notes"];
    }
    
    if ([AppDelegate_iPad delegate].isCommentsEnabled) {
        [actionSheet addButtonWithTitle:@"Text Notes"];
    }
   // [actionSheet addButtonWithTitle:@"Cancel"];
   
    [actionSheet showFromRect:CGRectMake(280, 720, 100, 100) inView:self.view animated:YES];

    [actionSheet release];
 
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex==-1) return;
    
	NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
	
	if ([title isEqualToString:@"Voice Notes"]) {
		
		// Load Voice Notes View
		VoiceNotesViewController *detailViewController = [[VoiceNotesViewController alloc] initWithNibName:@"VoiceNotesViewiPad" bundle:nil];
		FlashCard* card=[_arrayOfCards objectAtIndex:_selectedCardIndex];
		[detailViewController setFlashCardId:[card cardID]];
		[detailViewController setParent:self];
		
		detailViewController.view.frame = CGRectMake(382, 0, kDetailViewWidth, 768);
        detailViewController.view.tag=8;
        if([self.view viewWithTag:8]!=nil)
        {
            [[self.view viewWithTag:8] removeFromSuperview];
        }
		[[_parentView view] addSubview:detailViewController.view];
		
	}
	
	else if ([title isEqualToString:@"Text Notes"]) {
		
		//Load Comments View
		CommentsViewController *detailViewController = [[CommentsViewController alloc] initWithNibName:@"CommentsViewiPad" bundle:nil];
		[detailViewController setFlashCardId:[[_arrayOfCards objectAtIndex:_selectedCardIndex] cardID]];
		[detailViewController setParent:self];
		
		detailViewController.view.frame = CGRectMake(382, 0, kDetailViewWidth, 768);
        detailViewController.view.tag=9;
        if([self.view viewWithTag:9]!=nil)
        {
            [[self.view viewWithTag:9] removeFromSuperview];
        }
		[[_parentView view] addSubview:detailViewController.view];
		
	}
	
}

- (void) resetKnownUnknown
{
	FlashCard* card;
	for (int i = 0; i < [_arrayOfCards count]; i++) {
		card = [_arrayOfCards objectAtIndex:i];
		card.isKnown = NO;
	}
}
- (void) resetBookmarked
{
	FlashCard* card;
	for (int i = 0; i < [_arrayOfCards count]; i++) {
		card = [_arrayOfCards objectAtIndex:i];
		card.isBookMarked = NO;
	}
	
}
- (void) resetBoth
{
	[self resetKnownUnknown];
	[self resetBookmarked];
}

-(void) setParentViewCtrl:(DeckViewController *)parentView
{
	_parentView = parentView;
}

- (void)viewDidUnload {
    [self setACardDetailNavBar:nil];
    [self setMyView:nil];
    [self setPreButton:nil];
    [self setNexButton:nil];
    [super viewDidUnload];
}
@end

