//
//  ProgressHUDWrapper.m
//  SightHound
//
//  Created by IsaacPaul on 11/19/13.
//  Copyright (c) 2013 IsaacPaul. All rights reserved.
//

#import "ProgressHUDWrapper.h"
#import "ProgressHUD.h"

@implementation ProgressHUDWrapper

+ (UIWindow*)findNormalWindow {
    return [ProgressHUD findNormalWindow];
}

static NSString* sLastText = nil;

+ (void)show:(NSString*)text {
    [ProgressHUD show:text];
}

+ (void)show:(NSString*)text allowInteraction:(bool)allow {
    [ProgressHUD show:text];
}

+ (void)showErrorBriefly:(NSString*)text {
    [ProgressHUD showErrorBriefly:text];
}

+ (void)showSuccessBriefly:(NSString*)text {
    [ProgressHUD showSuccessBriefly:text];
}

+ (void)dismiss {
    [ProgressHUD dismiss];
}


@end
