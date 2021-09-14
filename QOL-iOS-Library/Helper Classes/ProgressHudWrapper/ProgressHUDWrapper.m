//
//  ProgressHUDWrapper.m
//  SightHound
//
//  Created by IsaacPaul on 11/19/13.
//  Copyright (c) 2013 IsaacPaul. All rights reserved.
//

#import "ProgressHUDWrapper.h"
#import "ProgressHUD.h"
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
    [self updateScheme];
    [self show:text allowInteraction:false];
}

+ (void)show:(NSString*)text allowInteraction:(bool)allow {
    if ([text isEqualToString:sLastText])
        return;
    [self updateScheme];
    sLastText = text;
    
    [self setUserInteractionOnNormalWindow:allow];
    [ProgressHUD show:text];
}

+ (void)showErrorBriefly:(NSString*)text {
    [self updateScheme];
    [self reset];
    [ProgressHUD showError:text];
}

+ (void)showSuccessBriefly:(NSString*)text {
    [self updateScheme];
    [self reset];
    [ProgressHUD showSuccess:text];
}

+ (void)dismiss {
    [self reset];
    [ProgressHUD dismiss];
}

+ (void)reset {
    sLastText = nil;
    [self setUserInteractionOnNormalWindow:true];
}

+ (void)updateScheme {
    if (@available(iOS 12.0, *)) {
        UIWindow* normWindow = [self findNormalWindow];
        UIUserInterfaceStyle style = normWindow.rootViewController.traitCollection.userInterfaceStyle;
        ProgressHUD* hud = [ProgressHUD shared];
        switch (style) {
        case UIUserInterfaceStyleLight:
            [hud setScheme:[ProgressHUDScheme light]];
                break;
        case UIUserInterfaceStyleDark:
            [hud setScheme:[ProgressHUDScheme dark]];
                break;
        default:
            [hud setScheme:[ProgressHUDScheme light]];
        }
    } else {
        // Fallback on earlier versions
    }
}
@end
