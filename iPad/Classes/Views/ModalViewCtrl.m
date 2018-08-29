//
//  ModalViewCtrl.m
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBAccess.h"
#import "DeckViewController.h"
#import "AppDelegate_iPad.h"
#import "Appirater.h"
#import "CardDetails.h"

#import "ModalViewCtrl.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)




@implementation ModalViewCtrl


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentType:(ContentType) type
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		_contentType = type;
	}
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		_contentType = type;
	}
	
	_settingButtons=[[NSMutableArray alloc] init];
	if([[[Utils getValueForVar:kProficiencyEnable] lowercaseString] isEqualToString: @"yes"])
    {
	[_settingButtons addObject:@"Clear All Proficiency"];
    }
	[_settingButtons addObject:@"Clear All Bookmarks"];
	
	if ([AppDelegate_iPad delegate].isVoiceNotesEnabled) {
		[_settingButtons addObject:@"Clear All Voice Notes"];
	}

	if ([AppDelegate_iPad delegate].isCommentsEnabled) {
		[_settingButtons addObject:@"Clear All Text Notes"];
	}
	
	[_settingButtons addObject:@"Reset Application"];
    if([[[Utils getValueForVar:kisAppRating] lowercaseString] isEqualToString: @"yes"])
    {
	[_settingButtons addObject:@"Application Rating"];
	}
    return self;
}

- (void) setParentCtrl: (DeckViewController*) ctrl;
{
	_parentCtrl = ctrl;
}



- (void)viewDidLoad 
{	
	
	[super viewDidLoad];
	
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [self.settingButton setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
        //_tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backNew_1.png"]];
    }
    else
    {
        [self.settingButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
       // [_tableView.backgroundView :[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    }

	//_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow_bg_iPad.png"]] autorelease];
	_tableView.backgroundColor=[UIColor clearColor];
	//NSURL *localFile;
    NSString *fileName;
    NSURLRequest *request;
	switch(_contentType)
	{
		case kContentTypeSetting:
			//_navItem.title = @"Settings";
            _titleLabel.text=@"Settings";
			_tableView.hidden = NO;
			_webView.hidden = YES;
			break;
			
        case kcontentTypeIntro:
           // _navItem.title = @"Introduction";
            _titleLabel.text=@"Introduction";
            fileName = [[NSBundle mainBundle] pathForResource:@"intro.html" ofType:nil inDirectory:nil];
            request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fileName]];
            self.settingButton.hidden=YES;
            [_webView loadRequest:request];
            _webView.scalesPageToFit=YES;
			//[_webView loadHTMLString:[[AppDelegate_iPhone getDBAccess] GetHelpString] baseURL:nil];
			_tableView.hidden = YES;
			_webView.hidden = NO;
			break;
        case kcontentTypeBeforeCard:
            _titleLabel.text=@"Before Omer";
            fileName = [[NSBundle mainBundle] pathForResource:@"beforecard.html" ofType:nil inDirectory:nil];
            request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fileName]];
            self.settingButton.hidden=YES;
            [_webView loadRequest:request];
            _webView.scalesPageToFit=YES;
            //[_webView loadHTMLString:[[AppDelegate_iPhone getDBAccess] GetHelpString] baseURL:nil];
            _tableView.hidden = YES;
            _webView.hidden = NO;
            break;
        case kcontentTypeAfterCard:
           
            _titleLabel.text=@"After Omer";
            fileName = [[NSBundle mainBundle] pathForResource:@"aftercard.html" ofType:nil inDirectory:nil];
            request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fileName]];
            self.settingButton.hidden=YES;
            [_webView loadRequest:request];
            _webView.scalesPageToFit=YES;
            //[_webView loadHTMLString:[[AppDelegate_iPhone getDBAccess] GetHelpString] baseURL:nil];
            _tableView.hidden = YES;
            _webView.hidden = NO;
            break;
            
		case kContentTypeHelp:
			//_navItem.title = @"Help";
            _titleLabel.text=@"Help";
            fileName = [[NSBundle mainBundle] pathForResource:@"help.html" ofType:nil inDirectory:nil];          
            request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fileName]];

            [_webView loadRequest:request];
            _webView. scalesPageToFit=YES;
			//[_webView loadHTMLString:[[AppDelegate_iPad getDBAccess] GetHelpString] baseURL:nil];
			_tableView.hidden = YES;
			_webView.hidden = NO;
			break;
			
		case kContentTypeInfo:
			//_navItem.title = @"Info";
            _titleLabel.text=@"Info";
            fileName = [[NSBundle mainBundle] pathForResource:@"info.html" ofType:nil inDirectory:nil];
            request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fileName]];
            
            [_webView loadRequest:request];
            _webView. scalesPageToFit=YES;
			//[_webView loadHTMLString:[[AppDelegate_iPad getDBAccess] GetHelpString] baseURL:nil];
			_tableView.hidden = YES;
			_webView.hidden = NO;
			break;
	}	
	if ([[[Utils getValueForVar:kRandomOption] lowercaseString] isEqualToString:@"yes"]) {
		_isRandomOption = YES;
	}
	else {
		_isRandomOption = NO;
	}

	
}

- (IBAction) done:(id) sender
{
	//[self dismissModalViewControllerAnimated:YES];
	[self.view removeFromSuperview];
	[(CardDetails *)_parentCtrl._detail updateNavBar];
	
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	[_webView release];
	[_tableView release];
    [_settingButton release];
    [_titleLabel release];
    [super dealloc];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    }
    
    return true;
}

#pragma mark -
#pragma mark UITableView delegates
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	if(_isRandomOption == YES)
	{
		return [_settingButtons count]+1;
	}
	return [_settingButtons count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]];
   // [cell setSelectedBackgroundView:bgColorView];
    [bgColorView release];

	if (indexPath.row < [_settingButtons count])
	{
		cell.textLabel.font = [UIFont systemFontOfSize:20];
		
		cell.backgroundColor = [UIColor clearColor];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            cell.backgroundView  = [[[UIImageView alloc]
                                     initWithImage:[UIImage imageNamed:@""]] autorelease];

        }
        else{
		cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"grey_btn.png"]] autorelease];
        }
		
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.text=[_settingButtons objectAtIndex:indexPath.row];
	}
/*	else if(_isRandomOption == YES)
	{
		cell.textLabel.font = [UIFont systemFontOfSize:20];
		
		cell.backgroundColor = [UIColor clearColor];
		
		cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"grey_btn.png"]] autorelease];	
		UILabel *objLabelRandom = [[[UILabel alloc] initWithFrame:CGRectMake(200,17,180,25)] autorelease];
		objLabelRandom.font = [UIFont systemFontOfSize:20];
		objLabelRandom.backgroundColor = [UIColor clearColor];
		objLabelRandom.text = @"Randomize Blessings";
		UISwitch *objSwitchRandom=[[[UISwitch alloc] initWithFrame:CGRectMake(380,17,100,25)] autorelease];
		objSwitchRandom.tag=20;
		int iRandom = [AppDelegate_iPad delegate].isRandomCard;	
		if (iRandom == 1) 
		{
			objSwitchRandom.on = YES;
		}
		else 
		{
			objSwitchRandom.on = NO;
		}
		objSwitchRandom.enabled =  YES;
		[objSwitchRandom addTarget:self action:@selector(switchRandomChange:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview:objLabelRandom];
		[cell addSubview:objSwitchRandom];
		//[objSwitchRandom release];
	}
	*/
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row < [_settingButtons count]) {
		NSString* button=[_settingButtons objectAtIndex:indexPath.row];
		
		if ([button isEqualToString:@"Clear All Proficiency"]) {
			
			UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to reset all proficiencies?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			alert.tag = 0;
			[alert show];
			[alert release];
			
		}else if ([button isEqualToString:@"Clear All Bookmarks"]) {
			
			UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to reset all bookmarks?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			alert.tag = 1;
			[alert show];
			[alert release];
			
		}else if ([button isEqualToString:@"Clear All Voice Notes"]) {
			
			UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to reset all voice notes?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			alert.tag = 3;
			[alert show];
			[alert release];
			
		}else if ([button isEqualToString:@"Clear All Text Notes"]) {
			
			UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to reset all Text Notes?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			alert.tag = 2;
			[alert show];
			[alert release];
			
		}else if ([button isEqualToString:@"Reset Application"]) {
			
			UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to reset application contents?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			alert.tag = 4;
			[alert show];
			[alert release];
			
		}else if ([button isEqualToString:@"Application Rating"]) {
			
			[Appirater rateApp];
			
		}
	
	}
}

#pragma mark -
#pragma mark UIAlertView Delagates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		switch (alertView.tag) 
		{
			case 0:
				[[AppDelegate_iPad getDBAccess] clearAllProficiency];
				[(CardDetails *) _parentCtrl._detail resetKnownUnknown];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedCards" object:nil userInfo:nil];
				break;
				
			case 1:
				[[AppDelegate_iPad getDBAccess] clearAllBookmarkedCards];
				[(CardDetails *) _parentCtrl._detail resetBookmarked];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedCards" object:nil userInfo:nil];
				break;
				
			case 2:
				[[AppDelegate_iPad getDBAccess] clearAllComments];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedComments" object:nil userInfo:nil];
				break;
				
			case 3:
				
				[[AppDelegate_iPad getDBAccess] clearAllVoiceNotes];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedVoiceNotes" object:nil userInfo:nil];
				break;
				
			case 4:
				
				[[AppDelegate_iPad getDBAccess] clearAllBookmarkedCards];
				[[AppDelegate_iPad getDBAccess] clearAllProficiency];
				[[AppDelegate_iPad getDBAccess] clearAllComments];
				[[AppDelegate_iPad getDBAccess] clearAllVoiceNotes];
				[(CardDetails *) _parentCtrl._detail resetBoth];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"ResetApplication" object:nil userInfo:nil];
				break;
				
			default:
				break;
		}
	}
	[(DeckViewController *) _parentCtrl updateInfo];
	//[(CardDetails *) _parentCtrl._detail updateNavBar];
}

- (void)switchRandomChange:(id)sender
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"features.plist"];
	NSMutableDictionary* featuresDict=[[NSMutableDictionary alloc]initWithContentsOfFile:docPath];
	NSLog(@"Value of Random : %d",[[featuresDict objectForKey:@"Random"] intValue]);
	
	if ([sender isOn]) {
		[AppDelegate_iPad delegate].isRandomCard = 1;
	}
	else {
		[AppDelegate_iPad delegate].isRandomCard = 0;
	}
	[featuresDict setObject:[NSNumber numberWithInt: [AppDelegate_iPad delegate].isRandomCard] forKey:@"Random"];
	[featuresDict writeToFile:docPath atomically:YES];
}

- (void)viewDidUnload {
[self setSettingButton:nil];
[super viewDidUnload];
}
@end
