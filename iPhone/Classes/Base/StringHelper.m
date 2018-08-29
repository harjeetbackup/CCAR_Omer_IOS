//
//  StringHelper.m
//  University of Phoenix
//
//  Created by OutworX Inc on 09/10/10.
//  Copyright 2010 University of Phoenix. All rights reserved.
//

#import "StringHelper.h"
#import "Utils.h"
#import "RCLabel.h"
#import "UIFont+Font.h"
@implementation NSArray (Helpers)

- (NSArray *) shuffled
{
	// create temporary autoreleased mutable array
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self count]];
	
	for (id anObject in self)
	{
		NSUInteger randomPos = arc4random()%([tmpArray count]+1);
		[tmpArray insertObject:anObject atIndex:randomPos];
	}
	
	return [NSArray arrayWithArray:tmpArray];  // non-mutable autoreleased copy
}

@end


@implementation NSString (StringHelper)

#pragma mark Methods to determine the height of a string for resizeable table cells

- (CGFloat)RAD_textHeightForSystemFontOfSize:(CGFloat)size 
	{
		//Calculate the expected size based on the font and linebreak mode of your label
		CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 60;
		CGFloat maxHeight = 9999;
		CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	
		CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:maximumLabelSize  lineBreakMode:UILineBreakModeWordWrap];
								   
		return expectedLabelSize.height;
	}

/*- (NSString *)htmlEncoding
{
	self = [Utils getEncodedText:self];
    return self;
}*/


- (CGFloat)Answer_textHeightForSystemFontOfSize:(CGFloat)size 
	{
		//Calculate the expected size based on the font and linebreak mode of your label
		CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 150;
		CGFloat maxHeight = 9999;
		CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	
		CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
								
		return expectedLabelSize.height;
}



- (CGRect)RAD_frameForCellLabelWithSystemFontOfSize:(CGFloat)size 
	{
		CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
		CGFloat height = [self RAD_textHeightForSystemFontOfSize:size] + 10.0;
		return CGRectMake(10.0f, 10.0f, width, height);
	}



- (CGRect)Answer_frameForCellLabelWithSystemFontOfSize:(CGFloat)size 
	{
		CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
		CGFloat height = [self Answer_textHeightForSystemFontOfSize:size] + 10.0;
		return CGRectMake(45.0f, 15.0f, width, height);
	}



- (RCLabel *)Answer_newSizedCellLabelWithSystemFontOfSize:(CGFloat)size
	{
	
        RCLabel *cellLabel = [[RCLabel alloc] initWithFrame:[self Answer_frameForCellLabelWithSystemFontOfSize:size]];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:self];
        cellLabel.componentsAndPlainText = componentsDS;
        cellLabel.font =[UIFont RobotoRegularFont:size];
        
        return cellLabel;
	}
- (RCLabel *)Answer_newSizedCellLabelWithSystemFontOfSizeBold:(CGFloat)size
{
    
    RCLabel *cellLabel = [[RCLabel alloc] initWithFrame:[self Answer_frameForCellLabelWithSystemFontOfSize:size]];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:self];
    cellLabel.componentsAndPlainText = componentsDS;
    cellLabel.font =[UIFont RobotoBoldFont:size];
    
    return cellLabel;
}



- (void)RAD_resizeLabel:(UILabel *)aLabel WithSystemFontOfSize:(CGFloat)size
	{
		aLabel.frame = [self RAD_frameForCellLabelWithSystemFontOfSize:size];
		aLabel.text = self;
		[aLabel sizeToFit];
	}



- (UILabel *)RAD_newSizedCellLabelWithSystemFontOfSize:(CGFloat)size 
	{
		UILabel *cellLabel = [[UILabel alloc] initWithFrame:[self RAD_frameForCellLabelWithSystemFontOfSize:size]];
		cellLabel.textColor = [UIColor blackColor];
		cellLabel.backgroundColor = [UIColor clearColor];
		cellLabel.textAlignment = UITextAlignmentLeft;
		cellLabel.font = [UIFont systemFontOfSize:size];
	
		cellLabel.text = self; 
		cellLabel.numberOfLines = 0; 
		[cellLabel sizeToFit];
		return cellLabel;
	}

@end
