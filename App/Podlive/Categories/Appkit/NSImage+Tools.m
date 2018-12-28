//
//  Created by Frank Gregor on 05.01.15.
//  Copyright (c) 2015 cocoa:naut. All rights reserved.
//

#import "NSImage+Tools.h"

@implementation NSImage (Tools)

+ (NSImage *_Nullable)tintedImage:(NSImage *_Nonnull)image withColor:(NSColor *_Nullable)inColor  {
    if (!inColor) return image;

    NSImage *tintedImage = [image copy];
    NSSize iconSize = [tintedImage size];
    NSRect iconRect = {NSZeroPoint, iconSize};

    [tintedImage lockFocus];
    [[inColor colorWithAlphaComponent: 0.5] set];
    NSRectFillUsingOperation(iconRect, NSCompositingOperationSourceAtop);
    [tintedImage unlockFocus];

    return tintedImage;
}

- (NSImage *_Nonnull)imageTintedWithColor:(NSColor *_Nullable)inColor  {
    if (!inColor) return self;

    NSImage *tintedImage = [self copy];
    NSSize iconSize = [tintedImage size];
    NSRect iconRect = {NSZeroPoint, iconSize};

    [tintedImage lockFocus];
    [inColor set];
    NSRectFillUsingOperation(iconRect, NSCompositingOperationSourceAtop);
    [tintedImage unlockFocus];

    return tintedImage;
}

- (NSColor *)averageColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[self TIFFRepresentation], NULL);
    CGImageRef maskRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);

    CFRelease(source);
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), maskRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(maskRef);


    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [NSColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [NSColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

@end
