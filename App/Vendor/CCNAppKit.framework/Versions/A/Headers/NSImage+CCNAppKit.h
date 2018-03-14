//
//  Created by Frank Gregor on 05.01.15.
//  Copyright (c) 2015 cocoa:naut. All rights reserved.
//

@interface NSImage (CCNAppKit)

+ (NSImage *_Nullable)tintedImage:(NSImage *_Nonnull)image withColor:(NSColor *_Nullable)inColor;
- (NSImage *_Nonnull)imageTintedWithColor:(NSColor *_Nullable)inColor;
- (NSColor *_Nonnull)averageColor;

@end
