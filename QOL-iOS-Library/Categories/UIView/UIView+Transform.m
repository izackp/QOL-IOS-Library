//
//  UIView+Transform.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 3/26/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIView+Transform.h"
#import "UIView+Positioning.h"

@implementation UIView (Transform)

- (void)rotate90Degrees:(bool)clockwise {
    //TODO: Use actual names instead of 'idk'
    CGFloat idk = M_PI * !self.transform.a;
    CGFloat finalIdk = M_PI_2 - idk;
    self.transform = CGAffineTransformRotate(self.transform, finalIdk);
}

- (void)scaleWidthWithAspectRatio:(CGFloat)newWidth {
    CGFloat oldWidth = self.width;
    CGFloat scaleFactor = newWidth / oldWidth;
    
    self.height = self.height * scaleFactor;
    self.width = oldWidth * scaleFactor;
}

@end
