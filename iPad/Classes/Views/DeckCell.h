//
//  DeckCell.h
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringHelper.h"
@class FlashCardDeck;

@interface DeckCell : UITableViewCell 
{
	FlashCardDeck*		_deck;
}

+ (DeckCell*) creatCellViewWithFlashCardDeck:(FlashCardDeck*) deck withTextColor:(UIColor*) textColor;

@end
