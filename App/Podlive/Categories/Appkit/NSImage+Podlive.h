//
//  Created by Frank Gregor on 11/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@interface NSImage (Podlive)

+ (NSImage *)applicationIcon;
+ (NSImage *)alertSignInfo;
+ (NSImage *)alertSignError;
+ (NSImage *)anonymousAvatar;
+ (NSImage *)anonymousAvatarWithSize:(NSSize)imageSize;
+ (NSImage *)channelPlaceholder;


// Player Controls
+ (NSImage *)playerPlayImage;
+ (NSImage *)playerPlayImageWithSize:(NSSize)imageSize;
+ (NSImage *)playerPauseImage;
+ (NSImage *)playerPauseImageWithSize:(NSSize)imageSize;
+ (NSImage *)playerStopImage;
+ (NSImage *)playerStopImageWithSize:(NSSize)imageSize;

@end
