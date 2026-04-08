//
//  UIApplication+EasyAccess.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ScreenTypesUnknown,
    ScreenTypesiPhone4s,
    ScreenTypesiPhone5,
    ScreenTypesiPhone6,
    ScreenTypesiPhone6Plus,
    ScreenTypesiPhoneX
} ScreenTypes;

@interface UIApplication (EasyAccess)

+ (UIWindow*)getMainWindow;
+ (UIViewController*)getMainWindowRootViewController;
+ (UIImage*)getScreenShot;
+ (ScreenTypes)screenSizeType;

@end
