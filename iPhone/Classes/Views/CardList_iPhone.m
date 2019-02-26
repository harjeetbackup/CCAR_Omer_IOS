//
//  CardList.m
//  SchlossExtra
//
//  Created by Chandan Kumar on 16/08/11.
//  Copyright 2011 Interglobe Technologies. All rights reserved.
//

#import "CardList_iPhone.h"
#import "CardDetails_iPhone.h"
#import "FlashCard.h"
#import "DBAccess.h"
#import "StringHelper.h"
#import "RCLabel.h"
#import "UIFont+Font.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation CardListIPhone
{
    UILabel *lblDeckName ;
    FlashCardDeck* objFlashCardDeck;
     NSString* backgroundImageName;
}
@synthesize arrCards;
@synthesize tblCardNames;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tblCardNames.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);

    if(![backgroundImageName isEqualToString:@""])
    {
    self.tblCardNames.backgroundColor=[UIColor clearColor];
         self.backgroundImage.image=[UIImage imageNamed:backgroundImageName];
    }
    else
    self.tblCardNames.backgroundColor=[UIColor grayColor];
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
    
}

-(void)viewDidAppear:(BOOL)animated

{
    
    if ([arrCards count]==0) {
		[self popView];
	}
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void) showCardsForDeck:(int) iDeckId
{
    if(iDeckId==1)
    {
        backgroundImageName=@"week1_bg_iPhone.png";
    }
    else if(iDeckId==2)
    {
        backgroundImageName=@"week2_bg_iPhone.png";
    }
    else if(iDeckId==3)
    {
        backgroundImageName=@"week3_bg_iPhone.png";
    }
    else if(iDeckId==4)
    {
        backgroundImageName=@"week4_bg_iPhone.png";
    }
    else if(iDeckId==5)
    {
        backgroundImageName=@"week5_bg_iPhone.png";
    }
    else if(iDeckId==6)
    {
        backgroundImageName=@"week6_bg_iPhone.png";
    }
    else if(iDeckId==7)
    {
        backgroundImageName=@"week7_bg_iPhone.png";
    }
    else
        backgroundImageName=@"";
   
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	objFlashCardDeck = [db getFlashCardDeckByDeckId:iDeckId];
	lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
	[lblDeckName setTextAlignment:UITextAlignmentCenter];
	[lblDeckName setBackgroundColor:[UIColor clearColor]];
	[lblDeckName setTextColor:[UIColor whiteColor]];
	[lblDeckName setFont:[UIFont RobotoBoldFont:18]];
   
    NSString* title = [[objFlashCardDeck.deckTitle stringByReplacingOccurrencesOfString:@"<i>" withString:@""] stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
    lblDeckName.text = title;//[self stringByDecodingHTMLEntitiesInString:title];
   
	self.navigationItem.titleView = lblDeckName;
	[lblDeckName release];
	
    UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 20)];
    
    [leftButtonImg setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
    
    [leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    
    self.navigationItem.leftBarButtonItem=leftButton;
	
	//self.navigationItem.title = objFlashCardDeck.deckTitle;
	arrCards = [[db getCardListForDeckType:kCardDeckTypeAlfabaticallly withId:iDeckId] retain];
	if([AppDelegate_iPhone delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:arrCards];
	}
	
}
- (void) showAllCards
{
    
    backgroundImageName=@"";
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	
	lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
	[lblDeckName setTextAlignment:UITextAlignmentCenter];
	[lblDeckName setBackgroundColor:[UIColor clearColor]];
	[lblDeckName setTextColor:[UIColor whiteColor]];
	[lblDeckName setFont:[UIFont systemFontOfSize:20]];
    
	lblDeckName.text = @"All Cards";
	self.navigationItem.titleView = lblDeckName;
	[lblDeckName release];
	
    UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 20)];
    
    [leftButtonImg setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
    
    [leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    
    self.navigationItem.leftBarButtonItem=leftButton;
    
	//self.navigationItem.title = objFlashCardDeck.deckTitle;
	arrCards = [[db getCardListForDeckType:kCardDeckTypeAll withId:0] retain];
	if([AppDelegate_iPhone delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:arrCards];
	}
	
}

- (void) showTodayReading
{
   
    backgroundImageName=@"";
    DBAccess* db=[AppDelegate_iPhone getDBAccess];
    
    lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
    [lblDeckName setTextAlignment:UITextAlignmentCenter];
    [lblDeckName setBackgroundColor:[UIColor clearColor]];
    [lblDeckName setTextColor:[UIColor whiteColor]];
    lblDeckName.font = [UIFont systemFontOfSize:20];
    
    lblDeckName.text = @"Today's Reading";
    self.navigationItem.titleView = lblDeckName;
    [lblDeckName release];
    
    UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 20)];
    
    [leftButtonImg setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
    
    [leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    
    self.navigationItem.leftBarButtonItem=leftButton;
    
    //self.navigationItem.title = objFlashCardDeck.deckTitle;
    arrCards = [[db getCardListForDeckType:kCardDeckTypeTodayReading withId:0] retain];
    if([AppDelegate_iPhone delegate].isRandomCard == 1)
    {
        [Utils randomizeArray:arrCards];
    }
    
}

- (void) showBookmarkCards
{
   
    backgroundImageName=@"";
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
    
	lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
	[lblDeckName setTextAlignment:UITextAlignmentCenter];
	[lblDeckName setBackgroundColor:[UIColor clearColor]];
	[lblDeckName setTextColor:[UIColor whiteColor]];
	[lblDeckName setFont:[UIFont systemFontOfSize:20]];
   
    
	lblDeckName.text = @"Bookmarks & Notes";
	self.navigationItem.titleView = lblDeckName;
	[lblDeckName release];
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 20)];
   
        [leftButtonImg setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
    
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
   
        self.navigationItem.leftBarButtonItem=leftButton;
    
	
	//self.navigationItem.title = objFlashCardDeck.deckTitle;
	arrCards = [[db getCardListForDeckType:kCardDeckTypeBookMark withId:0] retain];
	if([AppDelegate_iPhone delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:arrCards];
	}
	
}

- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	// Return the number of rows in the section.
    if ([arrCards count]==0) {
		return 1;
	}
	
	return [arrCards count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      //  cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kCardListColor]];
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]colorWithAlphaComponent:0.4]];
        
        [cell setBackgroundView:bgColorView];
        [bgColorView release];
        UIView *bgSelectedColorView = [[UIView alloc] init];
        [bgSelectedColorView setBackgroundColor:[[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]colorWithAlphaComponent:0.1]];
        
        [cell setSelectedBackgroundView:bgSelectedColorView];
        [bgSelectedColorView release];
	}
    
	FlashCard* card=(FlashCard*)[arrCards objectAtIndex:indexPath.row];
    	NSString *cellValue = [card cardName];
    
	//cell.textLabel.text = cellValue;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        UIImage* myImage=[UIImage imageNamed:@"arrow.png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
        
        [cell setAccessoryView:imageView];
    }
    else
    {
        UIImage* myImage=[UIImage imageNamed:@"arrow.png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];

        [cell setAccessoryView:imageView];
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    NSString* newStr=[self stringByDecodingHTMLEntitiesInString:cellValue];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 150, 30)];
    label1.font=[UIFont RobotoBoldFont:20.0f];
    label2.font=[UIFont RobotoRegularFont:18.0f];
    newStr = [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray* cellData = [newStr componentsSeparatedByString: @" - "];
    // NSString* newStr=[self stringByDecodingHTMLEntitiesInString:str];
    label1.text = [cellData objectAtIndex: 0];
    label2.text = [cellData objectAtIndex: 1];
  /*  if([backgroundImageName isEqualToString:@""])
    {
        label1.textColor=[UIColor blackColor];
        label2.textColor=[UIColor blackColor];
    }
    else
    {*/
        label1.textColor=[UIColor whiteColor];
        label2.textColor=[UIColor whiteColor];
 //   }
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    [cell.contentView addSubview:label1];
    [cell.contentView addSubview:label2];
    cell.backgroundColor=[UIColor clearColor];
    // cell.textLabel.text = cellValue;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cellValue=nil;
   // int a = arrCards.count;
   
    return cell;
}
- (CGFloat) tableView: (UITableView *) tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat) tableView: (UITableView *) tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}
- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return 50.0;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([arrCards count]==0) {
		return;
	}
	
	CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
    detail.arrCards=arrCards;
    detail._selectedCardIndex = indexPath.row;
    detail.basicCall = NO;
	[self.navigationController pushViewController:detail animated:YES];
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_listView release];
    [_backgroundImage release];
	[super dealloc];
}


@end
