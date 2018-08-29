	//
	//  AppDelegate_iPad.m
	//  FlashCardDB
	//
	//  Created by Friends on 1/27/11.
	//  Copyright __MyCompanyName__ 2011. All rights reserved.
	//

#import "DBAccess.h"

#import "LaunchView.h"
#import "AppDelegate_iPad.h"


@implementation AppDelegate_iPad

@synthesize dbAccess = _dbAccess;
@synthesize window = _window;
@synthesize isBookMarked = _isBookMarked;


@synthesize isFacebookEnabled;
@synthesize isTwitterEnabled;
@synthesize isVoiceNotesEnabled;
@synthesize isCommentsEnabled;
@synthesize isSearchingEnabled;
@synthesize isIndexingEnabled;
@synthesize isRandomCard;
#define degreesToRadians(x) (M_PI * x / 180.0)
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{   
    //[_window addSubview:_launchView.view];
     self.window.frame= [[UIScreen mainScreen] bounds];
    [self.window.rootViewController = _launchView view]; 
    [_window makeKeyAndVisible];
	
	_dbAccess = [[DBAccess alloc] init];
	[_dbAccess createDatabaseIfNeeded];
	
		// Initialize Features
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"features" ofType:@"plist"];
	NSMutableDictionary *featuresDict;
	//NSMutableDictionary *featuresDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	
	BOOL success;
	NSError* error;
	
	NSFileManager* FileManager = [NSFileManager defaultManager];
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDir = [paths objectAtIndex:0];
	
	NSString *_databasePath = [[[documentDir stringByAppendingPathComponent:@"features.plist"] retain] autorelease];
	success = [FileManager fileExistsAtPath:_databasePath];
	
	if (!success)
	{
		//NSString* dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"features.plist"];
		success = [FileManager copyItemAtPath:filePath toPath:_databasePath error:&error];
		if (!success)
		{
			NSAssert( @"Failed to copy the plist. Error:%@.", [error localizedDescription]);
			exit(1);
		}
	}
	featuresDict = [NSMutableDictionary dictionaryWithContentsOfFile:_databasePath];
	
	isVoiceNotesEnabled=[[featuresDict objectForKey:@"VoiceNotes"] boolValue];
	isCommentsEnabled=[[featuresDict objectForKey:@"Comments"] boolValue];
	isTwitterEnabled=[[featuresDict objectForKey:@"Twitter"] boolValue];
	isFacebookEnabled=[[featuresDict objectForKey:@"Facebook"] boolValue];
	isSearchingEnabled=[[featuresDict objectForKey:@"Searching"] boolValue];
	isIndexingEnabled=[[featuresDict objectForKey:@"Indexing"] boolValue];
	isRandomCard=[[featuresDict objectForKey:@"Random"] intValue];
	   	//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

+ (DBAccess*) getDBAccess
{
	return ((AppDelegate_iPad*)[[UIApplication sharedApplication] delegate]).dbAccess;
}

+ (AppDelegate_iPad*) delegate
{
	return (AppDelegate_iPad*)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc 
{
	[_launchView release];
	[_window release];
	[super dealloc];
}


@end

