//
//  UINavigationController+SetItems.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (SetItems)

- (void)setLeftBarItemWithImage:(NSString*)image andTarget:(UIViewController *)overlay andAction:(SEL)action;
- (void)setRightBarItemWithImage:(NSString*)image andTarget:(UIViewController*)overlay andAction:(SEL)action;

@end

