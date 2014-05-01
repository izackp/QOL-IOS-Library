//
//  UIScrollView+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 3/26/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIScrollView+Shortcuts.h"

@implementation UIScrollView (Shortcuts)

- (void)offsetContentHeight:(CGFloat)offset {
    self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height + offset);
}

- (void)setContentHeight:(CGFloat)height {
    self.contentSize = CGSizeMake(self.contentSize.width, height);
}

- (void)centerContentHorizontally {
    CGFloat newContentOffsetX = (self.contentSize.width - self.bounds.size.width) * 0.5f;
    [self setContentOffset:CGPointMake(newContentOffsetX, self.contentOffset.y)];
}

- (void)centerContentVertically {
    CGFloat newContentOffsetY = (self.contentSize.height - self.bounds.size.height) * 0.5f;
    [self setContentOffset:CGPointMake(self.contentOffset.x, newContentOffsetY)];
}

@end
