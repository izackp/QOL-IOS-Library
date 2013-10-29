//
//  TextFieldAutoKeyboard.m
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

- (id)init {
    if (self = [super init])
        [self customInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
        [self customInit];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
        [self customInit];
    return self;
}

- (void)customInit {
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
    if (touch.view == self)
        return NO;
    return YES;
}
@end
