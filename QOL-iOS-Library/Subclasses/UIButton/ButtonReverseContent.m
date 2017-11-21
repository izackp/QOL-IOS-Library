//
//  ButtonReverseContent.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "ButtonReverseContent.h"

@implementation ButtonReverseContent

- (void)layoutSubviews
{
    // Allow default layout, then adjust image and label positions
    [super layoutSubviews];
    
    UIImageView *imageView = [self imageView];
    UILabel *label = [self titleLabel];
    
    CGRect imageFrame = imageView.frame;
    CGRect labelFrame = label.frame;
    
    labelFrame.origin.x = imageFrame.origin.x;
    imageFrame.origin.x = labelFrame.origin.x + CGRectGetWidth(labelFrame) + self.titleEdgeInsets.left;
    
    imageView.frame = imageFrame;
    label.frame = labelFrame;
}

@end
