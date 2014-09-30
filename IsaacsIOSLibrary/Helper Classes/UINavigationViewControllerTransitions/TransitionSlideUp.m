//
//  TransitionSlideUp.m
//  IsaacsIOSLibrary
//
//  Created by Isaac on 9/30/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "TransitionSlideUp.h"

@implementation TransitionSlideUp

+ (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.33f;
}

+ (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    toViewController.view.frame = CGRectOffset(finalFrame, 0, containerView.frame.size.height);
    
    [containerView addSubview:toViewController.view];
    
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end

@implementation TransitionSlideUpReverse

+ (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.33f;
}

+ (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect toFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    toViewController.view.frame = toFinalFrame;
    [containerView addSubview:toViewController.view];
    [containerView sendSubviewToBack:toViewController.view];
    
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, 0, containerView.frame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
