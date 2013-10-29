//
//  UIImagePickerController+EasyAccess.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIImagePickerController+EasyAccess.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation UIImagePickerController (EasyAccess)

- (void)getMediaFromDevice {
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentPicker];
}

- (void)getMediaFromCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self getMediaFromDevice];
        return;
    }
    
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:self.sourceType])
        [self getMediaFromDevice];
    [self presentPicker];
}

- (void)presentPicker {
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:self animated:YES completion:nil];
    
    //we are just delaying the hiding of the status bar to avoid weird UI jumpyness
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [self showStatusBar];
        [self performSelector:@selector(hideStatusBar) withObject:nil afterDelay:0.3];
    }
}

- (void)showStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
}

- (void)hideStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationSlide];
}

- (void)fixCameraUIForStatusBar {
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        CGRect frame = self.view.frame;
        frame.origin.y += 10.0f;
        frame.size.height -= 10.0f;
        self.view.frame = frame;
    }
}

- (void)setMediaTypePhotoAndVideo {
    self.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, kUTTypeMovie, nil];
}

- (void)setMediaTypePhoto {
    self.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
}

- (void)setMediaTypeVideo {
    self.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
}

@end
