//
//  UINavigationController+Transitions.m
//  IsaacsIOSLibrary
//
//  Created by Isaac on 9/30/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UINavigationController+Transitions.h"
#import "NSObject+Shortcuts.h"

NSString* const cTransition = @"Transition";

@implementation UINavigationController (Transitions) 

- (void)pushViewController:(UIViewController *)viewController withTransition:(id <UIViewControllerTransitioningDelegate>)transition {
    [self hookTransition:transition];
    [self pushViewController:viewController animated:true];
}

- (void)popViewControllerUsingTransition:(id <UIViewControllerTransitioningDelegate>)transition {
    [self hookTransition:transition];
    [self popViewControllerAnimated:true];
}

- (void)hookTransition:(id <UIViewControllerTransitioningDelegate>)transition {
    self.transitioningDelegate = (id)[UINavigationController class];
    self.delegate = (id)[UINavigationController class];
    [self setAssociatedObject:transition key:cTransition];
}

+ (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    navigationController.transitioningDelegate = nil;
    navigationController.delegate = nil;
    [navigationController setAssociatedObject:nil key:cTransition];
}

- (void)popToViewControllerClass:(Class)vcClass {
    UIViewController* foundVC = [self findVCWithClass:vcClass];
    [self popToViewController:foundVC animated:true];
}

- (UIViewController*)findVCWithClass:(Class)vcClass {
    NSArray* vcs = self.viewControllers;
    for (UIViewController* eachVc in vcs)
    {
        if ([eachVc isKindOfClass:vcClass])
            return eachVc;
    }
    return nil;
}

#pragma mark - UIViewControllerTransitioningDelegate
//Not called; Might not be needed?
+ (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return nil;
}

+ (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return nil;
}

#pragma mark - NavigationController Transitioning Delegate
+ (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    id result = [navigationController getAssociatedObject:cTransition];
    return result;
}

+ (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return nil;
}

@end
