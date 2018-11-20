	//
	//  AppDelegate_iPad.h
	//  FlashCardDB
	//
	//  Created by Friends on 1/27/11.
	//  Copyright __MyCompanyName__ 2011. All rights reserved.
	//

#import <UIKit/UIKit.h>

@class DBAccess;
@class LaunchView;

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate>
{
    
    IBOutlet UIWindow*			_window;
    IBOutlet LaunchView*		_launchView;
	
	BOOL				_isBookMarked;
	DBAccess*			_dbAccess;
	
	
	BOOL				isFacebookEnabled;
	BOOL				isTwitterEnabled;
	BOOL				isVoiceNotesEnabled;
	BOOL				isCommentsEnabled;
	BOOL				isSearchingEnabled;
	BOOL				isIndexingEnabled;
	int     			isRandomCard;
    UILocalNotification *locationNotification;

}

@property (nonatomic, readonly) DBAccess*	dbAccess;
@property (nonatomic, readonly) UIWindow*	window;

@property (nonatomic) BOOL	isBookMarked;
@property (nonatomic) BOOL	isFacebookEnabled;
@property (nonatomic) BOOL	isTwitterEnabled;
@property (nonatomic) BOOL	isVoiceNotesEnabled;
@property (nonatomic) BOOL	isCommentsEnabled;
@property (nonatomic) BOOL	isSearchingEnabled;
@property (nonatomic) BOOL	isIndexingEnabled;
@property (nonatomic) int	isRandomCard;
@property (nonatomic) BOOL  isSetAlert;
@property (nonatomic) BOOL launchedFromLoacalNotification;

+ (DBAccess*) getDBAccess;
+ (AppDelegate_iPad*) delegate;

@end

