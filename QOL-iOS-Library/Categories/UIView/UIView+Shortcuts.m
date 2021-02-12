//
//  UIView+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 11/6/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIView+Shortcuts.h"
#import "NSObject+Shortcuts.h"

@implementation UIView (Shortcuts)

+ (instancetype)createFromNib {
    return [self createFromNib:[self classNameWithoutModule]];
}

+ (instancetype)createFromNib:(NSString*)nibName {
    UIView* view = nil;
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
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

- (UIImage*)generateImage {
    return [self generateImage:true];
}

- (UIImage*)generateImage:(BOOL)opaque {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, opaque, 0.0f);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSUInteger)indexInSuperview {
    for (NSUInteger i = 0; i < self.superview.subviews.count; i += 1)
    {
        UIView* view = self.superview.subviews[i];
        if (view != self)
            continue;
        return i;
    }
    return 0;
}

- (void)swapWithView:(UIView*)view {
    
    CGRect storeFrame = self.frame;
    NSUInteger storeIndex = [self indexInSuperview];
    UIView* storeSuperview = self.superview;
    UIViewAutoresizing storeResizeMask = self.autoresizingMask;
    
    self.frame = view.frame;
    [view.superview insertSubview:self aboveSubview:view];
    self.autoresizingMask = view.autoresizingMask;
    
    view.frame = storeFrame;
    [storeSuperview insertSubview:view atIndex:storeIndex];
    view.autoresizingMask = storeResizeMask;
}

@end
