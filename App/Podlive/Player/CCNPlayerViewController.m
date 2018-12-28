//
//  Created by Frank Gregor on 15/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPlayerViewController.h"
#import "CCNPlayerView.h"
#import "CCNPlayerView_Private.h"
#import "CCNPlayer.h"
#import "CCNPlayerPlayPauseButton.h"
#import "CCNPlayerStopButton.h"
#import "CCNPlayerVolumeControl.h"
#import "CCNChannel.h"

#import "NSAppearance+Podlive.h"
#import "NSSlider+Podlive.h"
#import "NSString+Tools.h"
#import "NSUserDefaults+Podlive.h"


@interface CCNPlayerViewController () <CCNPlayerDelegate>
@property (nonatomic, readonly) CCNPlayerView *contentView;
@property (nonatomic, strong) CCNPlayer *player;
@end

@implementation CCNPlayerViewController

- (void)loadView {
    self.view = CCNPlayerView.new;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    self.player = CCNPlayer.sharedInstance;

    [self setupUI];
    [self setupNotifications];

    [super viewDidLoad];
}

- (void)viewWillAppear {
    [super viewWillAppear];

    [NSAppearance setApplicationAppearanceName:NSAppearance.applicationAppearanceName forWindow:self.view.window];
}

- (void)setupUI {
    let defaults = NSUserDefaults.standardUserDefaults;
    self.player.delegate = self;

    self.contentView.playPauseButton.actionHandler = ^(__kindof CCNBaseButton *actionButton) {
        if (self.player.status == CCNPlayerStatusPaused || self.player.status == CCNPlayerStatusEnded) {
            [self.player resume];
        }
        else {
            [self.player pause];
        }
    };


    self.contentView.stopButton.actionHandler = ^(__kindof CCNBaseButton *actionButton) {
        [self.player stop];
    };


    self.player.volume = defaults.playerVolume;
    self.contentView.volumeControl.slider.floatValue = self.player.volume;
    self.contentView.volumeControl.slider.actionHandler = ^(CCNPlayerVolumeSlider *slider) {
        self.player.volume = slider.floatValue;

        switch (defaults.volumeLevelPersistenceBehaviour) {
            case CCNPlayerVolumeLevelPersistenceBehaviourGlobal:
                defaults.playerVolume = slider.floatValue;
                break;
            case CCNPlayerVolumeLevelPersistenceBehaviourPerChannel:
                [defaults setPlayerVolume:slider.floatValue forChannelId:self.contentView.channel.channelId];
                break;
        }
    };
}

- (void)setupNotifications {
    let notificationCenter = NSNotificationCenter.defaultCenter;
    let mainQueue          = NSOperationQueue.mainQueue;

    @weakify(self);
    let notificationHandler = ^(NSNotification *note) {
        @strongify(self);

        let newChannel = (CCNChannel *)note.userInfo[kUserInfoPlayingChannelKey];
        let defaults   = NSUserDefaults.standardUserDefaults;

        switch (defaults.volumeLevelPersistenceBehaviour) {
            case CCNPlayerVolumeLevelPersistenceBehaviourGlobal: {
                self.contentView.channel = newChannel;
                break;
            }
            case CCNPlayerVolumeLevelPersistenceBehaviourPerChannel: {
                let previousChannel = self.contentView.channel;

                self.contentView.channel = newChannel;

                let newPlayerVolume = [defaults playerVolumeForChannelId:newChannel.channelId];
                let previousPlayerVolume = (previousChannel ? [defaults playerVolumeForChannelId:previousChannel.channelId] : kDefaultPlayerVolume);
                self.player.volume = previousPlayerVolume;
                self.contentView.volumeControl.slider.floatValue = previousPlayerVolume;


                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    context.duration = 0.42;
                    context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

                    self.player.volume = newPlayerVolume;
                    self.contentView.volumeControl.slider.animator.floatValue = newPlayerVolume;

                } completionHandler:nil];
                break;
            }
        }
    };

    [notificationCenter addObserverForName:CCNPlayerDidStartPlayingNotification object:nil queue:mainQueue usingBlock:notificationHandler];
    [notificationCenter addObserverForName:CCNPlayerDidChangedChannelNotification object:nil queue:mainQueue usingBlock:notificationHandler];
}

// MARK: - Custom Accessors

- (CCNPlayerView *)contentView {
    return (CCNPlayerView *)self.view;
}

// MARK: - CCNPlayerDelegate

- (void)playerCurrentPlayingTime:(NSTimeInterval)playingTime {
    self.contentView.timeTextField.stringValue = [NSString stringFromTimeInterval:playingTime];
}

- (void)playerItemDidPlayToEndTime:(nonnull AVPlayerItem *)playerItem {
    CCNLog(@"playerItemDidPlayToEndTime: %@", playerItem);
    [self.player stop];
}

- (void)playerItemFailedToPlayToEndTime:(nonnull AVPlayerItem *)playerItem error:(nullable NSError *)error {
    CCNLog(@"playerItemFailedToPlayToEndTime: %@", playerItem);
    CCNLog(@"error: %@", error);
}

- (void)playerItemTimeJumped:(nonnull AVPlayerItem *)playerItem {
    CCNLog(@"playerItemTimeJumped: %@", playerItem);
}

- (void)playerItemPlaybackStalled:(nonnull AVPlayerItem *)playerItem {
    CCNLog(@"playerItemPlaybackStalled: %@", playerItem);
}

@end
