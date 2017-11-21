//
//  UIApplication+EasyAccess.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (EasyAccess)

+ (UIWindow*)getMainWindow;
+ (UIViewController*)getMainWindowRootViewController;
+ (UIImage*)getScreenShot;

@end
