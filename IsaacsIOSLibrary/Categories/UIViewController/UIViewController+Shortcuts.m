//
//  UIViewController+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by Isaac on 9/26/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIViewController+Shortcuts.h"

@implementation UIViewController (Shortcuts)

- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}

@end
