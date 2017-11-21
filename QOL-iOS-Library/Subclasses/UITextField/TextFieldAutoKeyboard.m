//
//  TextFieldAutoKeyboard.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "TextFieldAutoKeyboard.h"
#import "UIApplication+EasyAccess.h"

@interface TextFieldAutoKeyboard () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIGestureRecognizer* tapGesture;
@property (assign, nonatomic) UIView* viewWithTapGesture;

@end

@implementation TextFieldAutoKeyboard

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOut)];
    self.viewWithTapGesture = [UIApplication getMainWindow];

    [_tapGesture setDelegate:self];
}

- (BOOL)becomeFirstResponder {
    [_viewWithTapGesture addGestureRecognizer:_tapGesture];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [_viewWithTapGesture removeGestureRecognizer:_tapGesture];
    return [super resignFirstResponder];
}

- (void)clickOut {
    [self resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == nil)
        return NO;
    if (touch.view == self || [touch.view isDescendantOfView:self])
        return NO;
    if ([touch.view isKindOfClass:[UITextField class]])
        return NO;
    if ([touch.view isKindOfClass:[UITextView class]])
        return NO;
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        UIButton* button = (UIButton*)touch.view;
        if (button.isEnabled)
            return NO;
        return YES;
    }
    return YES;
}
@end
