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

@end
