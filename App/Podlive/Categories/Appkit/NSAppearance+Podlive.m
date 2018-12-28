//
//  Created by Frank Gregor on 04/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSAppearance+Podlive.h"

NSString *const CCNPrefsCurrentAppearance = @"CCNCurrentAppearance";

@implementation NSAppearance (Podlive)

+ (CCNApplicationAppearance)applicationAppearance {
    NSString *appearance = [NSAppearance applicationAppearanceName];
    if ([appearance isEqualToString:NSAppearanceNameAqua]) {
        return CCNApplicationAppearanceAqua;
    }
    else if ([appearance isEqualToString:NSAppearanceNameVibrantDark]) {
        return CCNApplicationAppearanceDark;
    }
    else {
        return CCNApplicationAppearanceAqua;
    }
}

+ (void)setApplicationAppearance:(CCNApplicationAppearance)applicationAppearance {
    switch (applicationAppearance) {
        case CCNApplicationAppearanceAqua:
            [self setApplicationAppearanceName:NSAppearanceNameAqua];
            break;
        case CCNApplicationAppearanceDark:
            [self setApplicationAppearanceName:NSAppearanceNameVibrantDark];
            break;
    }
}

// MARK: - Manipulate Application Appearance

+ (void)toggleApplicationAppearanceForWindow:(__kindof NSWindow *)window {
    NSString *appearance = [self applicationAppearanceName];
    if ([appearance isEqualToString:NSAppearanceNameAqua]) {
        appearance = NSAppearanceNameVibrantDark;
    }
    else {
        appearance = NSAppearanceNameAqua;
    }
    [self setApplicationAppearanceName:appearance forWindow:window];
}

+ (void)setApplicationAppearanceName:(NSString *)appearance forWindow:(__kindof NSWindow *)window {
    [window setAppearance:[NSAppearance appearanceNamed:appearance]];
    [window setViewsNeedDisplay:YES];
}

+ (NSString *)applicationAppearanceName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appearance = NSAppearanceNameAqua;
    if ([defaults stringForKey:CCNPrefsCurrentAppearance]) {
        appearance = [defaults stringForKey:CCNPrefsCurrentAppearance];
    }
    else {
        [defaults setObject:appearance forKey:CCNPrefsCurrentAppearance];
        [defaults synchronize];
    }
    return appearance;
}

+ (void)setApplicationAppearanceName:(NSString *)applicationAppearance {
    NSAssert((![applicationAppearance isEqualToString:NSAppearanceNameAqua] || ![applicationAppearance isEqualToString:NSAppearanceNameVibrantDark]), @"** ERROR: The parameter 'applicationAppearance' can only be NSAppearanceNameAqua or NSAppearanceNameVibrantDark **");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:applicationAppearance forKey:CCNPrefsCurrentAppearance];
    [defaults synchronize];
}

@end
