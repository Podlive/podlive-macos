//
//  Created by Frank Gregor on 30/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSImageView+Podlive.h"

@implementation NSImageView (Podlive)

- (void)crossfadeToImage:(nonnull NSImage *)toImage completion:(nullable void (^)(void))completion {
    NSParameterAssert(toImage != nil);

    __block NSImageView *_overlay = [NSImageView new];
    _overlay.imageScaling     = NSImageScaleProportionallyUpOrDown;
    _overlay.autoresizingMask = self.autoresizingMask;
    _overlay.wantsLayer       = self.wantsLayer;
    _overlay.frame            = self.frame;
    _overlay.image            = toImage;
    _overlay.alphaValue       = 0.0;
    [self.superview addSubview:_overlay];

    __weak typeof(self) weakSelf = self;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = .65;

        weakSelf.animator.alphaValue = 0.0;
        _overlay.animator.alphaValue = 1.0;

    } completionHandler:^{
        weakSelf.image = [toImage copy];
        weakSelf.alphaValue = 1.0;

        _overlay.alphaValue = 0.0;
        [_overlay removeFromSuperview];
        _overlay = nil;

        if (completion) {
            completion();
        }
    }];
}

@end
