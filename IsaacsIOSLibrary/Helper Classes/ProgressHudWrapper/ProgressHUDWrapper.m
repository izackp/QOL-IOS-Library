//
//  ProgressHUDWrapper.m
//  SightHound
//
//  Created by IsaacPaul on 11/19/13.
//  Copyright (c) 2013 SnapShots. All rights reserved.
//

#import "ProgressHUDWrapper.h"
#import "ProgressHUD.h"
#import "SVProgressHUD.h"
#import "UIDevice+SystemVersion.h"

@implementation ProgressHUDWrapper

+ (UIWindow*)findNormalWindow {
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows)
        if (window.windowLevel == UIWindowLevelNormal) {
            return window;
        }
    
    return nil;
}

+ (void)setUserInteractionOnNormalWindow:(bool)enabled {
    UIWindow* normWindow = [self findNormalWindow];
    [normWindow setUserInteractionEnabled:enabled];

}

static NSString* sLastText = nil;

+ (void)show:(NSString*)text {
    [self show:text allowInteraction:false];
}

+ (void)show:(NSString*)text allowInteraction:(bool)allow {
    if ([text isEqualToString:sLastText])
        return;
    sLastText = text;
    
    [self setUserInteractionOnNormalWindow:allow];
    
    if ([[UIDevice currentDevice] isIOS6OrLower])
        [SVProgressHUD showWithStatus:text];
    else
        [ProgressHUD show:text];
}

+ (void)showErrorBriefly:(NSString*)text {
    [self reset];
    
    if ([[UIDevice currentDevice] isIOS6OrLower])
        [SVProgressHUD showErrorWithStatus:text];
    else
        [ProgressHUD showError:text];
}

+ (void)showSuccessBriefly:(NSString*)text {
    [self reset];
    
    if ([[UIDevice currentDevice] isIOS6OrLower])
        [SVProgressHUD showSuccessWithStatus:text];
    else
        [ProgressHUD showSuccess:text];
}

+ (void)dismiss {
    [self reset];
    
    if ([[UIDevice currentDevice] isIOS6OrLower])
        [SVProgressHUD dismiss];
    else
        [ProgressHUD dismiss];
}

+ (void)reset {
    sLastText = nil;
    [self setUserInteractionOnNormalWindow:true];
}

@end
