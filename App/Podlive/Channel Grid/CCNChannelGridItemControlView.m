//
//  Created by Frank Gregor on 28/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNChannelGridItemControlView.h"
#import "CCNPlayerPlayPauseButton.h"
#import "CCNChannel.h"

#import "NSButton+Tools.h"
#import "NSColor+Podlive.h"
#import "NSImage+Tools.h"
#import "NSView+Podlive.h"

static const CGFloat kOverlayHeight = 55.0;

@interface CCNChannelGridItemControlView ()
@property (nonatomic, strong) CCNPlayerPlayPauseButton *playPauseButton;
@property (nonatomic, strong) NSButton *subscribeButton;
@property (nonatomic, readonly) NSRect bottomOverlay;
@end

@implementation CCNChannelGridItemControlView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.wantsLayer = YES;

    [self setupUI];
    [self setupConstraints];
    [self setupNotifications];

    return self;
}

- (void)setupUI {
    let playPauseButton = [CCNPlayerPlayPauseButton buttonWithSize:NSMakeSize(52.0, 52.0) actionHandler:nil];
    playPauseButton.borderWidth = 1.0;
    playPauseButton.layer.cornerRadius = playPauseButton.bounds.size.width/2;
    playPauseButton.layer.backgroundColor = [NSColor colorWithCalibratedWhite:0 alpha:0.65].CGColor;
    _playPauseButton = playPauseButton;
    [self addSubview:_playPauseButton];


    let buttonSize = NSMakeSize(26.0, 26.0);
    var _image = [NSImage imageNamed:@"control-follow"];
    _image = [_image imageTintedWithColor:NSColor.whiteColor];
    _image.size = buttonSize;

    let subscribeButton = [NSButton buttonWithImage:_image actionHandler:nil];
    subscribeButton.translatesAutoresizingMaskIntoConstraints = NO;
    subscribeButton.alternateImage = nil;
    subscribeButton.wantsLayer = YES;
    subscribeButton.bordered   = NO;
    subscribeButton.frame = NSMakeRect(0, 0, buttonSize.width, buttonSize.height);
    subscribeButton.layer.cornerRadius  = buttonSize.height/2;
    subscribeButton.layer.masksToBounds = YES;
    subscribeButton.backgroundColor = [NSColor.gridItemSubscriptionBadgeColor colorWithAlphaComponent:0.85];
    self.subscribeButton = subscribeButton;
    [self addSubview:self.subscribeButton];
}

- (void)setupNotifications {
    let nc = NSNotificationCenter.defaultCenter;

    [nc addObserver:self selector:@selector(performPlayPauseButtonOnState:)             name:CCNPlayerDidStartPlayingNotification       object:nil];
    [nc addObserver:self selector:@selector(performPlayPauseButtonOnState:)             name:CCNPlayerDidResumePlayingNotification      object:nil];
    [nc addObserver:self selector:@selector(performPlayPauseButtonOffState:)            name:CCNPlayerDidPausePlayingNotification       object:nil];
    [nc addObserver:self selector:@selector(performPlayPauseButtonOffState:)            name:CCNPlayerDidStopPlayingNotification        object:nil];
    [nc addObserver:self selector:@selector(handlePlayerDidChangedChannelNotification:) name:CCNPlayerDidChangedChannelNotification     object:nil];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.playPauseButton.centerXAnchor constraintEqualToAnchor:self.playPauseButton.superview.centerXAnchor],
        [self.playPauseButton.centerYAnchor constraintEqualToAnchor:self.playPauseButton.superview.centerYAnchor constant:-kOuterEdgeMargin],
        [self.playPauseButton.widthAnchor constraintEqualToConstant:self.playPauseButton.buttonSize.width],
        [self.playPauseButton.heightAnchor constraintEqualToAnchor:self.playPauseButton.widthAnchor],

        [self.subscribeButton.centerXAnchor constraintEqualToAnchor:self.subscribeButton.superview.centerXAnchor],
        [self.subscribeButton.bottomAnchor constraintEqualToAnchor:self.subscribeButton.superview.bottomAnchor constant:-(self.bottomOverlay.size.height - self.subscribeButton.image.size.height)/3],
        [self.subscribeButton.widthAnchor constraintEqualToConstant:NSWidth(self.subscribeButton.frame)],
        [self.subscribeButton.heightAnchor constraintEqualToAnchor:self.subscribeButton.widthAnchor],
    ]];
}

// MARK: - Notifications

- (void)performPlayPauseButtonOnState:(NSNotification *)note {
    CCNChannel *playingChannel = note.userInfo[kUserInfoPlayingChannelKey];
    if ([playingChannel isEqual:self.channel]) {
        self.playPauseButton.state = NSControlStateValueOn;
    }
}

- (void)performPlayPauseButtonOffState:(NSNotification *)note {
    CCNChannel *playingChannel = note.userInfo[kUserInfoPlayingChannelKey];
    if ([playingChannel isEqual:self.channel]) {
        self.playPauseButton.state = NSControlStateValueOff;
    }
}

- (void)handlePlayerDidChangedChannelNotification:(NSNotification *)note {
    CCNChannel *playingChannel = note.userInfo[kUserInfoPlayingChannelKey];
    CCNChannel *replacedChannel = note.userInfo[kUserInfoReplacedChannelKey];
    if ([replacedChannel isEqual:self.channel]) {
        self.playPauseButton.state = NSControlStateValueOff;
    }
    else if([playingChannel isEqual:self.channel]) {
        self.playPauseButton.state = NSControlStateValueOn;
    }
}

// MARK: - Custom Accessors

- (void)setChannel:(CCNChannel *)channel {
    _channel = channel;
    self.playPauseButton.hidden = !channel.isOnline;
}

- (void)setNeedsDisplay:(BOOL)needsDisplay {
    [super setNeedsDisplay:needsDisplay];
    self.playPauseButton.hidden = !self.channel.isOnline;
}

- (NSRect)bottomOverlay {
    return NSMakeRect(NSMinX(self.bounds), NSMinY(self.bounds), NSWidth(self.bounds), kOverlayHeight);
}

// MARK: - NSView

- (void)drawRect:(NSRect)dirtyRect {
    NSColor* topGradientColor = [NSColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    NSColor* middleGradientColor = [NSColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSColor* bottomGradientColor = [NSColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.85];
    NSColor* overlayGradientColor = [NSColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.12];
    NSColor* overlayGradientColor2 = [NSColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.3];

    //// Gradient Declarations
    NSGradient* overlayGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                   bottomGradientColor, 0.10,
                                   [bottomGradientColor blendedColorWithFraction: 0.5 ofColor: middleGradientColor], 0.19,
                                   middleGradientColor, 0.28,
                                   [middleGradientColor blendedColorWithFraction: 0.5 ofColor: overlayGradientColor2], 0.36,
                                   overlayGradientColor2, 0.47,
                                   overlayGradientColor, 0.71,
                                   topGradientColor, 0.96, nil];

    //// overlay Drawing
    CGFloat overlayCornerRadius = self.superview.layer.cornerRadius;
    NSRect overlayRect = NSMakeRect(NSMinX(self.bottomOverlay), NSMinY(self.bottomOverlay), NSWidth(self.bottomOverlay), kOverlayHeight);
    NSRect overlayInnerRect = NSInsetRect(overlayRect, overlayCornerRadius, overlayCornerRadius);
    NSBezierPath* overlayPath = [NSBezierPath bezierPath];
    [overlayPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(overlayInnerRect), NSMinY(overlayInnerRect)) radius: overlayCornerRadius startAngle: 180 endAngle: 270];
    [overlayPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(overlayInnerRect), NSMinY(overlayInnerRect)) radius: overlayCornerRadius startAngle: 270 endAngle: 360];
    [overlayPath lineToPoint: NSMakePoint(NSMaxX(overlayRect), NSMaxY(overlayRect))];
    [overlayPath lineToPoint: NSMakePoint(NSMinX(overlayRect), NSMaxY(overlayRect))];
    [overlayPath closePath];
    [overlayGradient drawInBezierPath: overlayPath angle: 90];
}

@end
