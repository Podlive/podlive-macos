//
//  Created by Frank Gregor on 01/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@interface NSColor (Podlive)

// MARK: - General
+ (NSColor *)podliveBaseColor;
+ (NSColor *)trialRemainingColor;


// MARK: - Window Toolbar
+ (NSColor *)userLoggedInStatusColor;
+ (NSColor *)userLoggedOutStatusColor;


// MARK: - Controls
+ (NSColor *)controlLightTextColor;

// MARK: - Grid Items
+ (NSColor *)gridItemSubscriptionBadgeColor;
+ (NSColor *)gridItemSelectionForegroundColor;
+ (NSColor *)gridItemSelectionBackgroundColor;
+ (NSColor *)gridItemDetailMarkerColor;


// MARK: - Grid Section
+ (NSColor *)gridSectionHeaderColor;
+ (NSColor *)gridSectionHeaderTextColor;


// MARK: - Grid DetailView
+ (NSColor *)gridItemDetailColor;
+ (NSColor *)gridItemDetailTextColor;
+ (NSColor *)gridItemDetailTopLineColor;
+ (NSColor *)gridItemDetailBottomLineColor;


// MARK: - Player
+ (NSColor *)playerBackgroundColor;
+ (NSColor *)playerTextColor;
+ (NSColor *)playerLightenColor;
+ (NSColor *)playerDarkenColor;


// MARK: - Player Controls
+ (NSColor *)playerButtonBackgroundColor;
+ (NSColor *)playerButtonBorderColor;
+ (NSColor *)playerButtonHighlightColor;


@end
