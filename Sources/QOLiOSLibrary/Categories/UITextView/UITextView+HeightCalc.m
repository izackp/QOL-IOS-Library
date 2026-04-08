//
//  UITextView+HeightCalc.m
//  PhotoDay
//
//  Created by Isaac Paul on 2/13/18.
//  Copyright © 2018 Snapshots. All rights reserved.
//

#import "UITextView+HeightCalc.h"

@implementation UITextView (HeightCalc)

const NSStringDrawingOptions kDrawingOptions = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine;

+ (CGFloat)heightForWidth:(CGFloat)width text:(id)text font:(UIFont *)font edgeInsets:(UIEdgeInsets)edgeInsets numberOfLines:(NSUInteger)numberOfLines
{
    CGSize insettedSize = CGSizeMake(MAX(width - edgeInsets.left - edgeInsets.right, 0), CGFLOAT_MAX);
    CGFloat height;
    
    if ([text isKindOfClass:[NSString class]]) {
        height = [text boundingRectWithSize:insettedSize options:kDrawingOptions attributes:@{NSFontAttributeName: font} context:nil].size.height;
    } else {
        height = [text boundingRectWithSize:insettedSize options:kDrawingOptions context:nil].size.height;
    }
    
    if (numberOfLines > 0) {
        CGFloat maxHeight = font.lineHeight * numberOfLines;
        
        if (height > maxHeight) {
            height = maxHeight;
        }
    }
    
    height += edgeInsets.top + edgeInsets.bottom;
    
    return ceilf(height);
}

@end
