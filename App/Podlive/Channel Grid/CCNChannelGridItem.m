//
//  Created by Frank Gregor on 28/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNApplicationDelegate.h"

#import "CCNChannelGridItem.h"
#import "CCNChannelGridItemView.h"
#import "CCNChannelGridItemControlView.h"
#import "CCNChannel.h"
#import "CCNChannel+Convenience.h"

#import "CCNPlayerView.h"
#import "CCNPlayerViewController.h"
#import "CCNPlayerPlayPauseButton.h"

#import "NSButton+Tools.h"
#import "NSColor+Podlive.h"
#import "NSFont+Podlive.h"
#import "NSString+Podlive.h"
#import "PFUser+Podlive.h"



@interface CCNChannelGridItem () <NSCollectionViewElement>
@property (nonatomic, readonly) CCNChannelGridItemView *contentView;
@property (nonatomic, strong) NSTrackingArea *tracker;
@end

@implementation CCNChannelGridItem

- (void)loadView {
    self.view = CCNChannelGridItemView.new;
}

- (void)viewDidLoad {
    [self setupNotifications];

    [super viewDidLoad];
}

- (void)viewDidAppear {
    [super viewDidAppear];

    self.tracker = [[NSTrackingArea alloc] initWithRect:self.contentView.imageContainer.bounds
                                                options:(NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited | NSTrackingAssumeInside)
                                                  owner:self
                                               userInfo:nil];
    [self.contentView.imageContainer addTrackingArea:self.tracker];
    self.contentView.trackingAreaEnabled = YES;
}

- (void)viewWillDisappear {
    [super viewWillDisappear];

    [self.contentView.imageContainer removeTrackingArea:self.tracker];

}

- (void)dealloc {
    CCNLogInfo(@"dealloc");
    self.channel = nil;
    [self.contentView.imageContainer removeTrackingArea:self.tracker];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.selected = NO;
    self.highlightState = NSCollectionViewItemHighlightNone;
    self.channel = nil;
    [self presentOverlay:NO];
}

// MARK: - Setup UI

- (void)setupNotifications {
    let nc = NSNotificationCenter.defaultCenter;
    [nc addObserver:self selector:@selector(handleChannelSubscriptionUpdatedNotification:)      name:CCNChannelSubscriptionUpdatedNotification object:nil];
    [nc addObserver:self selector:@selector(handlePushNotificationChannelStateUpdated:)         name:CCNPushNotificationChannelStateUpdated object:nil];
    [nc addObserver:self selector:@selector(handlePushNotificationChannelListenerCountUpdated:) name:CCNPushNotificationChannelListenerCountUpdated object:nil];
    [nc addObserver:self selector:@selector(handleLogInSuccessNotification:)                    name:CCNLogInSuccessNotification object:nil];
    [nc addObserver:self selector:@selector(handleLogOutNotification:)                          name:CCNLogOutNotification object:nil];
    [nc addObserver:self selector:@selector(handleScrollViewWillStartLiveScrollNotification:)   name:NSScrollViewWillStartLiveScrollNotification object:nil];
    [nc addObserver:self selector:@selector(handleScrollViewDidEndLiveScrollNotification:)      name:NSScrollViewDidEndLiveScrollNotification object:nil];
}

// MARK: - Event Handling

- (void)mouseEntered:(NSEvent *)event {
    let appDelegate = (CCNApplicationDelegate *)NSApp.delegate;
    let playerView = (CCNPlayerView *)appDelegate.playerViewController.view;
    let hoverPoint = event.locationInWindow;

    if (!NSPointInRect(hoverPoint, playerView.frame)) {
        [self presentOverlay:YES];
    }
}

- (void)mouseExited:(NSEvent *)event {
    [self presentOverlay:NO];
}

- (void)mouseUp:(NSEvent *)event {
    if (event.type == NSEventTypeLeftMouseUp && self.isSelected) {
        [self.collectionView deselectAll:self];
    }
    else {
        [super mouseUp:event];
    }
}

// MARK: - Notifications

- (void)handleChannelSubscriptionUpdatedNotification:(NSNotification *)note {
    [self.channel.parseObject fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self updateChannelNameLabel];
        [self updateChannelStatusLabel];
    }];
}

- (void)handleLogInSuccessNotification:(NSNotification *)note {
    [self updateChannelNameLabel];
}

- (void)handleLogOutNotification:(NSNotification *)note {
    [self updateChannelNameLabel];
}

- (void)handleScrollViewWillStartLiveScrollNotification:(NSNotification *)note {
    [self presentOverlay:NO];
    self.contentView.trackingAreaEnabled = NO;
}

- (void)handleScrollViewDidEndLiveScrollNotification:(NSNotification *)note {
    self.contentView.trackingAreaEnabled = YES;
}

// MARK: - Push Notifications

- (void)handlePushNotificationChannelStateUpdated:(NSNotification *)note {
    let userInfo = note.userInfo;
    if ([self.channel.channelId isEqualToString:userInfo[kRemoteNotificationChannelIdKey]]) {
        @weakify(self);
        [self.channel.parseObject fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            @strongify(self);
            [self updateChannelStatusLabel];
            self.contentView.trackingAreaEnabled = YES;
        }];
    }
}

- (void)handlePushNotificationChannelListenerCountUpdated:(NSNotification *)note {
    let userInfo = note.userInfo;
    if ([self.channel.channelId isEqualToString:userInfo[kRemoteNotificationChannelIdKey]]) {
        [self.channel.parseObject fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [self updateChannelStatusLabel];
        }];
    }

}

// MARK: - Custom Accessors

- (CCNChannelGridItemView *)contentView {
    return (CCNChannelGridItemView *)self.view;
}

- (NSImageView *)imageView {
    return self.contentView.imageView;
}

- (void)setChannel:(CCNChannel *)channel {
    _channel = channel;
    if (_channel) {
        [self updateChannelNameLabel];
        [self updateChannelStatusLabel];
    }
}

// MARK: - Private Helper

- (void)updateChannelNameLabel {
    let isSubscribed = [PFUser.currentUser isSubscribedToChannel:self.channel];
    self.contentView.textField.attributedStringValue = [self attributedStringForChannel:self.channel subscribed:isSubscribed];
}

- (void)updateChannelStatusLabel {
    if (self.channel.isOnline) {
        let channelStateString = [CCNChannel humanReadableStateStringForChannelState:self.channel.state];
        let listenerCountFormat = (self.channel.listenerCount == 1 ? [NSString listenerCountSingularFormatString] : [NSString listenerCountPluralFormatString]);
        let listenerCountString = [NSString stringWithFormat:listenerCountFormat, self.channel.listenerCount];
        self.contentView.channelStatusLabel.stringValue = [NSString stringWithFormat:@"%@, %@", channelStateString, listenerCountString];
    }
    else {
        let followerCountFormat = (self.channel.followerCount == 1 ? [NSString followerCountSingularFormatString] : [NSString followerCountPluralFormatString]);
        self.contentView.channelStatusLabel.stringValue = [NSString stringWithFormat:followerCountFormat, self.channel.followerCount];
    }
}

- (void)presentOverlay:(BOOL)mouseEnter {
    if (!self.contentView.trackingAreaEnabled) {
        return;
    }

    @weakify(self);

    if (mouseEnter) {
        [self updateChannelNameLabel];

        let player = CCNPlayer.sharedInstance;
        BOOL channelIsPlaying = ([player.currentChannel isEqual:self.channel] && (player.status == CCNPlayerStatusPlaying || player.status == CCNPlayerStatusWaiting));

        let controlView = CCNChannelGridItemControlView.new;
        controlView.channel = self.channel;
        controlView.playPauseButton.state = NSControlStateValueOff;
        controlView.playPauseButton.state = (channelIsPlaying ? NSControlStateValueOn : NSControlStateValueOff);
        controlView.playPauseButton.actionHandler = ^(__kindof CCNBaseButton *actionButton) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(handlePlayPauseActionForGridItem:)]) {
                [self.delegate handlePlayPauseActionForGridItem:self];
            }
        };

        controlView.subscribeButton.actionHandler = ^(NSButton *actionButton) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(handleSubscribeActionForGridItem:)]) {
                [self.delegate handleSubscribeActionForGridItem:self];
            }
        };
        self.contentView.controlView = controlView;
        [self.contentView.imageContainer addSubview:self.contentView.controlView];
    }
    else {
        [self.contentView.controlView removeFromSuperview];
        self.contentView.controlView = nil;
    }
    [self.contentView setNeedsUpdateConstraints:YES];


    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.15;

        @strongify(self);
        self.contentView.controlView.animator.alphaValue = (mouseEnter ? 1.0 : 0.0);
        self.contentView.imageView.animator.alphaValue   = (mouseEnter ? 0.55 : 1.0);

    } completionHandler:nil];
}

- (NSAttributedString *)attributedStringForChannel:(CCNChannel *)channel subscribed:(BOOL)subscribed {
    NSParameterAssert(channel);

    let channelNameAttributes = @{
        NSForegroundColorAttributeName: (self.selected ? NSColor.gridItemSelectionForegroundColor: NSColor.controlTextColor),
        NSFontAttributeName: [NSFont fontWithName:NSFont.podliveRegularFontName size:14.0]
    };

    NSMutableParagraphStyle *style = [NSParagraphStyle.defaultParagraphStyle mutableCopy];
    style.alignment = NSTextAlignmentCenter;

    let textAlignmentAttributes = @{
        NSParagraphStyleAttributeName: style
    };

    let result = NSMutableAttributedString.new;
    if (subscribed) {
        let starAttributes = @{
            NSForegroundColorAttributeName: NSColor.gridItemSubscriptionBadgeColor,
            NSFontAttributeName: [NSFont fontWithName:NSFont.podliveRegularFontName size:11.0]
        };

        let star = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"★ ", nil) attributes:starAttributes];
        [result appendAttributedString:star];
    }
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:channel.name attributes:channelNameAttributes]];
    [result addAttributes:textAlignmentAttributes range:NSMakeRange(0, result.length)];
    
    return result;
}

@end
