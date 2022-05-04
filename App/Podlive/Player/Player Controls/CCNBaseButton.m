//
//  Created by Frank Gregor on 04/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNBaseButton.h"

@interface CCNBaseButton ()
@property (nonatomic, strong) NSTrackingArea *trackingArea;
@property (nonatomic, assign, getter=isMouseHovered) BOOL mouseHovered;
@end

@implementation CCNBaseButton

+ (instancetype)buttonWithSize:(NSSize)buttonSize actionHandler:(CCNButtonAction)actionHandler {
    return [[[self class] alloc] initWithSize:buttonSize actionHandler:actionHandler];
}

- (instancetype)initWithSize:(NSSize)buttonSize actionHandler:(CCNButtonAction)actionHandler {
    self = [super initWithFrame:NSMakeRect(0, 0, buttonSize.width, buttonSize.height)];
    if (!self) return nil;

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.wantsLayer          = YES;
    self.layer.masksToBounds = YES;

    _buttonSize    = buttonSize;
    _actionHandler = [actionHandler copy];

    self.cornerRadius       = 5.0;
    self.borderWidth        = 2.0;
    self.tintColor          = NSColor.lightGrayColor;
    self.tintHighlightColor = NSColor.whiteColor;
    self.mouseHovered       = NO;
    self.state              = NSControlStateValueOff;
    self.style              = CCNBaseButtonStyleRoundedRect;

    self.trackingArea  = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                      options:(NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited)
                                                        owner:self
                                                     userInfo:nil];
    [self addTrackingArea:self.trackingArea];

    return self;
}

- (void)dealloc {
    [self removeTrackingArea:self.trackingArea];
    self.trackingArea = nil;
}

// MARK: - Custom Accessors

- (void)setButtonSize:(NSSize)buttonSize {
    _buttonSize = buttonSize;
    self.frame = NSMakeRect(0, 0, _buttonSize.width, _buttonSize.height);
}

- (void)setStyle:(CCNBaseButtonStyle)style {
    _style = style;
    if (self.style == CCNBaseButtonStyleRound) {
        self.cornerRadius = self.buttonSize.width/2;
    }
}

- (void)setState:(NSInteger)state {
    _state = state;
    [self setNeedsDisplay:YES];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsDisplay:YES];
}

- (void)setTintColor:(NSColor *)tintColor {
    _tintColor = tintColor;
    [self setNeedsDisplay:YES];
}

- (void)setTintHighlightColor:(NSColor *)tintHighlightColor {
    _tintHighlightColor = tintHighlightColor;
    [self setNeedsDisplay:YES];
}

// MARK: - Event Handling

- (void)mouseEntered:(NSEvent *)event {
    self.mouseHovered = YES;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)event {
    self.mouseHovered = NO;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)event {
    if (event.type == NSEventTypeLeftMouseUp) {
        if (self.actionHandler) {
            self.actionHandler(self);
        }
    }
    else {
        [super mouseUp:event];
    }
}

@end
