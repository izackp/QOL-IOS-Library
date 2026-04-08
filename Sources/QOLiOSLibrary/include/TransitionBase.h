//
//  TransitionBase.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/20/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionBase : NSObject

+ (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;

+ (id <UIViewControllerTransitioningDelegate>)delegate;

@end
