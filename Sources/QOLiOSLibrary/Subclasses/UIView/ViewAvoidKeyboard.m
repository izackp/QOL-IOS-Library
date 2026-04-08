//
//  ViewAvoidKeyboard.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/21/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import "ViewAvoidKeyboard.h"
#import "UIView+Positioning.h"
#import "UIView+Shortcuts.h"

@interface ViewAvoidKeyboard ()

@property (assign, nonatomic) BOOL keyboardIsShown;

@end

@implementation ViewAvoidKeyboard

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _keyboardIsShown = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    if ([self isVisible] == false)
        return;
    
    NSDictionary* userInfo = [note userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.height += keyboardSize.height;
    
    [UIView commitAnimations];
    
    _keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)note
{
    if (_keyboardIsShown)
        return;
    
    if ([self isVisible] == false)
        return;
    
    NSDictionary* userInfo = [note userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.height -= keyboardSize.height;
    
    [UIView commitAnimations];
    _keyboardIsShown = YES;
}

@end
