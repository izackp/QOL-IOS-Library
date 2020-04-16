//
//  NSBundle+Localizable.m
//  QOL-iOS-Library
//
//  Created by Isaac Paul on 4/14/20.
//  Copyright © 2020 Isaac Paul. All rights reserved.
//

#import "NSBundle+Localizable.h"


@implementation NSBundle (Localizable)

+ (NSBundle*)QOLBundle {
    NSBundle *classBundle = [NSBundle bundleForClass:[ThisBundle class]];
    return classBundle;
}

+ (NSBundle*)bundleForClass:(Class)aClass bundleName:(NSString*)bundleName {
    NSBundle *classBundle = [NSBundle bundleForClass:aClass];
    NSURL *resourceBundleURL = [classBundle URLForResource:bundleName withExtension:@"bundle"];
    if (resourceBundleURL) {
        NSBundle *resourceBundle = [[NSBundle alloc] initWithURL:resourceBundleURL];
        return resourceBundle;
    }
    return classBundle;
}

- (NSString*)localized:(NSString*)text {
    return [self localized:text fileName:@"Localizable"];
}

- (NSString*)localized:(NSString*)text fileName:(NSString*)name {
    return NSLocalizedStringFromTableInBundle(text, name, self, nil);
}

@end


@implementation ThisBundle

@end


