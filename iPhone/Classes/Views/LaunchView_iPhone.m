//
//  LaunchView.m
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlashCard.h"

#import "DeckViewController_iPhone.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Utils.h"
#import "LaunchView_iPhone.h"
#import "AppDelegate_iPhone.h"

#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
@implementation LaunchView_iPhone

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, self.view.frame.size.height)];
//    if ([[AppDelegate_iPhone delegate] launchedFromLoacalNotification]) {
//        [self loadHomeScreen];
//    }
    
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    if(IS_IPHONE5)
        
    {
        [_imgButton setImage:[UIImage imageNamed:@"Launching_iphone568.png"] forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadHomeViewFromNotification)
                                            name:UIApplicationDidBecomeActiveNotification object:nil];

}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)loadHomeViewFromNotification {
    if ([[AppDelegate_iPhone delegate] launchedFromLoacalNotification]) {
       //[self.navigationController popViewControllerAnimated:NO];
        [self loadHomeScreen];
    }
}

- (void)loadHomeScreen
{
    _imgButton.hidden = YES;
    FlashCardDeckList* deckList = [[FlashCardDeckList alloc] init];
    DeckViewController_iPhone* controller = [[DeckViewController_iPhone alloc] initWithNibName:@"DeckViewController_iPhone" bundle:nil];
    
    controller.cardDecks = deckList;
    [self.navigationController pushViewController:controller animated:YES];
    self.navigationItem.hidesBackButton=YES;
    [deckList release];
    [controller release];
}

- (IBAction)openHomeView
{
    
    if([[[Utils getValueForVar:kAudioOnTapToStart] lowercaseString] isEqualToString:@"yes"])
    {
        NSError* err = nil;
        NSString* audioFileName = [[NSBundle mainBundle] pathForResource:[Utils getValueForVar:kStartSoundFile] ofType:nil inDirectory:nil];
        if (audioFileName == nil)
            return;
        //audioFileName = [[NSBundle mainBundle] pathForResource:audioFileName ofType:nil inDirectory:nil];
        AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioFileName] error:&err];
        //player.delegate=self;
        [player play];
    }
    UIActivityIndicatorView* indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [indicator setFrame:CGRectMake(140, 265, 40, 40)];
    [indicator startAnimating];
    [_imgButton addSubview:indicator];
    [self loadHomeScreen];
}

@end
