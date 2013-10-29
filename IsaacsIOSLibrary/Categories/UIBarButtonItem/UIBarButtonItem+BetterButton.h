//
//  UIBarButtonItem+BetterButton.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BetterButton)

+ (UIBarButtonItem *)buttonFromImage:(UIImage *)image andTarget:(id)target andAction:(SEL)action;
+ (UIBarButtonItem *)buttonFromImage:(UIImage *)image andTarget:(id)target andAction:(SEL)action andSize:(CGSize)size;

@end
