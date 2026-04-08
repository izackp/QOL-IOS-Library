//
//  UIView+Positioning.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIView+Positioning.h"

@implementation UIView (Positioning)

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.centerY);
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.centerX, centerY);
}

- (void)setX:(CGFloat)x {
  self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)y {
  self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setWidth:(CGFloat)width {
    if (width < 0) {
        NSLog(@"Warning: Setting width to a value < 0");
        return;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeight:(CGFloat)height {
    if (height < 0) {
        NSLog(@"Warning: Setting width to a value < 0");
        return; //we abort because this will change a UIView's x position which is an unintended sideeffect
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)setWidthCenterAnchored:(CGFloat)width {
    if (width < 0) {
        NSLog(@"Warning: Setting width to a value < 0");
        return;
    }
    CGFloat diff = (self.width - width) * 0.5f;
    self.frame = CGRectMake(self.frame.origin.x + diff, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeightCenterAnchored:(CGFloat)height {
    if (height < 0) {
        NSLog(@"Warning: Setting height to a value < 0");
        return; //we abort because this will change a UIView's x position which is an unintended sideeffect
    }
    CGFloat diff = (self.height - height) * 0.5f;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + diff, self.frame.size.width, height);
}

- (void)setOrigin:(CGPoint)origin {
  self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setSize:(CGSize)size {
    if (size.height < 0) {
        NSLog(@"Warning: Setting height to a value < 0");
        return; //we abort because this will change a UIView's y position which is an unintended sideeffect
    }
    if (size.width < 0) {
        NSLog(@"Warning: Setting width to a value < 0");
        return;
    }
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (CGSize)size {
  return self.frame.size;
}

- (CGPoint)origin {
  return self.frame.origin;
}

- (CGFloat)x {
  return self.frame.origin.x;
}

- (CGFloat)y {
  return self.frame.origin.y;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGFloat)width {
  return self.frame.size.width;
}

- (CGFloat)height {
  return self.frame.size.height;
}

- (CGFloat)left {
    return self.x;
}

- (CGFloat)top {
    return self.y;
}

- (CGFloat)right {
    return self.x + self.width;
}

- (CGFloat)bottom {
    return self.y + self.height;
}

- (void)setLeft:(CGFloat)value {
    CGFloat diff = value - self.left;
    self.frame = CGRectMake(self.x + diff, self.y, self.width - diff, self.height);
}

- (void)setTop:(CGFloat)value {
    CGFloat diff = value - self.top;
    self.frame = CGRectMake(self.x, self.y + diff, self.width, self.height - diff);
}

- (void)setRight:(CGFloat)value {
    CGFloat diff = value - self.right;
    self.frame = CGRectMake(self.x, self.y, self.width + diff, self.height);
}

- (void)setBottom:(CGFloat)value {
    CGFloat diff = value - self.bottom;
    self.frame = CGRectMake(self.x, self.y, self.width, self.height + diff);
}

- (void)setRightAnchored:(CGFloat)value {
    CGFloat diff = value - self.right;
    self.frame = CGRectMake(self.x + diff, self.y, self.width, self.height);
}

- (void)setBottomAnchored:(CGFloat)value {
    CGFloat diff = value - self.bottom;
    self.frame = CGRectMake(self.x, self.y + diff, self.width, self.height);
}

- (void)fillParent {
    if (self.superview == nil) { return; }
    self.frame = CGRectMake(0, 0, self.superview.width, self.superview.height);
}

- (void)fillParent:(UIEdgeInsets)insets {
    if (self.superview == nil) { return; }
    
    CGFloat xx = 0 + insets.left;
    CGFloat yy = 0 + insets.top;
    CGFloat ww = self.superview.width - xx - insets.right;
    CGFloat hh = self.superview.height - yy - insets.bottom;
    self.frame = CGRectMake(xx, yy, ww, hh);
}

- (CGPoint)positionInWindow {
    UIWindow* window = UIApplication.sharedApplication.delegate.window;
    CGPoint windowPoint = [self.superview convertPoint:self.frame.origin toView:window];
    return windowPoint;
}

- (void)setPositionInWindow:(CGPoint)value {
    UIWindow* window = UIApplication.sharedApplication.delegate.window;
    CGPoint newPoint = [window convertPoint:value toView:self.superview];
    self.frame = CGRectMake(newPoint.x, newPoint.y, self.frame.size.width, self.frame.size.height);
}

- (float)subviewTop {
    float heightToBeat = 999999.9f;
    for (UIView* eachView in self.subviews)
        if ([eachView isVisible])
            if (eachView.y < heightToBeat)
                heightToBeat = eachView.y;
    
    return heightToBeat;
}

- (float)subviewBottom {
    float heightToBeat = -999999.9f;
    for (UIView* eachView in self.subviews)
        if ([eachView isVisible])
            if (eachView.y + eachView.height > heightToBeat)
                heightToBeat = eachView.y + eachView.height;
    
    return heightToBeat;
}

- (float)subviewLeft {
    float positionToBeat = 999999.9f;
    for (UIView* eachView in self.subviews)
        if ([eachView isVisible])
            if (eachView.x < positionToBeat)
                positionToBeat = eachView.x;
    
    return positionToBeat;
}

- (float)subviewRight {
    float positionToBeat = -999999.9f;
    for (UIView* eachView in self.subviews)
        if ([eachView isVisible])
            if (eachView.x + eachView.width > positionToBeat)
                positionToBeat = eachView.x + eachView.width;
    
    return positionToBeat;
}

- (bool)isVisible
{
    if (self.hidden)
        return false;
    if (self.alpha == 0.0f)
        return false;
    return true;
}

- (void)cropForVisibleSubviews {
    if ([self.subviews count] == 0)
        return; //No subviews to crop with
    
    bool allInvis = true;
    for (UIView* eachView in self.subviews)
    {
        if ([eachView isVisible])
        {
            allInvis = false;
            break;
        }
    }
    if (allInvis)
        return; //All subviews are invisible
    
    float highestView = [self subviewTop];
    float lowestView = [self subviewBottom];
    float mostLeftView = [self subviewLeft];
    float mostRightView = [self subviewRight];
    
    for (UIView* eachView in self.subviews)
    {
        eachView.x -= mostLeftView;
        eachView.y -= highestView;
    }
    
    self.width = mostRightView - mostLeftView;
    self.height = lowestView - highestView;
}

/*! @todo using 'of' in a function name seems to imply a context that should be implied by the class its in. Which means it probably needs to be refactored */
- (CGFloat)totalHeightOfVerticallyCenteredSubviewsWithPadding:(CGFloat)padding {
    NSArray* views = self.subviews;
    CGFloat totalHeight = 0.0f;
    NSUInteger numViews = [views count];
    
    if (numViews == 0)
        return 0.0f;
    
    for (UIView* eachView in views)
        totalHeight += eachView.height;
    
    totalHeight += padding * (numViews - 1);
    return totalHeight;
}

- (void)centerSubviewsVerticallyWithPadding:(CGFloat)padding {

    CGFloat totalHeightOfCenteredSubviews = [self totalHeightOfVerticallyCenteredSubviewsWithPadding:padding];
    if (totalHeightOfCenteredSubviews == 0.0f)
        return;
    
    CGFloat extraSpace = self.height - totalHeightOfCenteredSubviews;
    CGFloat topPadding = extraSpace * 0.5f;
    CGFloat startingY  = topPadding;
    CGFloat offset = 0.0f;
    
    for (UIView* eachView in self.subviews)
    {
        eachView.y = startingY + offset;
        offset += padding + eachView.height;
    }
}

- (CGFloat)totalWidthOfSubviews {
    CGFloat totalWidth = 0.0f;
    for (UIView* eachView in self.subviews)
        totalWidth += eachView.width;
    
    return totalWidth;
}

- (void)evenlySpaceSubviewsHorizontally {
    
    NSArray* subviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView* obj1, UIView* obj2) {
        if (obj1.x < obj2.x)
            return NSOrderedAscending;
        
        if (obj1.x == obj2.x)
        {
            if (obj1.y < obj2.y)
                return NSOrderedAscending;
            
            if (obj1.y == obj2.y)
                return NSOrderedSame;
        }
        
        return NSOrderedDescending;
    }];
    
    CGFloat extraSpace = self.width - [self totalWidthOfSubviews];
    CGFloat numSpaces = subviews.count + 1;
    CGFloat padding = extraSpace / numSpaces;
    
    CGFloat x = padding;
    for (UIView* eachView in subviews)
    {
        eachView.x = x;
        x += padding + eachView.width;
    }
}

- (void)alignViewsToTheLeft:(CGFloat)padding {
    NSArray* subviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView* obj1, UIView* obj2) {
        if (obj1.x < obj2.x)
            return NSOrderedAscending;
        
        if (obj1.x == obj2.x)
        {
            if (obj1.y < obj2.y)
                return NSOrderedAscending;
            
            if (obj1.y == obj2.y)
                return NSOrderedSame;
        }
        
        return NSOrderedDescending;
    }];
    
    float x = 0;
    for (UIView* eachView in subviews)
    {
        if (eachView.width == 0)
            continue;
        eachView.x = x;
        x += padding + eachView.width;
    }
}

@end
