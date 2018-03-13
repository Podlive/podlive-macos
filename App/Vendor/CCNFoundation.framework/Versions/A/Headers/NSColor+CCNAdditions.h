//
//  Created by Frank Gregor on 27.12.14.
//  Copyright (c) 2014 cocoa:naut. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (CCNAdditions)

+ (NSColor *)colorFromRGBString:(NSString *)RGBString;
+ (NSString *)rgbStringFromColor:(NSColor *)color;
- (NSUInteger)hash;

@end
