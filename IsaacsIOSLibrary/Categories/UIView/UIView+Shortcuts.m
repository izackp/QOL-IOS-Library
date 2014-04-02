//
//  UIView+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 11/6/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIView+Shortcuts.h"

@implementation UIView (Shortcuts)

+ (instancetype)createFromNib {
    UIView* view = nil;
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    view = [topLevelObjects objectAtIndex:0];
    NSAssert([view isKindOfClass:[self class]], @"The view loaded from the nib is not of the expected class.");
    return view;
}

- (bool)isVisible {
    UIView* superview = self.superview;
    while (superview != nil)
    {
        if ([superview isKindOfClass:[UIWindow class]])
            return true;
        superview = superview.superview;
    }
    return false;
}

- (void)removeAllSubviews {
    for (UIView* eachView in self.subviews)
        [eachView removeFromSuperview];
}

@end
