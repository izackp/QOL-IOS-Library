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

@end
