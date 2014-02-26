//
//  UIImage+Factory.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 2/26/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Factory)

+ (UIImage*)buildWithColor:(UIColor*)color;
+ (UIImage*)buildWithColor:(UIColor*)color size:(CGSize)size;

@end
