//
//  Widget.m
//  Game Library
//
//  Created by Isaac Paul on 5/16/14.
//  Copyright (c) 2014 NA. All rights reserved.
//

#import "Widget.h"
#import "UIView+Positioning.h"

@interface Widget ()

@property (strong, nonatomic, readwrite) UIView* view;

@end

@implementation Widget

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    
    bool unFlexableWidth = (self.view.autoresizingMask & UIViewAutoresizingFlexibleWidth);
    bool unFlexableHeight = (self.view.autoresizingMask & UIViewAutoresizingFlexibleHeight);
    
    if (unFlexableWidth)
        self.width = self.view.width;
    
    if (unFlexableHeight)
        self.height = self.view.height;
    
    [self addSubview:self.view];
}

@end
