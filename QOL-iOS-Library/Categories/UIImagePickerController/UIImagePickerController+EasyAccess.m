//
//  UIImagePickerController+EasyAccess.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIImagePickerController+EasyAccess.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIAlertView+Shortcuts.h"

@implementation UIImagePickerController (EasyAccess)

- (void)getMediaFromDevice {
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentPicker];
}

- (void)getMediaFromCamera {
    if (![UIImagePickerController isAnyCameraAvailable])
    {
        [self getMediaFromDevice];
        [UIAlertView showMessage:@"Could not find a camera device."];
        return;
    }
    
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    //[self getMediaFromDevice
    [self presentPicker];
}

- (void)presentPicker {
    [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:self animated:YES completion:nil];
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

+ (bool)isAnyCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@end
