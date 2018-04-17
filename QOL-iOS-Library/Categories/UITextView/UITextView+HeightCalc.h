//
//  UITextView+HeightCalc.h
//  PhotoDay
//
//  Created by Isaac Paul on 2/13/18.
//  Copyright © 2018 Snapshots. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (HeightCalc)

+ (CGFloat)heightForWidth:(CGFloat)width text:(id)text font:(UIFont *)font edgeInsets:(UIEdgeInsets)edgeInsets numberOfLines:(NSUInteger)numberOfLines;

@end
