//
//  UINavigationController+Transitions.h
//  IsaacsIOSLibrary
//
//  Created by Isaac on 9/30/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Transitions)

- (void)pushViewController:(UIViewController *)viewController withTransition:(id <UIViewControllerTransitioningDelegate>)transition;
- (void)popViewControllerUsingTransition:(id <UIViewControllerTransitioningDelegate>)transition;
- (void)popToViewControllerClass:(Class)vcClass;
- (UIViewController*)findVCWithClass:(Class)vcClass;

@end
