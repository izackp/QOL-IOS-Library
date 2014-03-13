//
//  UIImage+Factory.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 2/26/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIImage+Factory.h"

@implementation UIImage (Factory)

+ (UIImage*)buildWithColor:(UIColor*)color {
    CGSize imageSize = CGSizeMake(1, 1);
    return [self buildWithColor:color size:imageSize];
}

+ (UIImage*)buildWithColor:(UIColor*)color size:(CGSize)size {
    
    CGRect areaToColor = CGRectZero;
    areaToColor.size = size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    [color setFill];
    UIRectFill(areaToColor);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
