//
//  Created by Frank Gregor on 30/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@interface NSImageView (CCNAppKit)

- (void)crossfadeToImage:(nonnull NSImage *)toImage completion:(nullable void (^)(void))completion;

@end
