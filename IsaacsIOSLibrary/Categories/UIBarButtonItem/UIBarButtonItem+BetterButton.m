//
//  UIBarButtonItem+BetterButton.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIBarButtonItem+BetterButton.h"
#import "UIView+Positioning.h"

@implementation UIBarButtonItem (BetterButton)

+ (UIBarButtonItem *)buttonFromImage:(UIImage *)image andText:(NSString*)text andTarget:(id)target andAction:(SEL)action
{
    return [UIBarButtonItem buttonFromImage:image andText:text andTarget:target andAction:action andSize:image.size];
}

+ (UIBarButtonItem *)buttonFromImage:(UIImage *)image andTarget:(id)target andAction:(SEL)action
{
    return [UIBarButtonItem buttonFromImage:image andText:nil andTarget:target andAction:action andSize:image.size];
}

+ (UIBarButtonItem *)buttonFromImage:(UIImage *)image andText:(NSString*)text andTarget:(id)target andAction:(SEL)action andSize:(CGSize)size
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:text forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return btn;
}

+ (UIBarButtonItem*)buttonUsingButton:(UIButton*)button withOffset:(CGPoint)offset {

    [button setFrame:CGRectMake(0.0f, 0.0f, button.imageView.image.size.width, button.imageView.image.size.height)];
    
    UIView *backButtonView = [[UIView alloc] initWithFrame:button.bounds];
    backButtonView.bounds = CGRectOffset(backButtonView.bounds, offset.x, offset.y);
    [backButtonView addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:backButtonView];

}

@end
