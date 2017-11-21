//
//  TransitionBase.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/20/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import "TransitionBase.h"

@implementation TransitionBase

+ (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
  return 0.33f;
}

+ (id <UIViewControllerTransitioningDelegate>)delegate {
  return (id <UIViewControllerTransitioningDelegate>)self;
}

@end
