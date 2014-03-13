//
//  UIColor+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 1/10/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIColor+Shortcuts.h"

@implementation UIColor (Shortcuts)

+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor*)color2WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [self color2WithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor*)color2WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [self colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor*)colorFromRGBHexValue:(NSInteger)hexValue withAlpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alpha];
}

@end
