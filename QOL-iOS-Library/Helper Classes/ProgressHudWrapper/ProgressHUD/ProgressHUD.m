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

#import "ProgressHUD.h"

@implementation ProgressHUDScheme

@synthesize font, clrStatus, clrSpinner, clrBackground, imgSuccess, imgError;

+ (ProgressHUDScheme*)light {
    ProgressHUDScheme* scheme = [ProgressHUDScheme new];
    scheme.font = [UIFont boldSystemFontOfSize:16];
    scheme.clrStatus = [UIColor blackColor];
    scheme.clrSpinner = [UIColor blackColor];
    scheme.clrBackground = [UIColor colorWithWhite:0 alpha:0.1];
    scheme.imgSuccess = @"ProgressHUD.bundle/success-color.png";
    scheme.imgError = @"ProgressHUD.bundle/error-color.png";
    return scheme;
}

+ (ProgressHUDScheme*)dark {
    ProgressHUDScheme* scheme = [ProgressHUDScheme new];
    scheme.font = [UIFont boldSystemFontOfSize:16];
    scheme.clrStatus = [UIColor whiteColor];
    scheme.clrSpinner = [UIColor whiteColor];
    scheme.clrBackground = [UIColor colorWithWhite:1 alpha:0.1];
    scheme.imgSuccess = @"ProgressHUD.bundle/success-color.png";
    scheme.imgError = @"ProgressHUD.bundle/error-color.png";
    return scheme;
}

@end

@implementation ProgressHUD

@synthesize interaction, window, background, hud, spinner, image, label, scheme;

+ (ProgressHUD *)shared
{
	static dispatch_once_t once = 0;
	static ProgressHUD *progressHUD;
	
	dispatch_once(&once, ^{ progressHUD = [[ProgressHUD alloc] init]; });
	
	return progressHUD;
}

+ (void)dismiss
{
	[[self shared] hudHide];
}

+ (void)show:(NSString *)status
{
	[self shared].interaction = YES;
	[[self shared] hudMake:status imgage:nil spin:YES hide:NO];
}

+ (void)show:(NSString *)status Interaction:(BOOL)Interaction
{
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status imgage:nil spin:YES hide:NO];
}

+ (void)showSuccess:(NSString *)status
{
	[self shared].interaction = YES;
	[[self shared] hudMake:status imgage:[[self shared] imgSuccess] spin:NO hide:YES];
}

+ (void)showSuccess:(NSString *)status Interaction:(BOOL)Interaction
{
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status imgage:[[self shared] imgSuccess] spin:NO hide:YES];
}

+ (void)showError:(NSString *)status
{
	[self shared].interaction = YES;
	[[self shared] hudMake:status imgage:[[self shared] imgError] spin:NO hide:YES];
}

+ (void)showError:(NSString *)status Interaction:(BOOL)Interaction
{
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status imgage:[[self shared] imgError] spin:NO hide:YES];
}

- (id)init
{
	self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
	
	id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
	
	if ([delegate respondsToSelector:@selector(window)])
		window = [delegate performSelector:@selector(window)];
	else window = [[UIApplication sharedApplication] keyWindow];
	
	background = nil; hud = nil; spinner = nil; image = nil; label = nil;
	
	self.alpha = 0;
    scheme = [ProgressHUDScheme light];
	
	return self;
}

- (UIImage*)imgSuccess {
    return [UIImage imageNamed:scheme.imgSuccess];
}

- (UIImage*)imgError {
    return [UIImage imageNamed:scheme.imgError];
}

- (void)hudMake:(NSString *)status imgage:(UIImage *)img spin:(BOOL)spin hide:(BOOL)hide
{
	[self hudCreate];
	
	label.text = status;
	label.hidden = (status == nil) ? YES : NO;
	
	image.image = img;
	image.hidden = (img == nil) ? YES : NO;
	
	if (spin)
        [spinner startAnimating]; else [spinner stopAnimating];
	
	[self hudSize];
	[self hudShow];
	
	if (hide)
        [NSThread detachNewThreadSelector:@selector(timedHide:) toTarget:self withObject:[NSNumber numberWithUnsignedInteger:label.text.length]];
}

- (void)hudCreate
{
	
	if (hud == nil)
	{
		hud = [[UIToolbar alloc] initWithFrame:CGRectZero];
		hud.translucent = YES;
		hud.backgroundColor = scheme.clrBackground;
		hud.layer.cornerRadius = 10;
		hud.layer.masksToBounds = YES;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	}
	
	if (hud.superview == nil)
	{
		if (interaction == NO)
		{
			CGRect frame = CGRectMake(window.frame.origin.x, window.frame.origin.y, window.frame.size.width, window.frame.size.height);
			background = [[UIView alloc] initWithFrame:frame];
			background.backgroundColor = [UIColor clearColor];
			[window addSubview:background];
			[background addSubview:hud];
		}
		else [window addSubview:hud];
	}
	
	if (spinner == nil)
	{
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.color = scheme.clrSpinner;
		spinner.hidesWhenStopped = YES;
	}
	if (spinner.superview == nil) [hud addSubview:spinner];
	
	if (image == nil)
	{
		image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
	}
	if (image.superview == nil) [hud addSubview:image];
	
	if (label == nil)
	{
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = scheme.font;
		label.textColor = scheme.clrStatus;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		label.numberOfLines = 0;
	}
	if (label.superview == nil) [hud addSubview:label];
	
}

- (void)hudDestroy
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	
	[label removeFromSuperview];		label = nil;
	[image removeFromSuperview];		image = nil;
	[spinner removeFromSuperview];		spinner = nil;
	[hud removeFromSuperview];			hud = nil;
	[background removeFromSuperview];	background = nil;
}

- (void)rotate:(NSNotification *)notification
{
	[self hudOrient];
}

static CGFloat sRotation = 0.0f;

- (void)hudOrient
{
    CGFloat rotate = 0.0;
    
    UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orient == UIInterfaceOrientationPortrait)
        rotate = 0.0;
    if (orient == UIInterfaceOrientationPortraitUpsideDown)
        rotate = M_PI;
    if (orient == UIInterfaceOrientationLandscapeLeft)
        rotate = - M_PI_2;
    if (orient == UIInterfaceOrientationLandscapeRight)
        rotate = + M_PI_2;
    
    sRotation = rotate;
    hud.transform = CGAffineTransformMakeRotation(rotate);
}

- (void)hudSize
{
	CGRect labelRect = CGRectZero;
	CGFloat hudWidth = 100, hudHeight = 100;
	
	if (label.text != nil)
	{
		NSDictionary *attributes = @{NSFontAttributeName:label.font};
		NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
		labelRect = [label.text boundingRectWithSize:CGSizeMake(200, 300) options:options attributes:attributes context:NULL];

		labelRect.origin.x = 12;
		labelRect.origin.y = 66;

		hudWidth = labelRect.size.width + 24;
		hudHeight = labelRect.size.height + 80;

		if (hudWidth < 100)
		{
			hudWidth = 100;
			labelRect.origin.x = 0;
			labelRect.size.width = 100;
		}
	}
	
	CGSize screen = [UIScreen mainScreen].bounds.size;
	
	hud.center = CGPointMake(screen.width/2, screen.height/2);
	hud.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
	
	CGFloat imagex = hudWidth/2;
	CGFloat imagey = (label.text == nil) ? hudHeight/2 : 36;
	image.center = spinner.center = CGPointMake(imagex, imagey);
	
	label.frame = labelRect;
    hud.transform = CGAffineTransformMakeRotation(sRotation);
}

- (void)hudShow
{
	if (self.alpha == 0)
	{
		self.alpha = 1;

		hud.alpha = 0;
		hud.transform = CGAffineTransformScale(hud.transform, 1.4, 1.4);

		NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;

		[UIView animateWithDuration:0.15 delay:0 options:options animations:^{
            self->hud.transform = CGAffineTransformScale(self->hud.transform, 1/1.4, 1/1.4);
            self->hud.alpha = 1;
		}
		completion:^(BOOL finished){ }];
	}
}

- (void)hudHide
{
	if (self.alpha == 1)
	{
		NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;

		[UIView animateWithDuration:0.15 delay:0 options:options animations:^{
            self->hud.transform = CGAffineTransformScale(self->hud.transform, 0.7, 0.7);
            self->hud.alpha = 0;
		}
		completion:^(BOOL finished)
		{
			[self hudDestroy];
			self.alpha = 0;
		}];
	}
}

- (void)timedHide:(NSNumber*)textLength
{
	@autoreleasepool
	{
		double length = textLength.doubleValue;
		NSTimeInterval sleep = length * 0.04 + 0.5;
        if (sleep > 5) {
            sleep = 5;
        }
		
		[NSThread sleepForTimeInterval:sleep];
		[self performSelectorOnMainThread:@selector(hudHide) withObject:nil waitUntilDone:false];
	}
}

@end
