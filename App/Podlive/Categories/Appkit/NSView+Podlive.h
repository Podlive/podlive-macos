//
//  Created by Frank Gregor on 05.01.15.
//  Copyright (c) 2015 cocoa:naut. All rights reserved.
//

@interface NSView (Podlive)

// MARK: - Managing Views
- (BOOL)hasSubView:(NSView *_Nonnull)theSubView;
- (void)bringSubViewToFront:(NSView *_Nonnull)theSubView;
- (void)addVibrancyBlendingMode:(NSVisualEffectBlendingMode)mode;

// MARK: - Managing Animations
- (void)startRotationWithDuration:(CFTimeInterval)duration clockwise:(BOOL)clockwise;
- (void)stopRotation;

@property (nullable, nonatomic, strong) NSColor *backgroundColor;

@end
