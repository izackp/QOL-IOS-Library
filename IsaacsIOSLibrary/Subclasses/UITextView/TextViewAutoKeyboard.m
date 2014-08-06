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
    return YES;
}
@end
