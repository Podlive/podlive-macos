//
//  Created by Frank Gregor on 15/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPlayerView.h"
#import "CCNPlayerView_Private.h"
#import "CCNChannel.h"
#import "CCNPlayerPlayPauseButton.h"
#import "CCNPlayerStopButton.h"
#import "CCNPlayerVolumeControl.h"
#import "CCNPlayerImageView.h"
#import "CCNImageCache.h"

#import "NSColor+Podlive.h"
#import "NSFont+Podlive.h"
#import "NSImage+Podlive.h"
#import "NSImageView+Podlive.h"
#import "NSString+Podlive.h"
#import "NSTextField+Tools.h"
#import "NSView+Podlive.h"


@interface CCNPlayerView ()
@property (nonatomic) NSImageView *coverart;
@property (nonatomic) CCNPlayerImageView *listenerIcon;
@property (nonatomic) CCNPlayerImageView *timeIcon;
@property (nonatomic) NSTextField *listenerTextField;
@property (nonatomic) NSTextField *titleTextField;
@property (nonatomic) NSTextField *timeTextField;
@property (nonatomic) CCNPlayerPlayPauseButton *playPauseButton;
@property (nonatomic) CCNPlayerVolumeControl *volumeControl;
@end

@implementation CCNPlayerView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    _channel = nil;

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.wantsLayer = YES;
    [self addVibrancyBlendingMode:NSVisualEffectBlendingModeWithinWindow];

    [self setupUI];
    [self setupConstraints];
    [self setupNotifications];

    return self;
}

- (void)setupUI {
    _coverart = NSImageView.new;
    _coverart.wantsLayer = YES;
    _coverart.translatesAutoresizingMaskIntoConstraints = NO;
    _coverart.imageScaling = NSImageScaleProportionallyUpOrDown;
    [self addSubview:_coverart];


    _listenerIcon = [CCNPlayerImageView viewWithSize:NSMakeSize(23.0, 23.0) imageType:CCNPlayerImageTypeListener];
    [self addSubview:_listenerIcon];


    _timeIcon = [CCNPlayerImageView viewWithSize:NSMakeSize(23.0, 23.0) imageType:CCNPlayerImageTypeTimer];
    [self addSubview:_timeIcon];


    _playPauseButton = [CCNPlayerPlayPauseButton buttonWithSize:NSMakeSize(32.0, 32.0) actionHandler:nil];
    _playPauseButton.borderWidth = 2.0;
   [self addSubview:_playPauseButton];

    _stopButton = [CCNPlayerStopButton buttonWithSize:NSMakeSize(32.0, 32.0) actionHandler:nil];
    _stopButton.borderWidth = 2.0;
    [self addSubview:_stopButton];

    _volumeControl = CCNPlayerVolumeControl.new;
    [self addSubview:_volumeControl];


    _titleTextField = [self defaultTextField];
    _titleTextField.font = [NSFont fontWithName:NSFont.podliveMediumFontName size:18.0];
    _titleTextField.cell.wraps = YES;
    _titleTextField.cell.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_titleTextField];


    _listenerTextField = [self defaultTextField];
    _listenerTextField.font = [NSFont fontWithName:NSFont.podliveRegularFontName size:13.0];
    _listenerTextField.stringValue = @"";
    [_listenerTextField sizeToFit];
    [self addSubview:_listenerTextField];


    _timeTextField = [self defaultTextField];
    _timeTextField.font = [NSFont fontWithName:NSFont.podliveRegularFontName size:13.0];
    _timeTextField.stringValue = @"00:00:00";
    [_timeTextField sizeToFit];
    [self addSubview:_timeTextField];
}

- (void)setupNotifications {
    let nc = NSNotificationCenter.defaultCenter;
    [nc addObserver:self selector:@selector(handlePlayerDidStartPlayingNotification:)       name:CCNPlayerDidStartPlayingNotification object:nil];
    [nc addObserver:self selector:@selector(handlePlayerDidResumePlayingNotification:)      name:CCNPlayerDidResumePlayingNotification object:nil];
    [nc addObserver:self selector:@selector(handlePlayerDidPausePlayingNotification:)       name:CCNPlayerDidPausePlayingNotification object:nil];
    [nc addObserver:self selector:@selector(handlePlayerDidStopPlayingNotification:)        name:CCNPlayerDidStopPlayingNotification object:nil];
    [nc addObserver:self selector:@selector(handlePlayerDidChangedChannelNotification:)     name:CCNPlayerDidChangedChannelNotification object:nil];
    [nc addObserver:self selector:@selector(handlePushNotificationChannelListenerCountUpdated:) name:CCNPushNotificationChannelListenerCountUpdated object:nil];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.coverart.topAnchor constraintEqualToAnchor:self.coverart.superview.topAnchor constant:1],
        [self.coverart.leftAnchor constraintEqualToAnchor:self.coverart.superview.leftAnchor],
        [self.coverart.bottomAnchor constraintEqualToAnchor:self.coverart.superview.bottomAnchor],
        [self.coverart.widthAnchor constraintEqualToAnchor:self.coverart.heightAnchor],

        [self.volumeControl.centerYAnchor constraintEqualToAnchor:self.stopButton.superview.centerYAnchor],
        [self.volumeControl.rightAnchor constraintEqualToAnchor:self.volumeControl.superview.rightAnchor constant:-kOuterEdgeMargin],
        [self.volumeControl.widthAnchor constraintEqualToConstant:NSWidth(self.volumeControl.frame)],
        [self.volumeControl.heightAnchor constraintEqualToConstant:NSHeight(self.volumeControl.frame)],

        [self.stopButton.centerYAnchor constraintEqualToAnchor:self.stopButton.superview.centerYAnchor],
        [self.stopButton.rightAnchor constraintEqualToAnchor:self.volumeControl.leftAnchor constant:-kInnerEdgeMargin],
        [self.stopButton.widthAnchor constraintEqualToConstant:self.stopButton.buttonSize.width],
        [self.stopButton.heightAnchor constraintEqualToAnchor:self.stopButton.widthAnchor],

        [self.playPauseButton.centerYAnchor constraintEqualToAnchor:self.playPauseButton.superview.centerYAnchor],
        [self.playPauseButton.rightAnchor constraintEqualToAnchor:self.stopButton.leftAnchor constant:-kInnerEdgeMargin],
        [self.playPauseButton.widthAnchor constraintEqualToConstant:self.playPauseButton.buttonSize.width],
        [self.playPauseButton.heightAnchor constraintEqualToAnchor:self.playPauseButton.widthAnchor],

        [self.titleTextField.leftAnchor constraintEqualToAnchor:self.coverart.rightAnchor constant:kOuterEdgeMargin/2],
        [self.titleTextField.rightAnchor constraintEqualToAnchor:self.playPauseButton.leftAnchor constant:-kInnerEdgeMargin],
        [self.titleTextField.bottomAnchor constraintEqualToAnchor:self.titleTextField.superview.bottomAnchor constant:-kOuterEdgeMargin/2],

        [self.timeIcon.leftAnchor constraintEqualToAnchor:self.coverart.rightAnchor constant:kInnerEdgeDoubleMargin-4],
        [self.timeIcon.topAnchor constraintEqualToAnchor:self.timeIcon.superview.topAnchor constant:kOuterEdgeMargin/2],

        [self.timeTextField.leftAnchor constraintEqualToAnchor:self.timeIcon.rightAnchor constant:kInnerEdgeMargin/2],
        [self.timeTextField.centerYAnchor constraintEqualToAnchor:self.timeIcon.centerYAnchor constant:-2.0],

        [self.listenerIcon.centerYAnchor constraintEqualToAnchor:self.timeIcon.centerYAnchor],
        [self.listenerIcon.leftAnchor constraintEqualToAnchor:self.timeIcon.rightAnchor constant:kOuterEdgeMargin*4],

        [self.listenerTextField.leftAnchor constraintEqualToAnchor:self.listenerIcon.rightAnchor constant:kInnerEdgeMargin/2],
        [self.listenerTextField.centerYAnchor constraintEqualToAnchor:self.timeTextField.centerYAnchor],
    ]];
}

// MARK: - Notifications

- (void)handlePlayerDidStartPlayingNotification:(NSNotification *)note {
    self.playPauseButton.state = NSOnState;
}

- (void)handlePlayerDidResumePlayingNotification:(NSNotification *)note {
    self.playPauseButton.state = NSOnState;
}

- (void)handlePlayerDidPausePlayingNotification:(NSNotification *)note {
    self.playPauseButton.state = NSOffState;
}

- (void)handlePlayerDidStopPlayingNotification:(NSNotification *)note {
    self.playPauseButton.state = NSOffState;
}

- (void)handlePlayerDidChangedChannelNotification:(NSNotification *)note {
    CCNChannel *playingChannel = note.userInfo[kUserInfoPlayingChannelKey];
    CCNChannel *replacedChannel = note.userInfo[kUserInfoReplacedChannelKey];
    if ([playingChannel isEqual:self.channel]) {
        self.playPauseButton.state = NSOffState;
    }
    else if([replacedChannel isEqual:self.channel]) {
        self.playPauseButton.state = NSOnState;
    }
}

// MARK: - Push Notifications

- (void)handlePushNotificationChannelListenerCountUpdated:(NSNotification *)note {
    let userInfo      = note.userInfo;
    let listenerCount = [userInfo[kRemoteNotificationListenerCountKey] integerValue];
    let channelId     = (NSString *)userInfo[kRemoteNotificationChannelIdKey];

    if ([self.channel.channelId isEqualToString:channelId] && self.channel.listenerCount != listenerCount) {
        [self.listenerTextField setStringValue:[NSString stringWithFormat:[self listenerCountTextForCount:listenerCount], listenerCount]
                                      animated:YES];
    }
}

// MARK: - Helper

- (NSTextField *)defaultTextField {
    let _textField = NSTextField.new;
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.textColor       = NSColor.controlTextColor;
    _textField.backgroundColor = NSColor.clearColor;
    _textField.wantsLayer      = YES;
    _textField.selectable      = NO;
    _textField.bordered        = NO;
    _textField.editable        = NO;

    return _textField;
}

- (NSString *)listenerCountTextForCount:(NSInteger)listenerCount {
    let formatString = (listenerCount == 1 ? [NSString listenerCountSingularFormatString] : [NSString listenerCountPluralFormatString]);
    return [NSString stringWithFormat:formatString, listenerCount];
}

// MARK: - Custom Accessors

- (void)setChannel:(CCNChannel *)channel {
    _channel = channel;

    self.timeTextField.stringValue = @"00:00:00";
    [self.titleTextField setStringValue:self.channel.name animated:YES];

    @weakify(self);
    [NSImage loadFromURL:self.channel.coverartThumbnail200URL
        placeholderImage:NSImage.channelPlaceholder
         prefetchHandler:^(NSImage *cachedImage) {
             @strongify(self);
             if (cachedImage) {
                 [self.coverart crossfadeToImage:cachedImage completion:nil];
             }
         }
         fetchCompletion:^(NSImage *fetchedImage, BOOL isCached) {
             @strongify(self);
             [self.coverart crossfadeToImage:fetchedImage completion:nil];
         }];

    [self.channel.parseObject fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            @strongify(self);
            self.channel.listenerCount = [object[CCNChannelFieldListenerCount] integerValue];
            [self.listenerTextField setStringValue:[self listenerCountTextForCount:self.channel.listenerCount] animated:YES];
        }
    }];
}

- (void)drawRect:(NSRect)dirtyRect {
    self.timeIcon.tintColor                 = NSColor.controlTextColor;
    self.listenerIcon.tintColor             = NSColor.controlTextColor;

    self.titleTextField.textColor           = NSColor.controlTextColor;
    self.listenerTextField.textColor        = NSColor.controlTextColor;
    self.timeTextField.textColor            = NSColor.controlTextColor;

    self.playPauseButton.tintColor          = NSColor.playerButtonBorderColor;
    self.playPauseButton.tintHighlightColor = NSColor.playerButtonHighlightColor;

    self.stopButton.tintColor               = NSColor.playerButtonBorderColor;
    self.stopButton.tintHighlightColor      = NSColor.playerButtonHighlightColor;
}

@end
