//
//  StringHelper.h
//  University of Phoenix
//
//  Created by OutworX Inc on 09/10/10.
//  Copyright 2010 University of Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSArray (Helpers)

- (NSArray *) shuffled;

@end


@interface NSString (StringHelper)

- (CGFloat)RAD_textHeightForSystemFontOfSize:(CGFloat)size;

- (CGRect)RAD_frameForCellLabelWithSystemFontOfSize:(CGFloat)size;

- (UILabel *)RAD_newSizedCellLabelWithSystemFontOfSize:(CGFloat)size;

- (void)RAD_resizeLabel:(UILabel *)aLabel WithSystemFontOfSize:(CGFloat)size;

- (CGRect)Answer_frameForCellLabelWithSystemFontOfSize:(CGFloat)size;

- (UILabel *)Answer_newSizedCellLabelWithSystemFontOfSize:(CGFloat)size;
- (UILabel *)Answer_newSizedCellLabelWithSystemFontOfSizeBold:(CGFloat)size;
- (CGFloat)Answer_textHeightForSystemFontOfSize:(CGFloat)size ;
- (NSString *)htmlEncoding;


@end

