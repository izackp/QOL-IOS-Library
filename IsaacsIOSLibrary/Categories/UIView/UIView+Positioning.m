//
//  UIView+Positioning.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIView+Positioning.h"

@implementation UIView (Positioning)

- (void)setX:(CGFloat)x {
  self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)y {
  self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setWidth:(CGFloat)width {
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeight:(CGFloat)height {
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)setOrigin:(CGPoint)origin {
  self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setSize:(CGSize)size {
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

- (CGFloat)width {
  return self.frame.size.width;
}

- (CGFloat)height {
  return self.frame.size.height;
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
    int numViews = [views count];
    
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

@end
