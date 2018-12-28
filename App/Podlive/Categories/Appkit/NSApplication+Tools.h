//
//  Created by Frank Gregor on 30.12.14.
//  Copyright (c) 2014 cocoa:naut. All rights reserved.
//

@interface NSApplication (Tools)

/**
 Creates and returns a string with the value of `CFBundleName` of the main bundle.

 @return The value of `CFBundleName`.
 */
+ (NSString *)applicationName;

/**
 Creates and returns a string with the value of `CFBundleShortVersionString` of the main bundle.

 @return The value of `CFBundleShortVersionString`.
 */
+ (NSString *)applicationVersion;

/**
 Creates and returns a string with the value of `CFBundleVersion` of the main bundle.

 @return The value of `CFBundleVersion`.
 */
+ (NSString *)applicationBuildNumber;

@end
