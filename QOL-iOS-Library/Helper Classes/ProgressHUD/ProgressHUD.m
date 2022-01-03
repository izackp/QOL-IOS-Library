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

@synthesize font, clrStatus, clrSpinner, clrBackground, imgSuccess, imgError, clrProgressBG, clrProgressFG;

+ (ProgressHUDScheme*)light {
    ProgressHUDScheme* scheme = [ProgressHUDScheme new];
    scheme.font = [UIFont boldSystemFontOfSize:16];
    scheme.clrStatus = [UIColor blackColor];
    scheme.clrSpinner = [UIColor blackColor];
    scheme.clrBackground = [UIColor colorWithWhite:0 alpha:0.1];
    scheme.clrProgressBG = [UIColor colorWithWhite:0.95 alpha:1];
    scheme.clrProgressFG = [UIColor colorWithWhite:0.85 alpha:1];
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
    scheme.clrProgressBG = [UIColor colorWithWhite:0.5 alpha:1];//Need to update for dark
    scheme.clrProgressFG = [UIColor colorWithWhite:0.7 alpha:1];
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

+ (UIWindow*)findNormalWindow {
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows)
        if (window.windowLevel == UIWindowLevelNormal) {
            return window;
        }
    
    return nil;
}

+ (void)setUserInteractionOnNormalWindow:(bool)enabled {
    UIWindow* normWindow = [self findNormalWindow];
    [normWindow setUserInteractionEnabled:enabled];
}

+ (void)dismiss {
    [self reset];
	[[self shared] hudHide];
}

+ (void)reset {
    sLastText = nil;
    [self setUserInteractionOnNormalWindow:true];
}

+ (void)updateScheme {
    if (@available(iOS 12.0, *)) {
        UIWindow* normWindow = [self findNormalWindow];
        UIUserInterfaceStyle style = normWindow.rootViewController.traitCollection.userInterfaceStyle;
        ProgressHUD* hud = [ProgressHUD shared];
        switch (style) {
        case UIUserInterfaceStyleLight:
            [hud setScheme:[ProgressHUDScheme light]];
                break;
        case UIUserInterfaceStyleDark:
            [hud setScheme:[ProgressHUDScheme dark]];
                break;
        default:
            [hud setScheme:[ProgressHUDScheme light]];
        }
    } else {
        // Fallback on earlier versions
    }
}

+ (void)show:(NSString *)status {
    [self show:status allowInteraction:true];
}

static NSString* sLastText = nil;

+ (void)show:(NSString *)status allowInteraction:(BOOL)Interaction {
    if ([status isEqualToString:sLastText])
        return;
    sLastText = status;
    [self updateScheme];
    
    [self setUserInteractionOnNormalWindow:Interaction];
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status image:nil spin:YES hide:NO];
}

+ (void)showSuccessBriefly:(NSString *)status {
    [self showSuccessBriefly:status allowInteraction:true];
}

+ (void)showSuccessBriefly:(NSString *)status allowInteraction:(BOOL)Interaction {
    [self updateScheme];
    [self reset];
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status image:[[self shared] imgSuccess] spin:NO hide:YES];
}

+ (void)showErrorBriefly:(NSString *)status {
    [self showErrorBriefly:status allowInteraction:true];
}

+ (void)showErrorBriefly:(NSString *)status allowInteraction:(BOOL)Interaction {
    [self updateScheme];
    [self reset];
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status image:[[self shared] imgError] spin:NO hide:YES];
}


- (id)init {
	self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
	
	id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
	
	if ([delegate respondsToSelector:@selector(window)])
		window = [delegate performSelector:@selector(window)];
	else
        window = [[UIApplication sharedApplication] keyWindow];
	
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

- (void)hudMake:(NSString *)status image:(UIImage *)img spin:(BOOL)spin hide:(BOOL)hide {
	[self hudCreate];
	
	label.text = status;
	label.hidden = (status == nil) ? YES : NO;
	
	image.image = img;
	image.hidden = (img == nil) ? YES : NO;
	
	if (spin)
        [spinner startAnimating];
    else
        [spinner stopAnimating];
	
	[self hudSize];
	[self hudShow];
	
    if (hide) {
        _viewProgressBG.alpha = 1;
        _viewProgressFG.alpha = 1;
        NSTimeInterval sleep = [self sleepLength];
        
        [UIView animateWithDuration:sleep delay:0 options:0 animations:^{
            [self hideProgressFG];
        } completion:^(BOOL finished){ }];
        
        [NSThread detachNewThreadSelector:@selector(timedHide:)
                                 toTarget:self
                               withObject:[NSNumber numberWithDouble:sleep]];
         
    } else {
        _viewProgressBG.alpha = 0;
        _viewProgressFG.alpha = 0;
    }
}

- (void)hideProgressFG {
    _viewProgressFG.frame = CGRectMake(0, _viewProgressFG.frame.origin.y, 0, _viewProgressFG.frame.size.height);
}

- (void)hudCreate {
	if (hud == nil) {
		hud = [[UIToolbar alloc] initWithFrame:CGRectZero];
		hud.translucent = YES;
		hud.backgroundColor = scheme.clrBackground;
		hud.layer.cornerRadius = 10;
		hud.layer.masksToBounds = YES;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	}
	
	if (hud.superview == nil) {
		if (interaction == NO) {
			CGRect frame = CGRectMake(window.frame.origin.x, window.frame.origin.y, window.frame.size.width, window.frame.size.height);
			background = [[UIView alloc] initWithFrame:frame];
			background.backgroundColor = [UIColor clearColor];
			[window addSubview:background];
			[background addSubview:hud];
		} else {
            [window addSubview:hud];
        }
	}
	
	if (spinner == nil) {
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.color = scheme.clrSpinner;
		spinner.hidesWhenStopped = YES;
	}
    
	if (spinner.superview == nil)
        [hud addSubview:spinner];
	
	if (image == nil)
		image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];

	if (image.superview == nil)
        [hud addSubview:image];
	
	if (label == nil) {
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = scheme.font;
		label.textColor = scheme.clrStatus;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		label.numberOfLines = 0;
	}
    
	if (label.superview == nil)
        [hud addSubview:label];
    
    if (_viewProgressBG == nil) {
        _viewProgressBG = [[UIView alloc] initWithFrame:CGRectZero];
        _viewProgressBG.backgroundColor = scheme.clrProgressBG;
    }
    
    if (_viewProgressBG.superview == nil)
        [hud addSubview:_viewProgressBG];
	
    if (_viewProgressFG == nil) {
        _viewProgressFG = [[UIView alloc] initWithFrame:CGRectZero];
        _viewProgressFG.backgroundColor = scheme.clrProgressFG;
    }
    
    if (_viewProgressFG.superview == nil)
        [hud addSubview:_viewProgressFG];
}

- (void)hudDestroy {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	
	[label removeFromSuperview];
    label = nil;
	[image removeFromSuperview];
    image = nil;
	[spinner removeFromSuperview];
    spinner = nil;
	[hud removeFromSuperview];
    hud = nil;
	[background removeFromSuperview];
    background = nil;
    [_viewProgressBG removeFromSuperview];
    _viewProgressBG = nil;
    [_viewProgressFG removeFromSuperview];
    _viewProgressFG = nil;
}

- (void)rotate:(NSNotification *)notification {
	[self hudOrient];
}

static CGFloat sRotation = 0.0f;

- (void)hudOrient {
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

- (void)hudSize {
	CGRect labelRect = CGRectZero;
	CGFloat hudWidth = 100, hudHeight = 100, progressHeight = 1;
	
	if (label.text != nil) {
		NSDictionary *attributes = @{NSFontAttributeName:label.font};
		NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
		labelRect = [label.text boundingRectWithSize:CGSizeMake(200, 300) options:options attributes:attributes context:NULL];

		labelRect.origin.x = 12;
		labelRect.origin.y = 66;

		hudWidth = labelRect.size.width + 24;
		hudHeight = labelRect.size.height + 80;

		if (hudWidth < 100) {
			hudWidth = 100;
			labelRect.origin.x = 0;
			labelRect.size.width = 100;
		}
	}
	
	CGSize screen = [UIScreen mainScreen].bounds.size;
	
	hud.center = CGPointMake(screen.width/2, screen.height/2);
	hud.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    
    _viewProgressBG.frame = CGRectMake(0, hudHeight-progressHeight, hudWidth, progressHeight);
    _viewProgressFG.frame = CGRectMake(0, hudHeight-progressHeight, hudWidth, progressHeight);
	
	CGFloat imagex = hudWidth/2;
	CGFloat imagey = (label.text == nil) ? hudHeight/2 : 36;
	image.center = spinner.center = CGPointMake(imagex, imagey);
	
	label.frame = labelRect;
    hud.transform = CGAffineTransformMakeRotation(sRotation);
}

- (void)hudShow {
	if (self.alpha == 0) {
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

- (void)hudHide {
	if (self.alpha == 1) {
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

- (NSTimeInterval)sleepLength {
    double length = label.text.length;
    NSTimeInterval sleep = length * 0.04 + 1;
    if (sleep > 5) {
        sleep = 5;
    }
    return sleep;
}

- (void)timedHide:(NSNumber*)sleep {
	@autoreleasepool {
		[NSThread sleepForTimeInterval:sleep.doubleValue];
		[self performSelectorOnMainThread:@selector(hudHide) withObject:nil waitUntilDone:false];
	}
}

@end
