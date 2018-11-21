//
//  ModalViewCtrl.m
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBAccess.h"
#import "DeckViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "Appirater.h"
#import "ModalViewCtrl_iPhone.h"
#import "Utils.h"
#import "Omer_Flash_Card-Swift.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation ModalViewCtrl_iPhone


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentType:(ContentType) type
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		_contentType = type;
	}
	
	_settingButtons=[[NSMutableArray alloc] init];
    AppDelegate_iPhone.delegate.isSetAlert = true;
    if ([AppDelegate_iPhone delegate].isSetAlert) {
        [_settingButtons addObject:@"Set Alerts"];
    }
	if([[[Utils getValueForVar:kProficiencyEnable] lowercaseString] isEqualToString:@"yes"])
    {
	[_settingButtons addObject:@"Clear All Proficiency"];
    }
    [_settingButtons addObject:@"Clear All Bookmarks"];
	
	if ([AppDelegate_iPhone delegate].isVoiceNotesEnabled) {
		[_settingButtons addObject:@"Clear All Voice Notes"];
	}
	
	if ([AppDelegate_iPhone delegate].isCommentsEnabled) {
		[_settingButtons addObject:@"Clear All Text Notes"];
	}
	
	[_settingButtons addObject:@"Reset Application"];
    if([[[Utils getValueForVar:kisAppRating] lowercaseString] isEqualToString: @"yes"])
    {
        [_settingButtons addObject:@"Application Rating"];
	}
	
	if ([[[Utils getValueForVar:kRandomOption] lowercaseString] isEqualToString:@"yes"]) {
		_isRandomOption = YES;
	}
	else {
		_isRandomOption = NO;
	}
    return self;
}

- (void) setParentCtrl: (DeckViewController_iPhone*) ctrl;
{
	_parentCtrl = ctrl;
}
-(void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
   
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
       UIImage *image = [UIImage imageNamed:@"background.png"];
        [ self.imageView setImage:image];
    }
     if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
     {
        
   /* CGRect myFrameNav = self.myNavBar.frame;
    myFrameNav.origin.y = 20;
    self.myNavBar.frame = myFrameNav;*/
         
         CGRect myFrameWebView = _webView.frame;
         myFrameWebView.origin.y = 0;
         _webView.frame = myFrameWebView;
     }
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.tintColor = [UIColor blackColor];
//    [button addTarget:self
//               action:@selector(aMethod:)
//     forControlEvents:UIControlEventTouchUpInside];
//    //[button setTitle:@"" forState:UIControlStateNormal];
//    // [button setBackgroundImage:[UIImage imageNamed:@"backSeven.png"] forState:UIControlStateNormal];
//    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
//    {
//    [button setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
//        button.frame = CGRectMake(8.0, 5.0, 70.0, 29.0);
//        //button.contentMode=UIViewContentModeScaleAspectFit;
//    }
//    else
//    {
//        [button setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
//        button.frame = CGRectMake(5.0, 5.0, 50.0, 30.0);
//        button.contentMode=UIViewContentModeScaleAspectFit;
//    }
//   // button.frame = CGRectMake(8.0, 5.0, 91.0, 38.0);
//   // button.contentMode=UIViewContentModeScaleAspectFit;
//    button.hidden = NO;
//    [self.navigationController.navigationBar addSubview:button];

    
}
-(void)aMethod:(id)sender

{   [self.navigationController popViewControllerAnimated:NO];
   // [self dismissViewControllerAnimated:YES completion:NULL];
    [_parentCtrl updateInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
	
	//_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow_bg.png"]] autorelease];
	_tableView.backgroundColor=[UIColor clearColor];
    NSString *fileName;
    NSURLRequest *request;
    
	switch(_contentType)
	{
            
		case kContentTypeSetting:
                self.title = @"Settings";
			//_navItem.title = @"Settings";
            //[self.myBackButton setImage:[UIImage imageNamed:@"back_btn_iPhone.png"]];
            
			_tableView.hidden = NO;
           // CGRect myFrameWebView = _tableView.frame;
//myFrameWebView.size.height = 64;
           // _tableView.frame = myFrameWebView;
           // _tableView.o
			_webView.hidden =YES;
			break;
            
        case kcontentTypeIntro:
            self.title = @"Introduction";
           // _navItem.title = @"Introduction";
            fileName = [[NSBundle mainBundle] pathForResource:@"intro.html" ofType:nil inDirectory:nil];
            request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fileName]];
            [_webView loadRequest:request];
            _webView. scalesPageToFit=YES;
			//[_webView loadHTMLString:[[AppDelegate_iPhone getDBAccess] GetHelpString] baseURL:nil];
			_tableView.hidden = YES;
			_webView.hidden = NO;
			break;
            
        case kcontentTypeBeforeCard:
           // _navItem.title = @"Before Omer";
            self.title = @"Before Omer";
            fileName = [[NSBundle mainBundle] pathForResource:@"beforecard.html" ofType:nil inDirectory:nil];
            request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fileName]];
            [_webView loadRequest:request];
            _webView. scalesPageToFit=YES;
            //[_webView loadHTMLString:[[AppDelegate_iPhone getDBAccess] GetHelpString] baseURL:nil];
            _tableView.hidden = YES;
            _webView.hidden = NO;
            break;
            
        case kcontentTypeAfterCard:
            //_navItem.title = @"After Omer";
            self.title = @"After Omer";
            fileName = [[NSBundle mainBundle] pathForResource:@"aftercard.html" ofType:nil inDirectory:nil];
            request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fileName]];
            [_webView loadRequest:request];
            _webView. scalesPageToFit=YES;
            //[_webView loadHTMLString:[[AppDelegate_iPhone getDBAccess] GetHelpString] baseURL:nil];
            _tableView.hidden = YES;
            _webView.hidden = NO;
            break;
            

		case kContentTypeHelp:
			//_navItem.title = @"Help";
            self.title = @"Help";
            fileName = [[NSBundle mainBundle] pathForResource:@"help.html" ofType:nil inDirectory:nil];
            request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fileName]];
            [_webView loadRequest:request];
            _webView. scalesPageToFit=YES;
			//[_webView loadHTMLString:[[AppDelegate_iPhone getDBAccess] GetHelpString] baseURL:nil];
			_tableView.hidden = YES;
			_webView.hidden = NO;
			break;
			
		case kContentTypeInfo:
			//_navItem.title = @"Info";
            self.title = @"Info";
            fileName = [[NSBundle mainBundle] pathForResource:@"info.html" ofType:nil inDirectory:nil];
            request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fileName]];
            
            [_webView loadRequest:request];
            _webView. scalesPageToFit=YES;
			//[_webView loadHTMLString:[[AppDelegate_iPhone getDBAccess] GetInfoString] baseURL:nil];
			_tableView.hidden = YES;
			_webView.hidden = NO;
			break;
	}	
	
}

- (IBAction) done:(id) sender
{
	[self dismissModalViewControllerAnimated:YES];
	[_parentCtrl updateInfo];
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc 
{
	[_webView release];
	[_tableView release];
    [_imageView release];
    [super dealloc];
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
    //[cell setSelectedBackgroundView:bgColorView];
    [bgColorView release];
	if (indexPath.row < [_settingButtons count]) {
	
		cell.textLabel.font = [UIFont systemFontOfSize:20];
		cell.backgroundColor = [UIColor clearColor];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            cell.backgroundView  = [[[UIImageView alloc]
                                     initWithImage:[UIImage imageNamed:@""]] autorelease];
        }
        else{
		cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"big_grey_btn.png"]] autorelease];
        }
		
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.text=[_settingButtons objectAtIndex:indexPath.row];
	}
	/*else if(_isRandomOption == YES)
	{
		cell.textLabel.font = [UIFont systemFontOfSize:20];
		
		cell.backgroundColor = [UIColor clearColor];
		
		cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"grey_btn.png"]] autorelease];	
		UILabel *objLabelRandom = [[[UILabel alloc] initWithFrame:CGRectMake(30,17,180,25)] autorelease];
		objLabelRandom.font = [UIFont systemFontOfSize:20];
		objLabelRandom.backgroundColor = [UIColor clearColor];
		objLabelRandom.text = @"Randomize Blessings";
		UISwitch *objSwitchRandom=[[[UISwitch alloc] initWithFrame:CGRectMake(220,17,100,25)] autorelease];
		objSwitchRandom.tag=20;
		int iRandom = [AppDelegate_iPhone delegate].isRandomCard;	
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
		//[objLabelRandom release];
		//[objSwitchRandom release];
	}
*/
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row < [_settingButtons count]) {
		
		NSString* button = [_settingButtons objectAtIndex:indexPath.row];
        if ([button isEqualToString:@"Set Alerts"]) {
            NSString * storyboardName = @"SetAlerts";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            SetAlertViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SetAlertViewController"];
            vc.isFromIphone = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
		else if ([button isEqualToString:@"Clear All Proficiency"]) {
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
				[[AppDelegate_iPhone getDBAccess] clearAllProficiency];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedCards" object:nil userInfo:nil];
				break;
				
			case 1:
				[[AppDelegate_iPhone getDBAccess] clearAllBookmarkedCards];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedCards" object:nil userInfo:nil];
				break;
				
			case 2:
				[[AppDelegate_iPhone getDBAccess] clearAllComments];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedComments" object:nil userInfo:nil];
				break;
				
			case 3:
				
				[[AppDelegate_iPhone getDBAccess] clearAllVoiceNotes];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedVoiceNotes" object:nil userInfo:nil];
				break;
				
			case 4:
				
				[[AppDelegate_iPhone getDBAccess] clearAllBookmarkedCards];
				[[AppDelegate_iPhone getDBAccess] clearAllProficiency];
				[[AppDelegate_iPhone getDBAccess] clearAllComments];
				[[AppDelegate_iPhone getDBAccess] clearAllVoiceNotes];
				
				[[NSNotificationCenter defaultCenter] postNotificationName:@"ResetApplication" object:nil userInfo:nil];
				break;
				
			default:
				break;
		}
	}
}

- (void)switchRandomChange:(id)sender
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"features.plist"];
	NSMutableDictionary* featuresDict=[[NSMutableDictionary alloc]initWithContentsOfFile:docPath];
	NSLog(@"Value of Random : %d",[[featuresDict objectForKey:@"Random"] intValue]);
	
	if ([sender isOn]) {
		[AppDelegate_iPhone delegate].isRandomCard = 1;
	}
	else {
		[AppDelegate_iPhone delegate].isRandomCard = 0;
	}
	[featuresDict setObject:[NSNumber numberWithInt: [AppDelegate_iPhone delegate].isRandomCard] forKey:@"Random"];
	[featuresDict writeToFile:docPath atomically:YES];
}


- (void)viewDidUnload {
[self setImageView:nil];
[super viewDidUnload];
}
@end
