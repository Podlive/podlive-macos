//
//  Created by Frank Gregor on 04/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

typedef NS_ENUM(NSInteger, CCNApplicationAppearance) {
    CCNApplicationAppearanceAqua = 0,
    CCNApplicationAppearanceDark = 1
};

@interface NSAppearance (CCNAppKit)

// MARK: - Manipulate Application Appearance by Type
+ (CCNApplicationAppearance)applicationAppearance;
+ (void)setApplicationAppearance:(CCNApplicationAppearance)applicationAppearance;

// MARK: - Manipulate Application Appearance by Name
+ (void)toggleApplicationAppearanceForWindow:(__kindof NSWindow *)window;
+ (void)setApplicationAppearanceName:(NSString *)appearance forWindow:(__kindof NSWindow *)window;
+ (NSString *)applicationAppearanceName;
+ (void)setApplicationAppearanceName:(NSString *)applicationAppearance;

@end
