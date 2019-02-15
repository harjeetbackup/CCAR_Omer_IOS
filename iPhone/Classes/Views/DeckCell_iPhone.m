//
//  DeckCell.m
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlashCard.h"
#import "UIFont+Font.h"
#import "DeckCell_iPhone.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "RCLabel.h"
#import "StringHelper.h"
@implementation DeckCell_iPhone

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
	  flashCardDeck:(FlashCardDeck*) deck
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		_deck = deck;
    }
    return self;
}

+ (UILabel*) createLabelWithRect:(CGRect)rect  withFontSize:(NSUInteger)fontSize onView:(UIView*) view
{
	UILabel* label = [[UILabel alloc] initWithFrame:rect];
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:fontSize];
	[view addSubview:label];
	return [label autorelease];
}

+ (NSString *)stringByDecodingHTMLEntitiesInString:(NSString *)input {
    NSMutableString *results = [NSMutableString string];
    NSScanner *scanner = [NSScanner scannerWithString:input];
    [scanner setCharactersToBeSkipped:nil];
    while (![scanner isAtEnd]) {
        NSString *temp;
        if ([scanner scanUpToString:@"&" intoString:&temp]) {
            [results appendString:temp];
        }
        if ([scanner scanString:@"&" intoString:NULL]) {
            BOOL valid = YES;
            unsigned c = 0;
            NSUInteger savedLocation = [scanner scanLocation];
            if ([scanner scanString:@"#" intoString:NULL]) {
                // it's a numeric entity
                if ([scanner scanString:@"x" intoString:NULL]) {
                    // hexadecimal
                    unsigned int value;
                    if ([scanner scanHexInt:&value]) {
                        c = value;
                    } else {
                        valid = NO;
                    }
                } else {
                    // decimal
                    int value;
                    if ([scanner scanInt:&value] && value >= 0) {
                        c = value;
                    } else {
                        valid = NO;
                    }
                }
                if (![scanner scanString:@";" intoString:NULL]) {
                    // not ;-terminated, bail out and emit the whole entity
                    valid = NO;
                }
            } else {
                if (![scanner scanUpToString:@";" intoString:&temp]) {
                    // &; is not a valid entity
                    valid = NO;
                } else if (![scanner scanString:@";" intoString:NULL]) {
                    // there was no trailing ;
                    valid = NO;
                } else if ([temp isEqualToString:@"amp"]) {
                    c = '&';
                } else if ([temp isEqualToString:@"quot"]) {
                    c = '"';
                } else if ([temp isEqualToString:@"lt"]) {
                    c = '<';
                } else if ([temp isEqualToString:@"gt"]) {
                    c = '>';
                } else {
                    // unknown entity
                    valid = NO;
                }
            }
            if (!valid)
            {
                // we errored, just emit the whole thing raw
                [results appendString:[input substringWithRange:NSMakeRange(savedLocation, [scanner scanLocation]-savedLocation)]];
            }
            else
            {
                [results appendFormat:@"%C", (unichar)c];
            }
        }
    }
    return results;
}
+ (DeckCell_iPhone*) creatCellViewWithFlashCardDeck:(FlashCardDeck*) deck withTextColor:(UIColor*) textColor
{
    DeckCell_iPhone* cell = [[[DeckCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil flashCardDeck:deck] autorelease];
    
    UIImageView* imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:deck.deckImage]] autorelease];
    imgView.frame = CGRectMake(15, 10, 30, 30);
    
    //  cell.accessoryView = [[[UIImageView alloc] initWithImage:
    //        [UIImage imageNamed:@"arrow.png"]] autorelease];
    cell.userInteractionEnabled=YES;
    
    if(deck.deckId>0 && deck.deckId<8)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:deck.deckImage] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    }
    else
    {
        [cell.contentView addSubview:imgView];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 150, 30)]; //[DeckCell createLabelWithRect:CGRectMake(50, 8, 290, 40) withFontSize:14 onView:cell];
        
        NSString* newStr=deck.deckTitle;//[self stringByDecodingHTMLEntitiesInString:deck.deckTitle];
        
        newStr = [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        label = [newStr Answer_newSizedCellLabelWithSystemFontOfSize:20];
        int deckProf = (int) deck.proficiency;
        
        label.textColor=[UIColor whiteColor];
        
        [cell.contentView addSubview:label];
        if([deck.deckTitle isEqualToString:@"All Cards"])
        {
            UIImageView* readImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"read_icon"]] autorelease];
            readImgView.frame = CGRectMake(200, 12, 30, 30);
            UILabel* readLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 12, 130, 30)];
            readLabel.text = [NSString stringWithFormat:@"Read: %d%@", deckProf, @"%"];
            readLabel.font =[UIFont RobotoRegularFont:20.0f];
            readLabel.textColor=[UIColor whiteColor];
            [cell.contentView addSubview:readImgView];
            [cell.contentView addSubview:readLabel];
        }
    }

    return cell;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc 
{
    [super dealloc];
}


@end
