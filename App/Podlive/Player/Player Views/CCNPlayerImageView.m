//
//  Created by Frank Gregor on 13/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPlayerImageView.h"

@interface CCNPlayerImageView ()
@property (nonatomic, assign) NSSize contentSize;
@end

@implementation CCNPlayerImageView

+ (instancetype)viewWithSize:(NSSize)viewSize {
    return [[[self class] alloc] initWithSize:viewSize];
}

- (instancetype)initWithSize:(NSSize)viewSize {
    return [[[self class] alloc] initWithSize:viewSize imageType:CCNPlayerImageTypeUndefined];
}

+ (instancetype)viewWithSize:(NSSize)viewSize imageType:(CCNPlayerImageType)imageType {
    return [[[self class] alloc] initWithSize:viewSize imageType:imageType];
}

- (instancetype)initWithSize:(NSSize)viewSize imageType:(CCNPlayerImageType)imageType {
    self = [super initWithFrame:NSMakeRect(0.0, 0.0, viewSize.width, viewSize.height)];
    if (!self) return nil;

    self.wantsLayer = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;

    _contentSize = viewSize;
    _imageType = imageType;

    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    switch (self.imageType) {
        case CCNPlayerImageTypeUndefined:break;
        case CCNPlayerImageTypeTimer:
            [PodliveGUIKit drawPlayerTimerClockWithFrame:self.bounds color:self.tintColor];
            break;
        case CCNPlayerImageTypeListener:
            [PodliveGUIKit drawPlayerListenerWithFrame:self.bounds color:self.tintColor];
            break;
    }
}

- (NSSize)intrinsicContentSize {
    return self.contentSize;
}

// MARK: - Custom Accessors

- (void)setImageType:(CCNPlayerImageType)imageType {
    _imageType = imageType;
    [self setNeedsDisplay:YES];
}

- (void)setTintColor:(NSColor *)tintColor {
    _tintColor = tintColor;
    [self setNeedsDisplay:YES];
}

@end
