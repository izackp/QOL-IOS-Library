//
//  ViewAutoKeyboardColor.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//
//

//Just add this class in a nib file and it will automatically do the rest. You don't even have to worry if its on top or not
//actualKeyboardBG Will show up behind the keyboard as long as this view is attached to another view
//TODO: Need way to ignore showing this view if the view it is attached to is not 'visible'

#import "ViewAutoKeyboardColor.h"
#import "UIView+Positioning.h"

@interface ViewAutoKeyboardColor ()
@property (strong, nonatomic) UIView* actualKeyboardBG;
@end


@implementation ViewAutoKeyboardColor
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

- (void)customInit {
    self.actualKeyboardBG = [[UIView alloc] init];
    [_actualKeyboardBG setBackgroundColor:self.backgroundColor];
    [self attachToRootView];
    [self setAlpha:0.0f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_actualKeyboardBG removeFromSuperview];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [_actualKeyboardBG setBackgroundColor:backgroundColor];
}

- (void)attachToRootView {
    NSAssert(_actualKeyboardBG, @"Cannot be nil");
    UIApplication* app = [UIApplication sharedApplication];
    UIView* rootView = app.delegate.window.rootViewController.view;
    [rootView addSubview:_actualKeyboardBG];
    [self resetPosition];
    NSAssert(_actualKeyboardBG.superview, @"Cannot be nil");
}

- (void)resetPosition {
    UIApplication* app = [UIApplication sharedApplication];
    UIView* rootView = app.delegate.window.rootViewController.view;
    _actualKeyboardBG.y = rootView.height;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    _actualKeyboardBG.size = keyboardRect.size;
    [self resetPosition];
    [_actualKeyboardBG.superview bringSubviewToFront:_actualKeyboardBG];
        
    [UIView animateWithDuration:animationDuration animations:^(void) {
        _actualKeyboardBG.y = _actualKeyboardBG.y - keyboardHeight;
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
   	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^(void) {
        _actualKeyboardBG.y = _actualKeyboardBG.y + keyboardHeight;
    }];
}

@end
