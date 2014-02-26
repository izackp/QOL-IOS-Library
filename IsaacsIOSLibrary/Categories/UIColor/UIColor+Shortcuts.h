//
//  UIColor+Shortcuts.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 1/10/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Shortcuts)

+ (UIColor *)randomColor;

/*! Produces a color using red, green, and blue values that range from 0.0f to 255.0f */
+ (UIColor*)color2WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/*! Produces a color using red, green, and blue values that range from 0.0f to 255.0f, and Alpha ranges from 0.0f to 1.0f */
+ (UIColor*)color2WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
