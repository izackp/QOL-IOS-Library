//
//  UIViewController+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by Isaac on 9/26/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIViewController+Shortcuts.h"
#import "UINavigationController+Transitions.h"

@implementation UIViewController (Shortcuts)

- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}

- (UIViewController*)findVCInHeirachyWithClass:(Class)vcClass {
    UIViewController* foundVC = [self isKindOfClass:vcClass] ? self : nil;
    if (foundVC)
        return foundVC;
    
    UINavigationController* navVC = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController*)self : self.navigationController;
    
    foundVC = [navVC findVCWithClass:vcClass];
    if (foundVC)
        return foundVC;
    
    if (self.parentViewController != nil) {
        foundVC = [self.parentViewController findVCInHeirachyWithClass:vcClass];
    }
    if (foundVC)
        return foundVC;
    
    UIViewController* presenting = self.presentingViewController;
    if (presenting != nil) {
        return [presenting findVCInHeirachyWithClass:vcClass];
    }
    
    return nil;
}

@end
