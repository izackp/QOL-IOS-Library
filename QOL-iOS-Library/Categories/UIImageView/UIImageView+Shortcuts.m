//
//  UIImageView+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 1/21/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIImageView+Shortcuts.h"

@implementation UIImageView (Shortcuts)

- (void)setImageWithName:(NSString*)imageName {
    [self setImage:[UIImage imageNamed:imageName]];
}

@end
