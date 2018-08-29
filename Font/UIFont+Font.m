//
//  UIFont+Font.m
//  CSAAPP
//
//  Created by Piyush Kumar on 17/07/13.
//  Copyright (c) 2013 IAA. All rights reserved.
//

#import "UIFont+Font.h"

@implementation UIFont (Font)




+(UIFont*) RobotoRegularFont: (float) fontSize
{
    /*for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"Font %@", fontName);
        }
    }*/
   // UIFont *font = [UIFont fontWithName:@"LeagueGothic" size:22.0f];
    UIFont *font = [UIFont fontWithName:@"Roboto-Regular" size:fontSize];
    return font;
}
+(UIFont*) RobotoBoldFont: (float) fontSize
{
    /*for (NSString *familyName in [UIFont familyNames]) {
     for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
     NSLog(@"Font %@", fontName);
     }
     }*/
    // UIFont *font = [UIFont fontWithName:@"LeagueGothic" size:22.0f];
    UIFont *font = [UIFont fontWithName:@"Roboto-Bold" size:fontSize];
    return font;
}


@end
