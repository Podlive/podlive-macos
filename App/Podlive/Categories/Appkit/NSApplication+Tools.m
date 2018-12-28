//
//  Created by Frank Gregor on 30.12.14.
//  Copyright (c) 2014 cocoa:naut. All rights reserved.
//

#import "NSApplication+Tools.h"

@implementation NSApplication (CCNAppKit)

+ (NSString *)applicationName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

+ (NSString *)applicationVersion {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"%@", infoDict[@"CFBundleShortVersionString"]];
    return version;
}

+ (NSString *)applicationBuildNumber {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"%@", infoDict[@"CFBundleVersion"]];
    return version;
}

@end
