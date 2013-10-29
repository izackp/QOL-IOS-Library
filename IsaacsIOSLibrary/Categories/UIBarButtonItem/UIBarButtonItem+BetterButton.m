//
//  UIBarButtonItem+BetterButton.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIBarButtonItem+BetterButton.h"

@implementation UIBarButtonItem (BetterButton)

+ (UIBarButtonItem *)buttonFromImage:(UIImage *)image andTarget:(id)target andAction:(SEL)action
{
    return [UIBarButtonItem buttonFromImage:image andTarget:target andAction:action andSize:image.size];
}

+ (UIBarButtonItem *)buttonFromImage:(UIImage *)image andTarget:(id)target andAction:(SEL)action andSize:(CGSize)size
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return btn;
}

@end
