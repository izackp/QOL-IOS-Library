//
//  UIView+Transform.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 3/26/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIView+Transform.h"

@implementation UIView (Transform)

- (void)rotate90Degrees:(bool)clockwise {
    //TODO: Use actual names instead of 'idk'
    CGFloat idk = M_PI * !self.transform.a;
    CGFloat finalIdk = M_PI_2 - idk;
    self.transform = CGAffineTransformRotate(self.transform, finalIdk);
}

@end
