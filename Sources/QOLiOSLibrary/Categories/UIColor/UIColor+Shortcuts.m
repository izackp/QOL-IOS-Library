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

+ (nonnull UIColor*)colorFromIntRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha {
    return [self color2WithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor*)colorFromRGBHexValue:(NSInteger)hexValue {
    return [self colorFromRGBHexValue:hexValue withAlpha:1.0f];
}

CGFloat redColor(NSInteger hexValue) {
    return colorFromHexMasked(hexValue, 0xFF0000, 16);
}

CGFloat greenColor(NSInteger hexValue) {
    return colorFromHexMasked(hexValue, 0xFF00, 8);
}

CGFloat blueColor(NSInteger hexValue) {
    return colorFromHexMasked(hexValue, 0xFF, 0);
}

CGFloat colorFromHexMasked(NSInteger hexValue, NSInteger hexMask, NSInteger offset) {
    return ((CGFloat)((hexValue & hexMask) >> offset))/255.0f;
}

+ (UIColor*)colorFromRGBHexValue:(NSInteger)hexValue withAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:redColor(hexValue) green:greenColor(hexValue) blue:blueColor(hexValue) alpha:alpha];
}

+ (UIColor*)colorFromString:(NSString*)colorString {
    if (![colorString isKindOfClass:NSString.class])
    {
        NSLog(@"Warning: Wrong class (%@) passed to colorFromString:", NSStringFromClass(colorString.class));
        return nil;
    }
    
    CIColor* coreColor = [CIColor colorWithString:colorString];
    UIColor* color = [UIColor colorWithCIColor:coreColor];
    color = [UIColor colorWithCGColor:color.CGColor]; //Apple bug fix
    return color;
}

- (NSString*)stringValue {
    CGColorRef colorRef = self.CGColor;
    NSString* colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    return colorString;
}

@end
