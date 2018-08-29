//
//  Constants.h
//  FlashCardDB
//
//  Created by Friends on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDetailViewWidth	642

#define DBNAME		@"flashCard.db3"

#define DECKTABLE	@"m_FlashCardDecks"

#define kInfoRowBackgroundColor				[UIColor colorWithRed:0.0 green:0.322 blue:0.369 alpha:1.0];
//#define kDeckRowAllBackgroundColor			[UIColor colorWithRed:0.81 green:0.75 blue:0.56 alpha:1.0];
//#define kDeckRowBookMarkedBackgroundColor	[UIColor colorWithRed:0.81 green:0.75 blue:0.56 alpha:1.0];




#define kDeckHeader						@"DeckHeader"
#define kDBName                         @"DBName"
#define kHeaderTitle                    @"HeaderTitle"
#define kFacebookHeader                 @"FacebookHeader"
#define kFacebookAppID					@"FacebookAppID "
#define kFacebookAppSecretKey           @"FacebookAppSecretKey"
#define kTwitterConsumerKey				@"TwitterOAuthConsumerKey"
#define kTwitterConsumerSecret			@"TwitterOAuthConsumerSecret"
#define kAppiraterAppID 				@"AppiraterIAppID"
#define kAllCardsDeckColor				@"AllCardsDeckColor"
#define kBookmarkedCardsDeckColor		@"BookmarkedCardsDeckColor"
#define kTwitterUrlCallback				@"TwitterUrlCallback"
#define kIndexRowColor					@"IndexRowColor"
#define kAllCardsTextColor				@"AllCardsTextColor"
#define kBookmarkedCardsTextColor		@"BookmarkedCardsTextColor"
#define kDeckCardsTextColor				@"DeckCardsTextColor"
#define kCardList						@"CardList"
#define kDeckHeaderTextColor			@"DeckHeaderTextColor"
#define kRandomOption					@"RandomOption"
#define kSelectedCardsColor             @"SelectedCardsColor"
#define kSelectedDeckColor              @"SelectedDeckColor"
#define kFlipOnTap                      @"FlipOnTap"
#define kProficiencyEnable              @"IsProficiencyEnable"
#define kCardListColor					@"CardListColor"
#define kSearchCardListColor			@"SearchCardListColor"
#define kAudioOnTapToStart              @"AudioOnTapToStart"
#define kFacebookMessage                @"FacebookMessage"
#define kTwitterMessage                 @"TwitterMessage"
#define kIsIntroScreen                  @"IsIntroScreen"
#define kStartSoundFile                 @"StartSoundFile"
#define kIntroDeckColor                 @"IntroDeckColor"
#define kisAppRating                    @"isAppRating"


#define SELECT_DECK_CARD_QUERY	[NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@",				\
@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack ",			\
@"from  (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack, ",		\
@"b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName,a.CardColor from m_FlashCard a, ",	\
@"m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId ",			\
@"and a.fk_FlashCardDeckId = %d) m LEFT OUTER JOIN m_FlashCardInternalDetails p ", \
@"on m.pk_FlashCardId = p.fk_FlashCardId"]

#define SELECT_All_DECK_CARD_QUERY	[NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@",				\
@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack ",			\
@"from  (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack, ",		\
@"b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName,a.CardColor from m_FlashCard a, ",	\
@"m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId",			\
@") m LEFT OUTER JOIN m_FlashCardInternalDetails p ", \
@"on m.pk_FlashCardId = p.fk_FlashCardId"]

#define SELECT_Today_Reading_DECK_CARD_QUERY	[NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@",				\
@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack ",			\
@"from  (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack, ",		\
@"b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName,a.CardColor from m_FlashCard a, ",	\
@"m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId and a.pk_FlashCardId=%d",			\
@") m LEFT OUTER JOIN m_FlashCardInternalDetails p ", \
@"on m.pk_FlashCardId = p.fk_FlashCardId"]


#define SELECT_Alphabetical_DECK_CARD_QUERY	[NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@",				\
@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack ",			\
@"from  (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack, ",		\
@"b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName from m_FlashCard a, ",	\
@"m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId order by a.CardName COLLATE NOCASE",			\
@") m LEFT OUTER JOIN m_FlashCardInternalDetails p ", \
@"on m.pk_FlashCardId = p.fk_FlashCardId"]


/*
#define SELECT_BOOK_DECK_CARD_QUERY	[NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@",				\
@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack ",			\
@"from  (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack, ",		\
@"b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName from m_FlashCard a, ",	\
@"m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId ",			\
@"and a.ISBookMarked = 1) m LEFT OUTER JOIN m_FlashCardInternalDetails p ", \
@"on m.pk_FlashCardId = p.fk_FlashCardId"]
*/
#define SELECT_BOOKMARK_AND_NOTES_DECK_CARD_QUERY	[NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@",				\
@"select m.*, ifnull(p.fk_TypeId,''), ifnull(p.TitleData,''), p.FrontOrBack ",			\
@"from  (select a.pk_FlashCardId, a.InternalCardId, b.FrontOrBack, ",		\
@"b.TitleData, a.fk_FlashCardDeckId, a.ISKnown, a.ISBookMarked,a.CardName from m_FlashCard a, ",	\
@"m_FlashCardFrontBackDetails b where a.pk_FlashCardId = b.fk_FlashCardId ",			\
@"and (a.ISBookMarked = 1 or a.ISVoiceNote = 1 or ISTextNote = 1)) m LEFT OUTER JOIN m_FlashCardInternalDetails p ", \
@"on m.pk_FlashCardId = p.fk_FlashCardId"]
typedef enum tagCardDeckType
{
	kCardDeckTypeAlfabaticallly = 0,
	kCardDeckTypeBookMark,
    kCardDeckTypeTodayReading,
	kCardDeckTypeAll,
    kIntroDeck
	
}CardDeckType;


typedef enum tagContentType
{
	kContentTypeSetting = 0,
    kcontentTypeIntro,
    kcontentTypeBeforeCard,
    kcontentTypeAfterCard,
	kContentTypeHelp,
	kContentTypeInfo,
	kContentTypeVoiceNotes,
	kContentTypeComments
	
}ContentType;

typedef enum tagCardType
{
	kCardTypeNone = 0,
	kCardTypeFront,
	kCardTypeBack
	
}CardType;

typedef enum tagResourceType
{
	kResourceTypeNone = 0,
	kResourceTypeText,
	kResourceTypeAudio,
	kResourceTypeVedio,
	kResourceTypeImage
	
}ResourceType;

