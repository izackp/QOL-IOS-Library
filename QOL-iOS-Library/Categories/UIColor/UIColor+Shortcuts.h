//
//  UIColor+Shortcuts.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 1/10/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Shortcuts)

/*! Produces a random color that isn't very white or very black */
+ (nonnull UIColor*)randomColor;

/*! Produces a color using red, green, and blue values that range from 0.0f to 255.0f */
+ (nonnull UIColor*)color2WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/*! Produces a color using red, green, and blue values that range from 0.0f to 255.0f, and Alpha ranges from 0.0f to 1.0f */
+ (nonnull UIColor*)color2WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/*! Produces a color using a hexadecimal rgb value 0xFFAA01 */
+ (nonnull UIColor*)colorFromRGBHexValue:(NSInteger)hexValue;

/*! Produces a color using a hexadecimal rgb value 0xFFAA01 and Alpha ranges from 0.0f to 1.0f */
+ (nonnull UIColor*)colorFromRGBHexValue:(NSInteger)hexValue withAlpha:(CGFloat)alpha;

/*! Produces a color using the string representative of the CIColor */
+ (nullable UIColor*)colorFromString:(nullable NSString*)color;

/*! Produces the string representative of the CIColor */
- (nonnull NSString*)stringValue;


@end
