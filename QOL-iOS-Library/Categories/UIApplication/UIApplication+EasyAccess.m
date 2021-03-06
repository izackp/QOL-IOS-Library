//
//  UIApplication+EasyAccess.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIApplication+EasyAccess.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIApplication (EasyAccess)

+ (UIWindow*)getMainWindow {
  return [[[UIApplication sharedApplication] delegate] window];
}

+ (UIViewController*)getMainWindowRootViewController {
  return [[UIApplication getMainWindow] rootViewController];
}

+ (UIImage*)getScreenShot {
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (ScreenTypes)screenSizeType {
    int height = [self getMainWindow].frame.size.height;
    switch (height) {
        case 480:
            return ScreenTypesiPhone4s;
            
        case 568:
            return ScreenTypesiPhone5;
            
        case 667:
            return ScreenTypesiPhone6;
            
        case 736:
            return ScreenTypesiPhone6Plus;
            
        case 812:
            return ScreenTypesiPhoneX;
    }
    
    return ScreenTypesUnknown;
}


@end
