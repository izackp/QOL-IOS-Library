//
//  UIViewController+AddChild.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/2/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIViewController+AddChild.h"

@implementation UIViewController (AddChild)

- (void)addChildController:(UIViewController*)childController toView:(UIView*)view {
    //[childController willMoveToParentViewController:self];
    
    childController.view.frame = view.bounds;
    
    [view addSubview:childController.view];
    [self addChildViewController:childController];
    
    [childController didMoveToParentViewController:self];
}

- (void)removeAddedChildViewController:(UIViewController*)childController {
    [childController removeFromParentVC];
}

- (void)removeAllChildViewControllers {
    for (UIViewController* eachVC in self.childViewControllers)
    {
        [eachVC removeFromParentVC];
    }
}

- (void)removeFromParentVC {
    [self willMoveToParentViewController:nil];
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    //[self didMoveToParentViewController:nil];
}

@end
