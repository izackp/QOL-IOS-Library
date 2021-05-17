//
//  UIView+Shortcuts.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 11/6/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Shortcuts)

+ (instancetype)createFromNib;
+ (instancetype)createFromNib:(NSString*)nibName;

- (bool)isVisible;

- (void)removeAllSubviews;

- (UIImage*)generateImage;

- (void)swapWithView:(UIView*)view;

- (id)recursiveDescription;

@end
