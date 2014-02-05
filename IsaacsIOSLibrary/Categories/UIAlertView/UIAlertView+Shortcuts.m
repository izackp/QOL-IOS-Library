//
//  UIAlertView+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIAlertView+Shortcuts.h"

@implementation UIAlertView (Shortcuts)

+ (UIAlertView*)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert forceMainThreadShow];
    return alert;
}

+ (UIAlertView*)showMessage:(NSString*)message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert forceMainThreadShow];
    return alert;
}

+ (UIAlertView*)showQuestion:(NSString*)message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert forceMainThreadShow];
    return alert;
}

+ (UIAlertView*)showNotice:(NSString*)message {
    return [UIAlertView showAlertWithTitle:@"Notice" andMessage:message];
}

- (void)forceMainThreadShow {
    if ([NSThread currentThread] == [NSThread mainThread])
        [self show];
    else
        [self performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:true];
}

@end
