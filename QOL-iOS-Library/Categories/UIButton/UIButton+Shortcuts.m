//
//  UIButton+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 1/22/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIButton+Shortcuts.h"

@implementation UIButton (Shortcuts)

- (void)setImageWithName:(NSString*)name {
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

@end
