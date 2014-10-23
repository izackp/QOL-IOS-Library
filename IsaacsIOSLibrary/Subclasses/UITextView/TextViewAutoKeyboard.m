//
//  TextViewAutoKeyboard.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "TextViewAutoKeyboard.h"
#import "UIApplication+EasyAccess.h"

@interface TextViewAutoKeyboard () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITapGestureRecognizer* tapGesture;
@property (assign, nonatomic) UIView* viewWithTapGesture;

@end

@implementation TextViewAutoKeyboard

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOut)];
    self.viewWithTapGesture = [UIApplication getMainWindowRootViewController].view;
    
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
    if (touch.view == self || [touch.view isDescendantOfView:self])
        return NO;
    if ([touch.view isKindOfClass:[UITextField class]])
        return NO;
    if ([touch.view isKindOfClass:[UITextView class]])
        return NO;
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        [self performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.1];//TODO:Hacky
        return NO;
    }
    return YES;
}
@end
