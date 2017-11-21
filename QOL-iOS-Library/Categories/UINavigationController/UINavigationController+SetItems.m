//
//  UINavigationController+SetItems.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UINavigationController+SetItems.h"
#import "UIBarButtonItem+BetterButton.h"

@implementation UINavigationController (SetItems)

- (void)setLeftBarItemWithImage:(NSString*)image andTarget:(UIViewController *)overlay andAction:(SEL)action
{
    [self.navigationBar.topItem setLeftBarButtonItem:[UIBarButtonItem buttonFromImage:[UIImage imageNamed:image] andTarget:overlay andAction:action] animated:YES];
}

- (void)setRightBarItemWithImage:(NSString*)image andTarget:(UIViewController*)overlay andAction:(SEL)action
{
    [self.navigationBar.topItem setRightBarButtonItem:[UIBarButtonItem buttonFromImage:[UIImage imageNamed:image] andTarget:overlay andAction:action] animated:YES];
}

@end