//
//  UIViewController+AddChild.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/2/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AddChild)

- (void)addChildController:(UIViewController*)childController toView:(UIView*)view;
- (void)removeAddedChildViewController:(UIViewController*)childController;
- (void)removeFromParentVC;
- (void)removeAllChildViewControllers;

@end
