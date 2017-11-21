//
//  ProgressHUDWrapper.h
//  SightHound
//
//  Created by IsaacPaul on 11/19/13.
//  Copyright (c) 2013 SnapShots. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProgressHUDWrapper : NSObject

+ (UIWindow*)findNormalWindow;

+ (void)show:(NSString*)text;
+ (void)show:(NSString*)text allowInteraction:(bool)allow;

+ (void)showErrorBriefly:(NSString*)text;
+ (void)showSuccessBriefly:(NSString*)text;

+ (void)dismiss;

@end
