//
//  AppDelegate_iPhone.m
//  FlashCardDB
//
//  Created by Friends on 1/27/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "DBAccess.h"

#import "AppDelegate_iPhone.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate_iPhone

@synthesize dbAccess = _dbAccess;
@synthesize isBookMarked = _isBookMarked;
@synthesize isFacebookEnabled;
@synthesize isTwitterEnabled;
@synthesize isVoiceNotesEnabled;
@synthesize isCommentsEnabled;
@synthesize isSearchingEnabled;
@synthesize isIndexingEnabled;
@synthesize isRandomCard;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
		// Override point for customization after application launch.
    locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
        self.launchedFromLoacalNotification = true;
    } else {
        self.launchedFromLoacalNotification = false;
    }
		// Add the navigation controller's view to the window and display.
    [Fabric with:@[[Crashlytics class]]];
	navigationController.navigationBarHidden = YES;
   // window.tintColor = [UIColor purpleColor];
	[window setRootViewController:navigationController];
   // [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
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
	NSString *_databasePath = [[documentDir stringByAppendingPathComponent:@"features.plist"] retain];
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
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

+ (DBAccess*) getDBAccess
{
	return ((AppDelegate_iPhone*)[[UIApplication sharedApplication] delegate]).dbAccess;
}

+ (AppDelegate_iPhone*) delegate
{
	return (AppDelegate_iPhone*)[[UIApplication sharedApplication] delegate];
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
    printf("foreground\n");

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive){
        application.applicationIconBadgeNumber = 0;
        self.launchedFromLoacalNotification = true;
    } else {
        self.launchedFromLoacalNotification = false;
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler{
    printf("recieved notification");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    printf("active");
   application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
  
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end

