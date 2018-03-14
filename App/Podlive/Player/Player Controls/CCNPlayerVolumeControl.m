//
//  Created by Frank Gregor on 04/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPlayerVolumeControl.h"
#import "NSColor+Podlive.h"

static const CGFloat kCCNPlayerVolumeSliderIconEdgeLength = 18.0;

@interface CCNPlayerVolumeControl ()
@property (nonatomic, strong) NSImageView *volumeLowIcon;
@property (nonatomic, strong) NSImageView *volumeHighIcon;
@end

@implementation CCNPlayerVolumeControl

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.wantsLayer = YES;
    self.frame = NSMakeRect(0, 0, 110.0, kCCNPlayerVolumeSliderIconEdgeLength+2);

    [self setupUI];
    [self setupNotifications];

    return self;
}

- (void)setupUI {
    var _image = [NSImage imageNamed:@"player-volume-low"];
    _image.size = NSMakeSize(kCCNPlayerVolumeSliderIconEdgeLength, kCCNPlayerVolumeSliderIconEdgeLength);
    _image = [_image imageTintedWithColor:NSColor.lightGrayColor];

    _volumeLowIcon = [NSImageView imageViewWithImage:_image];
    _volumeLowIcon.translatesAutoresizingMaskIntoConstraints = NO;
    _volumeLowIcon.wantsLayer = YES;
    _volumeLowIcon.backgroundColor = [NSColor clearColor];
    [self addSubview:_volumeLowIcon];

    _image = [NSImage imageNamed:@"player-volume-high"];
    _image.size = NSMakeSize(kCCNPlayerVolumeSliderIconEdgeLength, kCCNPlayerVolumeSliderIconEdgeLength);
    _image = [_image imageTintedWithColor:NSColor.lightGrayColor];
    _volumeHighIcon = [NSImageView imageViewWithImage:_image];
    _volumeHighIcon.translatesAutoresizingMaskIntoConstraints = NO;
    _volumeHighIcon.wantsLayer = YES;
    _volumeHighIcon.backgroundColor = [NSColor clearColor];
    [self addSubview:_volumeHighIcon];

    _slider = CCNPlayerVolumeSlider.new;
    _slider.controlSize = NSControlSizeSmall;
    [self addSubview:_slider];
}

- (void)setupNotifications {
    let nc = NSNotificationCenter.defaultCenter;
    let mainQueue = NSOperationQueue.mainQueue;
    let volumeLowIcon = self.volumeLowIcon.image;
    let volumeHighIcon = self.volumeHighIcon.image;

    @weakify(self);
    [nc addObserverForName:CCNPlayerVolumeSliderActionNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
        @strongify(self);
        let slider = (CCNPlayerVolumeSlider *)note.object;

        self.volumeLowIcon.image = [volumeLowIcon imageTintedWithColor:[NSColor.playerTextColor colorWithAlphaComponent:1-slider.floatValue]];
        self.volumeHighIcon.image = [volumeHighIcon imageTintedWithColor:[NSColor.playerTextColor colorWithAlphaComponent:slider.floatValue]];
    }];
}

// MARK: - Auto Layout

- (void)updateConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.volumeLowIcon.centerYAnchor constraintEqualToAnchor:self.volumeLowIcon.superview.centerYAnchor],
        [self.volumeLowIcon.leftAnchor constraintEqualToAnchor:self.volumeLowIcon.superview.leftAnchor],
        [self.volumeLowIcon.widthAnchor constraintEqualToConstant:self.volumeLowIcon.image.size.width],
        [self.volumeLowIcon.heightAnchor constraintEqualToAnchor:self.volumeLowIcon.widthAnchor],

        [self.volumeHighIcon.centerYAnchor constraintEqualToAnchor:self.volumeHighIcon.superview.centerYAnchor],
        [self.volumeHighIcon.rightAnchor constraintEqualToAnchor:self.volumeHighIcon.superview.rightAnchor],
        [self.volumeHighIcon.widthAnchor constraintEqualToConstant:self.volumeHighIcon.image.size.width],
        [self.volumeHighIcon.heightAnchor constraintEqualToAnchor:self.volumeHighIcon.widthAnchor],

        [self.slider.topAnchor constraintEqualToAnchor:self.slider.superview.topAnchor],
        [self.slider.bottomAnchor constraintEqualToAnchor:self.slider.superview.bottomAnchor],
        [self.slider.leftAnchor constraintEqualToAnchor:self.volumeLowIcon.rightAnchor constant:kInnerEdgeMargin/2],
        [self.slider.rightAnchor constraintEqualToAnchor:self.volumeHighIcon.leftAnchor constant:-kInnerEdgeMargin/2],
    ]];

    [super updateConstraints];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    self.slider.minimumTrackTintColor = NSColor.playerButtonBorderColor;
    self.slider.maximumTrackTintColor = NSColor.playerButtonHighlightColor;

    self.volumeLowIcon.image = [self.volumeLowIcon.image imageTintedWithColor:[NSColor.playerTextColor colorWithAlphaComponent:1-self.slider.floatValue]];
    self.volumeHighIcon.image = [self.volumeHighIcon.image imageTintedWithColor:[NSColor.playerTextColor colorWithAlphaComponent:self.slider.floatValue]];
}

@end
