//
//  Created by Frank Gregor on 04/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPlayerVolumeSlider.h"
#import "NSColor+Podlive.h"

NSString *const CCNPlayerVolumeSliderActionNotification = @"CCNPlayerVolumeSliderActionNotification";

@interface CCNPlayerVolumeSliderCell : NSSliderCell
@property (nonatomic, strong) NSColor *minimumTrackTintColor;
@property (nonatomic, strong) NSColor *maximumTrackTintColor;
@end


@implementation CCNPlayerVolumeSlider

+ (void)initialize {
    [CCNPlayerVolumeSlider setCellClass:[CCNPlayerVolumeSliderCell class]];
}

+ (Class)cellClass {
    return [CCNPlayerVolumeSliderCell class];
}

+ (instancetype)sliderWithAction:(CCNPlayerVolumeSliderAction)actionHandler {
    let _slider = CCNPlayerVolumeSlider.new;
    _slider.actionHandler = actionHandler;
    
    return _slider;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.wantsLayer = YES;

    return self;
}

// MARK: - Custom Accessors

- (void)setActionHandler:(CCNPlayerVolumeSliderAction)actionHandler {
    if (actionHandler) {
        _actionHandler = [actionHandler copy];
        self.target = self;
        self.action = @selector(handleSliderAction:);
    }
    else {
        _actionHandler = nil;
        self.target = nil;
        self.action = nil;
    }
}

- (void)setMinimumTrackTintColor:(NSColor *)minimumTrackTintColor {
    [(CCNPlayerVolumeSliderCell *)self.cell setMinimumTrackTintColor:minimumTrackTintColor];
}

- (NSColor *)minimumTrackTintColor {
    return [(CCNPlayerVolumeSliderCell *)self.cell minimumTrackTintColor];
}

- (void)setMaximumTrackTintColor:(NSColor *)maximumTrackTintColor {
    [(CCNPlayerVolumeSliderCell *)self.cell setMaximumTrackTintColor:maximumTrackTintColor];
}

- (NSColor *)maximumTrackTintColor {
    return [(CCNPlayerVolumeSliderCell *)self.cell maximumTrackTintColor];
}

// MARK: - Actions

- (void)handleSliderAction:(CCNPlayerVolumeSlider *)button {
    if (self.actionHandler) {
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            self.actionHandler(self);
            [NSNotificationCenter.defaultCenter postNotificationName:CCNPlayerVolumeSliderActionNotification object:self];
        });
    }
}

@end



@implementation CCNPlayerVolumeSliderCell

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.minimumTrackTintColor = NSColor.playerButtonBorderColor;
    self.maximumTrackTintColor = NSColor.controlTextColor;

    return self;
}


- (void)drawBarInside:(NSRect)rect flipped:(BOOL)flipped {
    rect.size.height = 5.0;

    // Bar radius
    let barRadius = rect.size.height / 2;

    // Knob position depending on control min/max value and current control value.
    let value = (self.doubleValue  - self.minValue) / (self.maxValue - self.minValue);

    // Final Left Part Width
    let finalWidth = value * (NSWidth(self.controlView.frame) - 8);

    // Left Part Rect
    var maximumTrackRect = rect;
    maximumTrackRect.size.width = finalWidth;

    // Draw Right Part
    let minimumTrackPath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:barRadius yRadius:barRadius];
    [self.minimumTrackTintColor setFill];
    [minimumTrackPath fill];

    // Draw Left Part
    let maximumTrackPath = [NSBezierPath bezierPathWithRoundedRect:maximumTrackRect xRadius:barRadius yRadius:barRadius];
    [self.maximumTrackTintColor setFill];
    [maximumTrackPath fill];
}

@end
