//
//  Telekinesis.framework
//  Copyright © 2016 PixelCut. All rights reserved.
//
//  Compatible with PaintCode 3
//  https://www.paintcodeapp.com/telekinesis
//

#import <Foundation/Foundation.h>


/// How to integrate:
///  1. Drag this framework to “Embedded Frameworks” or “Embedded Binaries” section of your target General panel.
///
///  Done! Framework will print a message after it’s launched.

/// In case that didn’t work for the first time, check these steps:
///  1. Framework must be added to the project and visible in Project Navigator.
///  2. Build Phase “Linked Binary with Libraries” must include this framework.
///  3. Build Phase “Embed Frameworks” must include this framework.
///  4. Build Setting “Framework Search Paths” must include a path to this framework.
///  5. Try adding “-ObjC” to Build Setting “Other Linker Flags”.

/// IMPORTANT: Never submit Telekinesis to the App Store and don’t distribute it to your customers.

/// Listen for this notification if you need to do custom changes after your StyleKit is changed via Telekinesis.
extern NSString* TelekinesisDidChangeStyleKitNotification;



#pragma mark - Framework Version

FOUNDATION_EXPORT double TelekinesisFrameworkVersionNumber;
FOUNDATION_EXPORT const unsigned char* TelekinesisFrameworkVersionString;


