//
//  IndexViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "IndexViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "FlashCard.h"
#import "CardDetails_iPhone.h"
#import "DBAccess.h"
#import "StringHelper.h"
#import "RCLabel.h"
#import "UIFont+Font.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation IndexViewController_iPhone

@synthesize _tableView;
@synthesize cards;
@synthesize indices;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title=@"Cards Index";
	
    UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 20)];
    [leftButtonImg setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
    
    [leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    
    self.navigationItem.leftBarButtonItem=leftButton;
	
	//_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
	
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	cards=[db getCardsByAlphabets];
	indices=[[NSMutableArray alloc] init];
	
	for(int i=0;i<[cards count];i++){
		
		char alphabet = [[cards objectAtIndex:i] characterAtIndex:0];
       /* if(alphabet=='<')
        {
        alphabet = [[cards objectAtIndex:i] characterAtIndex:3];
        }*/
		NSString *uniChar = [NSString stringWithFormat:@"%c", alphabet];
		if (![indices containsObject:uniChar.uppercaseString])
        {            
            [indices addObject:uniChar.uppercaseString];
        } 
	}
   //[indices sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
}


- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source
NSArray *flashCards;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [indices count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	NSString *alphabet = [indices objectAtIndex:section];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
    flashCards = [cards filteredArrayUsingPredicate:predicate];
	//DBAccess* db=[AppDelegate_iPhone getDBAccess];
	//NSMutableArray *flashCards=[db getCardsByAlphabet:alphabet];
	NSLog(@"Alphabet : %@, Section : %ld, Rows : %lu",alphabet, (long)section,(unsigned long)[flashCards count]);
    return [flashCards count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [indices objectAtIndex:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] autorelease];
		
		//cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.929 blue:0.592 alpha:1.0];
		cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];
		/*cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"all_cards_bg.png"]] autorelease];*/
		
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]colorWithAlphaComponent:0.2]];
        
        [cell setSelectedBackgroundView:bgColorView];
        [bgColorView release];
		UIImage* myImage=[UIImage imageNamed:@"arrow.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		[cell setAccessoryView:imageView];
		
	}
	
	NSString *alphabet = [indices objectAtIndex:[indexPath section]];
	
    //---get all states beginning with the letter---
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
    NSArray *flashCards = [cards filteredArrayUsingPredicate:predicate];
    NSLog(@"For alphabet %@, no. of cards : %lu",alphabet,(unsigned long)[flashCards count]);
	if ([flashCards count]>0) {
		//---extract the relevant state from the states object---
        NSString *cellValue = [flashCards objectAtIndex:indexPath.row];
        NSUInteger count = 0,count1 = 0, length = [cellValue length];
        NSRange range = NSMakeRange(0, length);
        while(range.location != NSNotFound)
        {
            range = [cellValue rangeOfString: @"<i>" options:0 range:range];
            if(range.location != NSNotFound)
            {
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count++; 
            }
        }
        range = NSMakeRange(0, length);
        while(range.location != NSNotFound)
        {
            range = [cellValue rangeOfString: @"</i>" options:0 range:range];
            if(range.location != NSNotFound)
            {
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count1++;
            }
        }
        NSString* newStr;
        if(count1>count)
        {
        newStr=[@"<i>" stringByAppendingString:[self stringByDecodingHTMLEntitiesInString:cellValue]];
        }
        else
        {
        newStr=[self stringByDecodingHTMLEntitiesInString:cellValue];
        }
        
        
        
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 150, 30)];
        label1.font=[UIFont RobotoBoldFont:18.0f];
        label2.font=[UIFont RobotoRegularFont:15.0f];
        newStr = [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray* cellData = [newStr componentsSeparatedByString: @" - "];
        // NSString* newStr=[self stringByDecodingHTMLEntitiesInString:str];
        label1.text = [cellData objectAtIndex: 0];
        label2.text = [cellData objectAtIndex: 1];
        
        label1.textColor=[UIColor blackColor];
        label2.textColor=[UIColor blackColor];
        if ([cell.contentView subviews]){
            for (UIView *subview in [cell.contentView subviews]) {
                [subview removeFromSuperview];
            }
        }
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        //cell.textLabel.text = cellValue;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.backgroundColor=[UIColor clearColor];
        cellValue=nil;
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
	
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize labelSize = CGSizeMake(272.0f, 20.0);
    if ([cards count]!=0) {
        NSString * strCardName=[cards objectAtIndex:indexPath.row];
        if ([strCardName length] > 0)
            labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 16.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
    }
    //return 30.0 + labelSize.height;
    return 50.0;
}



//---set the index for the table---
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indices;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	
	NSMutableArray* deckArray=[db getFlashCardForQuery:SELECT_Alphabetical_DECK_CARD_QUERY];
	CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
	 detail.arrCards=deckArray;
	// Calculate Row index.
	NSUInteger row = 0;
	 NSUInteger sect = indexPath.section;
	 for (NSUInteger i = 0; i < sect; ++ i)
	 {
		 NSLog(@"No. of rows in section %d is %d",i,[_tableView numberOfRowsInSection:i]);
		row += [_tableView numberOfRowsInSection:i];
	 }
	 row += indexPath.row;
	detail._selectedCardIndex=row;
	[self.navigationController pushViewController:detail animated:YES];
	
	//[detail loadArrayOfCards:deckArray];
	[detail release];
	
}

- (NSString *)stringByDecodingHTMLEntitiesInString:(NSString *)input {
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

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[super dealloc];
}


@end

