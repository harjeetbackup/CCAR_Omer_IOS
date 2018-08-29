//
//  CardList.h
//  SchlossExtra
//
//  Created by Chandan Kumar on 16/08/11.
//  Copyright 2011 Interglobe Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_iPhone.h"

@interface CardListIPhone : UIViewController {
	
	NSMutableArray* arrCards;
	IBOutlet UITableView* tblCardNames;
}


@property (nonatomic, retain) NSMutableArray* arrCards;
@property (nonatomic,retain) IBOutlet UITableView*	tblCardNames;
@property (retain, nonatomic) IBOutlet UIView *listView;

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;
- (void) showCardsForDeck:(int) DeckId;
- (void) showAllCards;
- (void) showTodayReading;
- (void) showBookmarkCards;
- (void)popView;
@end
