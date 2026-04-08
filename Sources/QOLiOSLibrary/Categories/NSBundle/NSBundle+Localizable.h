//
//  NSBundle+Localizable.h
//  QOL-iOS-Library
//
//  Created by Isaac Paul on 4/14/20.
//  Copyright © 2020 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThisBundle : NSObject

@end

@interface NSBundle (Localizable)

+ (NSBundle*)QOLBundle;
+ (NSBundle*)bundleForClass:(Class)aClass bundleName:(NSString*)bundleName;
- (NSString*)localized:(NSString*)text;
- (NSString*)localized:(NSString*)text fileName:(NSString*)name;

@end

