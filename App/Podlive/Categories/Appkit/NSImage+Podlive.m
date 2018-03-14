//
//  Created by Frank Gregor on 11/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSImage+Podlive.h"
#import "NSColor+Podlive.h"

@implementation NSImage (Podlive)

+ (NSImage *)applicationIcon {
    static dispatch_once_t onceToken;
    static NSImage *_image = nil;
    dispatch_once(&onceToken, ^{
        _image = [NSImage imageNamed:@"app-icon"];
    });
    return _image;
}

+ (NSImage *)alertSignInfo {
    return [self _imageWithName:@"alert-ino" size:NSMakeSize(64.0, 64.0) tintColor:nil];
}

+ (NSImage *)alertSignError {
    return [self _imageWithName:@"alert-error" size:NSMakeSize(64.0, 64.0) tintColor:nil];
}

+ (NSImage *)anonymousAvatar {
    return [self anonymousAvatarWithSize:NSMakeSize(32.0, 32.0)];
}

+ (NSImage *)anonymousAvatarWithSize:(NSSize)imageSize {
    return [self _imageWithName:@"anon-avatar" size:imageSize tintColor:NSColor.lightGrayColor];
}

+ (NSImage *)channelPlaceholder {
    return [self _imageWithName:@"channel-placeholder" size:NSMakeSize(256.0, 256.0) tintColor:NSColor.lightGrayColor];
}

// MARK: - Player Controls

+ (NSImage *)playerPlayImage {
    return [self playerPlayImageWithSize:NSMakeSize(48.0, 48.0)];
}

+ (NSImage *)playerPlayImageWithSize:(NSSize)imageSize {
    return [self _imageWithName:@"control-play" size:imageSize tintColor:NSColor.playerLightenColor];
}

+ (NSImage *)playerPauseImage {
    return [self playerPauseImageWithSize:NSMakeSize(48.0, 48.0)];
}

+ (NSImage *)playerPauseImageWithSize:(NSSize)imageSize {
    return [self _imageWithName:@"control-pause" size:imageSize tintColor:NSColor.playerLightenColor];
}

+ (NSImage *)playerStopImage {
    return [self playerStopImageWithSize:NSMakeSize(48.0, 48.0)];
}

+ (NSImage *)playerStopImageWithSize:(NSSize)imageSize {
    return [self _imageWithName:@"control-stop" size:imageSize tintColor:NSColor.playerLightenColor];
}

+ (NSImage *)_imageWithName:(NSString *)imageName size:(NSSize)imageSize tintColor:(NSColor *)tintColor {
    NSImage *_image = [NSImage imageNamed:imageName];
    _image.size = imageSize;

    if (tintColor) {
        _image = [_image imageTintedWithColor:tintColor];
    }

    return _image;
}

@end
