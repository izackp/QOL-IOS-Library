//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

@class WeakTimedSelector;

@interface ProgressHUDScheme : NSObject

@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) UIColor* clrStatus;
@property (nonatomic, retain) UIColor* clrSpinner;
@property (nonatomic, retain) UIColor* clrBackground;
@property (nonatomic, retain) NSString* imgSuccess;
@property (nonatomic, retain) NSString* imgError;
@property (nonatomic, retain) UIColor* clrProgressBG;
@property (nonatomic, retain) UIColor* clrProgressFG;
@property (nonatomic, retain) UIColor* clrProgressFGError;
@property (nonatomic, retain) UIColor* clrProgressFGSuccess;

+ (ProgressHUDScheme*)light;
+ (ProgressHUDScheme*)dark;

@end

@interface ProgressHUD : UIView

+ (ProgressHUD *)shared;
+ (UIWindow*)findNormalWindow;

+ (void)dismiss;

+ (void)show:(NSString *)text;
+ (void)show:(NSString *)text allowInteraction:(BOOL)Interaction;

+ (void)showSuccessBriefly:(NSString *)text;
+ (void)showSuccessBriefly:(NSString *)text allowInteraction:(BOOL)Interaction;

+ (void)showErrorBriefly:(NSString *)text;
+ (void)showErrorBriefly:(NSString *)text allowInteraction:(BOOL)Interaction;

@property (nonatomic, assign) BOOL interaction;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIView *background;
@property (nonatomic, retain) UIToolbar *hud;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) ProgressHUDScheme *scheme;
@property (nonatomic, retain) UIView *viewProgressBG;
@property (nonatomic, retain) UIView *viewProgressFG;

@property (nonatomic, retain) WeakTimedSelector *timedSel;

@end
