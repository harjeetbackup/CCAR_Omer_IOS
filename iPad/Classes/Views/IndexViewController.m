//
//  IndexViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "IndexViewController.h"
#import "AppDelegate_iPad.h"
#import "FlashCard.h"
#import "CardDetails.h"
#import "DBAccess.h"
#import "StringHelper.h"
#import "RCLabel.h"
#import "UIFont+Font.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation IndexViewController
{
    UILabel* lblHeader ;
    NSString* backgroundImageName;
}
@synthesize _tableView;
@synthesize cards;
@synthesize indices;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forDeck:(FlashCardDeck *)objDeck 
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	// Create a transparent label for showing the header
	lblHeader = [[[UILabel alloc] initWithFrame:CGRectMake(66, 8, 500, 25)] autorelease];
	lblHeader.backgroundColor = [UIColor clearColor];
	[lblHeader setTextAlignment:UITextAlignmentCenter];
    [lblHeader setFont:[UIFont RobotoBoldFont:18]];
    lblHeader.textColor=[UIColor whiteColor];
	// Check whether the call has been made from the index button on deck view controller or the click of the card deck
   // _backgroundImage.frame = CGRectMake(380, 0, UIScreen.mainScreen.bounds.size.width - 380, UIScreen.mainScreen.bounds.size.height);
	if (objDeck != nil) {
		// Set the label text to the title of the deck and also get the list of cards for that deck
		//lblHeader.text= objDeck.deckTitle;
        if(objDeck.deckId==1)
        {
            backgroundImageName=@"week1_bg.png";
        }
        else if(objDeck.deckId==2)
        {
            backgroundImageName=@"week2_bg.png";
        }
        else if(objDeck.deckId==3)
        {
           backgroundImageName=@"week3_bg.png";
        }
        else if(objDeck.deckId==4)
        {
            backgroundImageName=@"week4_bg.png";
        }
        else if(objDeck.deckId==5)
        {
           backgroundImageName=@"week5_bg.png";
        }
        else if(objDeck.deckId==6)
        {
            backgroundImageName=@"week6_bg.png";
        }
        else if(objDeck.deckId==7)
        {
            backgroundImageName=@"week7_bg.png";
        }
        else
            backgroundImageName=@"";
        NSString* title = [[objDeck.deckTitle stringByReplacingOccurrencesOfString:@"<i>" withString:@""] stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
        lblHeader.text = title;//[self stringByDecodingHTMLEntitiesInString:title];
		cards = [[objDeck getCardsList] retain];
		if([AppDelegate_iPad delegate].isRandomCard == 1)
		{
			[Utils randomizeArray:cards];
		}
		_source = @"DeckCard";
		indices = [[NSMutableArray alloc] initWithObjects:@"   ",nil];

	}
	else 
	{
		// Header is set and
        backgroundImageName=@"";
		lblHeader.text=@"Cards Index";
        [lblHeader setFont:[UIFont RobotoBoldFont:18]];

		//_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
		cards=[[AppDelegate_iPad getDBAccess] getCardsByAlphabets];
		indices=[[NSMutableArray alloc] init];
		char alphabet;
        NSString *uniChar;
		for(int i=0;i<[cards count];i++)
		{
			alphabet = [[cards objectAtIndex:i] characterAtIndex:0];
			uniChar = [NSString stringWithFormat:@"%c", alphabet];
			if (![indices containsObject:uniChar.uppercaseString])
			{            
				[indices addObject:uniChar.uppercaseString];
			}
               
		}
    [indices addObject:@""];
    [indices addObject:@""];
     
	}
   lblHeader.tag = 1;
    if([self.view viewWithTag:1]!=nil)
    {
        [[self.view viewWithTag:1] removeFromSuperview];
    }
	[self.view addSubview:lblHeader];

	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.view.backgroundColor=[UIColor clearColor];
    if([backgroundImageName isEqualToString:@""])
    {
    self._tableView.backgroundColor=[UIColor grayColor];
    self._tableView.separatorColor=[UIColor whiteColor];
    }
    else
    {
        self._tableView.backgroundColor=[UIColor clearColor];
     self.backgroundImage.image=[UIImage imageNamed:backgroundImageName];
        self._tableView.separatorColor=[UIColor whiteColor];
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
      [self.myButton setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
        
        /*CGRect myFrameTableHeight = _tableView.frame;
        myFrameTableHeight.size.height = 500;
        _tableView.frame = myFrameTableHeight;*/
       // CGRect myFrameImg = _tableView.frame;
        // myFrame.origin.x = 634;
      //  myFrameImg.origin.y = -500;
       // myFrameImg.size.height = 200;
        //_tableView.frame=CGRectMake(0, 0, 700, 700);

    }
    else
    {
        [self.myButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    }
    
}

-(void) setParentViewCtrl:(DeckViewController*) parentView{
	_parentView=parentView;
}


-(IBAction) closeIndex:(id)sender{
	[self.view removeFromSuperview];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	int iSectionCount = -1;
	if ([_source isEqualToString:@"DeckCard"]) 
	{
		iSectionCount = 1;
	}
	else {
		iSectionCount = [indices count];
	}

	return iSectionCount;
}

//declaring all the variables for table view
NSString *alphabet;
NSPredicate *predicate;
NSArray *flashCards ;
NSString * strCardName;
CGSize labelSize;
NSString* strHeaderTitle = @"";
CGRect tableRect;
Card* card;
//==============================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int iRowSCount = -1;
    if ([_source isEqualToString:@"DeckCard"]) {
		iRowSCount = [cards count];
	}
	else {
		alphabet = [indices objectAtIndex:section];
		predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
		flashCards = [cards filteredArrayUsingPredicate:predicate];
		iRowSCount = [flashCards count];
	}
    return iRowSCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
    return 50;
}
- (CGFloat) tableView: (UITableView *) tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat) tableView: (UITableView *) tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	
	if ([_source isEqualToString:@"DeckCard"]) {
		strHeaderTitle = @" ";
	}
	else {
		strHeaderTitle = [indices objectAtIndex:section];
	}

	return strHeaderTitle;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableRect = self.view.frame;
	tableRect.origin.x = 0;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        tableRect.origin.y = 8;
    }
	//tableView.frame = tableRect;
   
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImage* myImage;
    UIImageView *imageView;
     UIView *bgColorView = [[[UIView alloc] init] autorelease];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] autorelease];
		
        //cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];
      
        [bgColorView setBackgroundColor:[[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]colorWithAlphaComponent:0.2]];
        
        [cell setSelectedBackgroundView:bgColorView];
        
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		
		myImage=[UIImage imageNamed:@"arrow.png"];
		
		imageView = [[[UIImageView alloc] initWithImage:myImage] autorelease];
		//[cell setAccessoryView:imageView];
	}
	
	if ([_source isEqualToString:@"DeckCard"]) {
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]colorWithAlphaComponent:0.4]];
        
        [cell setBackgroundView:bgColorView];
		Card* card = (Card *)[[cards objectAtIndex:indexPath.row] getCardOfType: kCardTypeFront] ;
		NSString *cellValue = card.cardName;
     
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
     
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 100, 30)];
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(400, 10, 200, 30)];
        label1.font=[UIFont RobotoBoldFont:21.0f];
        label2.font=[UIFont RobotoRegularFont:18.0f];
        newStr = [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray* cellData = [newStr componentsSeparatedByString: @" - "];
        // NSString* newStr=[self stringByDecodingHTMLEntitiesInString:str];
        label1.text = [cellData objectAtIndex: 0];
        label2.text = [cellData objectAtIndex: 1];
     /*   if([backgroundImageName isEqualToString:@""])
        {
        label1.textColor=[UIColor blackColor];
        label2.textColor=[UIColor blackColor];
        }
        else
        {*/
            label1.textColor=[UIColor whiteColor];
            label2.textColor=[UIColor whiteColor];
       // }
        if ([cell.contentView subviews]){
            for (UIView *subview in [cell.contentView subviews]) {
                [subview removeFromSuperview];
            }
        }
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        cell.backgroundColor=card.cardColor;
        
       // cell.textLabel.text = cellValue;
		//cell.textLabel.numberOfLines = 0;
		//cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellValue=nil;
	}
	else
	{
		alphabet = [indices objectAtIndex:[indexPath section]];
		
		//---get all states beginning with the letter---
		predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
        flashCards = [cards filteredArrayUsingPredicate:predicate];
		
		if ([flashCards count]>0) {
			//---extract the relevant state from the states object---
			NSString *cellValue = [flashCards objectAtIndex:indexPath.row];
            NSString* newStr=[self stringByDecodingHTMLEntitiesInString:cellValue];
            
            UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 100, 30)];
            UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(400, 10, 200, 30)];
            label1.font=[UIFont RobotoBoldFont:21.0f];
            label1.font=[UIFont RobotoRegularFont:18.0f];
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
		}
	}
    
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    return cell;
}



//---set the index for the table---
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indices;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray* deckArray;
	NSUInteger row = 0;
	if ([_source isEqualToString:@"DeckCard"]) {
		deckArray = [cards retain];
		row = indexPath.row;
        [cards release];
        }
    
	else
	{
		deckArray=[[AppDelegate_iPad getDBAccess] getFlashCardForQuery:SELECT_Alphabetical_DECK_CARD_QUERY];
		// Calculate Row index.
		NSUInteger sect = indexPath.section;
		for (NSUInteger i = 0; i < sect; ++ i)
			row += [_tableView numberOfRowsInSection:i];
		row += indexPath.row;
	}
    [self._tableView reloadData];
	[_parentView showDetailViewWithArray:deckArray cardIndex:row caller:@"index"];  	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
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
    [_myButton release];
    [_backgroundImage release];
	[super dealloc];  
}


- (void)viewDidUnload {
    [self setMyButton:nil];
    [super viewDidUnload];
}
@end

