//
//  FlashCard.m
//  FlashCardDB
//
//  Created by Friends on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBAccess.h"

#import "AppDelegate_iPhone.h"

#import "FlashCard.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


NSString* RowImages[] = {@"deck1.png", @"deck2.png", @"deck3.png", @"deck4.png"};

@implementation Card

@synthesize htmlFile = _htmlFile;
@synthesize audioFile = _audioFile;	
@synthesize vedioFile = _vedioFile;
@synthesize imageFile = _imageFile;
@synthesize cardTitle = _cardTitle;
@synthesize cardName = _cardName;
@synthesize cardColor = _cardColor;

+ (NSString*) getAudioFile:(NSString*) audioFile
{
	NSArray* arr = [audioFile componentsSeparatedByString:@"/"];
	return (arr.count > 0) ? [arr lastObject] : nil;
}

- (void) setResourceType:(ResourceType) type resource:(NSString*) str
{
	switch (type)
	{
		case 1:
			_htmlFile = [[Card getAudioFile:str] retain];
			break;
		case 2:
			_audioFile = [[Card getAudioFile:str] retain];
			break;
		case 3:
			_vedioFile = [[Card getAudioFile:str] retain];
			break;
		case 4:
			_imageFile = [[Card getAudioFile:str] retain];
			break;
        case kResourceTypeNone:
            break;
	}
}

- (void) dealloc
{
	[_htmlFile release];
	[_audioFile release];	
	[_vedioFile release];
	[_imageFile release];
	
	[_cardTitle release];
	[_cardColor release];
	[super dealloc];
}

@end



@implementation FlashCard

@synthesize frontCard = _frontCard;
@synthesize backCard = _backCard;
@synthesize isKnown = _isKnown;
@synthesize isBookMarked = _isBookMarked;
@synthesize cardID = _cardID;
@synthesize internalCardId = _internalCardId;
@synthesize cardName = _cardName;
@synthesize cardColor = _cardColor;

- (id) init
{
	if (self = [super init])
	{
		_frontCard = [[Card alloc] init];
		_backCard = [[Card alloc] init];
	}
	return self;
}

- (Card*) getCardOfType:(CardType) type
{
	switch (type)
	{
		case 1:
			return _frontCard;
			
		case 2:
			return _backCard;
            
        case kCardTypeNone:
            return NULL;
			
	}
	
	return nil;
}

- (void) dealloc
{
	[_frontCard release];
	[_backCard release];

	[super dealloc];
}

@end



@implementation FlashCardDeck

@synthesize deckColor = _deckColor;
@synthesize deckImage = _deckImage;
@synthesize deckTitle = _deckTitle;
@synthesize deckId = _deckId;
@synthesize isHeader = _isHeader;
@synthesize deckType = _deckType;
@synthesize cardCount = _cardCount;
@synthesize proficiency = _proficiency;

- (NSMutableArray*) getCardsList
{
	return [[AppDelegate_iPhone getDBAccess] getCardListForDeckType:_deckType withId:_deckId];
}



@end



@implementation FlashCardDeckList

@synthesize allCardDeck = _allCardDeck;
@synthesize todayReadingDeck = _todayReadingDeck;
@synthesize bookMarkedCardDeck = _bookMarkedCardDeck;
@synthesize flashCardDeckList = _flashCardDeckList;
@synthesize introDeck = _introDeck;

- (void) initializeIntroDeck
{
	_introDeck = [[FlashCardDeck alloc] init];
	
	_introDeck.deckId = -99;
	_introDeck.deckTitle = @"Introduction";
	_introDeck.deckType = kIntroDeck;
	//_allCardDeck.deckColor = kDeckRowAllBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _introDeck.deckImage = @"intoduction.png";
        _introDeck.deckColor = [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
    }
    else{
    _introDeck.deckImage = @"intoduction.png";
	_introDeck.deckColor = [Utils colorFromString:[Utils getValueForVar:kIntroDeckColor]];
    }
}
- (void) initializeAllCardDeck
{
	_allCardDeck = [[FlashCardDeck alloc] init];
	
	_allCardDeck.deckId = -99;
	_allCardDeck.deckTitle = @"All Cards";
	_allCardDeck.deckType = kCardDeckTypeAll;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        _allCardDeck.deckImage = @"all-cards.png";
        _allCardDeck.deckColor =  [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
    }
    else{
        _allCardDeck.deckImage = @"all-cards.png";
        _allCardDeck.deckColor = [Utils colorFromString:[Utils getValueForVar:kAllCardsDeckColor]];
    }
	//_allCardDeck.deckColor = kDeckRowAllBackgroundColor;
	//_allCardDeck.deckColor = [Utils colorFromString:[Utils getValueForVar:kAllCardsDeckColor]];
}

- (void) initializeBookMarkedCardDeck
{
	_bookMarkedCardDeck = [[FlashCardDeck alloc] init];
	
	_bookMarkedCardDeck.deckId = -99;
	_bookMarkedCardDeck.deckTitle = @"Bookmarks & Notes";
	_bookMarkedCardDeck.deckType = kCardDeckTypeBookMark;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _bookMarkedCardDeck.deckImage = @"bookmark-cards.png";
         _bookMarkedCardDeck.deckColor = [UIColor   colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
    }
    else{
	_bookMarkedCardDeck.deckImage = @"bookmark-cards.png";
        _bookMarkedCardDeck.deckColor = [Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsDeckColor]];
    }
	//_bookMarkedCardDeck.deckColor = kDeckRowBookMarkedBackgroundColor;
	//_bookMarkedCardDeck.deckColor = [Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsDeckColor]];
}

- (void) initializeTodayReadingDeck
{
   	_todayReadingDeck = [[FlashCardDeck alloc] init];
    
    _todayReadingDeck.deckId = -99;
    _todayReadingDeck.deckTitle = @"Today's Reading";
    _todayReadingDeck.deckType = kCardDeckTypeTodayReading;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _todayReadingDeck.deckImage = @"today-reading.png";
        
        _todayReadingDeck.deckColor = [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
    }
    else{
        _todayReadingDeck.deckImage = @"today-reading.png";
        _todayReadingDeck.deckColor = [Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsDeckColor]];
    }
}

- (id) init
{
	if (self = [super init])
	{
		_flashCardDeckList = [[[AppDelegate_iPhone getDBAccess] getFlashCardDeckList] retain];
        [self initializeIntroDeck];
		[self initializeAllCardDeck];
        [self initializeTodayReadingDeck];
		[self initializeBookMarkedCardDeck];
		[self updateProficiency];
	}
	return self;
}

- (void) updateCardCount
{
	_bookMarkedCardDeck.cardCount = [[AppDelegate_iPhone getDBAccess]
									 getCardCountForDeckType:kCardDeckTypeBookMark withId:-99];

	_allCardDeck.cardCount = [[AppDelegate_iPhone getDBAccess]
									 getCardCountForDeckType:kCardDeckTypeAll withId:-99];
	FlashCardDeck* deck;
	for (int i = 0; i < _flashCardDeckList.count; ++i)
	{
		deck = [_flashCardDeckList objectAtIndex:i];
		
		deck.cardCount = [[AppDelegate_iPhone getDBAccess]
						  getCardCountForDeckType:kCardDeckTypeAlfabaticallly withId:deck.deckId];
	}
}

- (void) updateProficiency
{
	[self updateCardCount];
	CGFloat proff = (CGFloat)[[AppDelegate_iPhone getDBAccess]
									 getKnownCardCountForDeckType:kCardDeckTypeBookMark withId:-99];
	_bookMarkedCardDeck.proficiency = (_bookMarkedCardDeck.cardCount > 0) ?
	(100.0f * proff) / (CGFloat) _bookMarkedCardDeck.cardCount : 0.0f;
	
	proff = (CGFloat)[[AppDelegate_iPhone getDBAccess]
									 getKnownCardCountForDeckType:kCardDeckTypeAll withId:-99];
	
	_allCardDeck.proficiency = (100.0f * proff) / (CGFloat) _allCardDeck.cardCount;
	FlashCardDeck* deck;
	for (int i = 0; i < _flashCardDeckList.count; ++i)
	{
		deck = [_flashCardDeckList objectAtIndex:i];
		
		proff = [[AppDelegate_iPhone getDBAccess]
						  getKnownCardCountForDeckType:kCardDeckTypeAlfabaticallly withId:deck.deckId];
		deck.proficiency = (100.0f * proff) / (CGFloat) deck.cardCount;
	}
}

- (void) dealloc
{
    [_introDeck release];
	[_allCardDeck release];
    [_todayReadingDeck release];
	[_bookMarkedCardDeck release];
	[_flashCardDeckList release];
	
	[super dealloc];
}

@end
