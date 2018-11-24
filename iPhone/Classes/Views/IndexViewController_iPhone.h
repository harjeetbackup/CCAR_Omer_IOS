//
//  IndexViewController.h
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckViewController_iPhone.h"

@interface IndexViewController_iPhone : UIViewController {
	
	NSMutableArray *cards;
    NSMutableArray *indices;
	IBOutlet UITableView*	_tableView;
}

@property(nonatomic,retain) IBOutlet UITableView* _tableView;
@property(nonatomic, retain) NSMutableArray *cards;
@property(nonatomic, retain) NSMutableArray *indices;
@property(nonatomic, retain) NSArray *flashCards;

-(void) popView;

@end
