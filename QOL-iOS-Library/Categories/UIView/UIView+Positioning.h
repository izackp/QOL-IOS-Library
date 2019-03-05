//
//  UIView+Positioning.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Positioning)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGPoint positionInWindow;

- (void)setWidthCenterAnchored:(CGFloat)width;
- (void)setHeightCenterAnchored:(CGFloat)height;

- (void)cropForVisibleSubviews;

- (void)centerSubviewsVerticallyWithPadding:(CGFloat)padding;

- (void)evenlySpaceSubviewsHorizontally;

- (void)alignViewsToTheLeft:(CGFloat)padding;

- (void)setRightAnchored:(CGFloat)value;
- (void)setBottomAnchored:(CGFloat)value;

@end
