//
//  Created by Frank Gregor on 01/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSColor+Podlive.h"
#import "NSAppearance+Podlive.h"

@implementation NSColor (Podlive)

// MARK: - General
+ (NSColor *)podliveBaseColor{
    return PodliveDefaultStyleKit.podliveBaseColor;
}

+ (NSColor *)trialRemainingColor {
    return PodliveDefaultStyleKit.trialRemainingColor;
}

// MARK: - Window Toolbar
+ (NSColor *)userLoggedInStatusColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.userLoggedInStatusColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.userLoggedInStatusDarkColor; break;
    }
    return _color;
}

+ (NSColor *)userLoggedOutStatusColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.userLoggedOutStatusColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.userLoggedOutStatusDarkColor; break;
    }
    return _color;
}

// MARK: - Window Toolbar

+ (NSColor *)controlLightTextColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.controlTextColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.controlTextDarkColor; break;
    }
    return _color;
}

// MARK: - Grid Items

+ (NSColor *)gridItemSubscriptionBadgeColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.gridItemSubscriptionBadgeColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.gridItemSubscriptionBadgeDarkColor; break;
    }
    return _color;
}

+ (NSColor *)gridItemSelectionForegroundColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.gridItemSelectionForegroundColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.gridItemSelectionForegroundDarkColor; break;
    }
    return _color;
}

+ (NSColor *)gridItemSelectionBackgroundColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.gridItemSelectionBackgroundColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.gridItemSelectionBackgroundDarkColor; break;
    }
    return _color;
}

+ (NSColor *)gridItemDetailMarkerColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.gridItemDetailMarkerColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.gridItemDetailMarkerDarkColor; break;
    }
    return _color;
}

// MARK: - Grid Section

+ (NSColor *)gridSectionHeaderColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.gridSectionHeaderColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.gridSectionHeaderDarkColor; break;
    }
    return _color;
}

+ (NSColor *)gridSectionHeaderTextColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.gridSectionHeaderTextColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.gridSectionHeaderTextDarkColor; break;
    }
    return _color;
}

// MARK: - Grid DetailView

+ (NSColor *)gridItemDetailColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.gridItemDetailColor;  break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.gridItemDetailDarkColor; break;
    }
    return _color;
}

+ (NSColor *)gridItemDetailTextColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.gridItemDetailTextColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.gridItemDetailTextDarkColor; break;
    }
    return _color;
}

+ (NSColor *)gridItemDetailTopLineColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.gridItemDetailTopLineColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.gridItemDetailTopLineDarkColor; break;
    }
    return _color;
}

+ (NSColor *)gridItemDetailBottomLineColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.gridItemDetailBottomLineColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.gridItemDetailBottomLineDarkColor; break;
    }
    return _color;
}

// MARK: - Player

+ (NSColor *)playerBackgroundColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.playerBackgroundColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.playerBackgroundDarkColor; break;
    }
    return _color;
}

+ (NSColor *)playerTextColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.playerTextColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.playerTextDarkColor; break;
    }
    return _color;
}

+ (NSColor *)playerLightenColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.playerLightenColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.playerLightenDarkColor; break;
    }
    return _color;
}

+ (NSColor *)playerDarkenColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.playerDarkenColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.playerDarkenDarkColor; break;
    }
    return _color;
}



// MARK: - Player Controls
+ (NSColor *)playerButtonBackgroundColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.playerButtonBackgroundColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.playerButtonBackgroundDarkColor; break;
    }
    return _color;
}

+ (NSColor *)playerButtonBorderColor {
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.playerButtonBorderColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.playerButtonBorderDarkColor; break;
    }
    return _color;
}

+ (NSColor *)playerButtonHighlightColor{
    var _color = (NSColor *)nil;
    switch (NSAppearance.applicationAppearance) {
        case CCNApplicationAppearanceAqua: _color = PodliveDefaultStyleKit.playerButtonHighlightColor; break;
        case CCNApplicationAppearanceDark: _color = PodliveDefaultStyleKit.playerButtonHighlightDarkColor; break;
    }
    return _color;
}

@end
