//
//  UIImagePickerController+EasyAccess.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

//Disabled.. maybe outdated

#import <UIKit/UIKit.h>

@interface UIImagePickerController (EasyAccess)

- (void)getMediaFromDevice;
- (void)getMediaFromCamera;

- (void)presentPicker;

- (void)setMediaTypePhotoAndVideo;
- (void)setMediaTypePhoto;
- (void)setMediaTypeVideo;
@end
