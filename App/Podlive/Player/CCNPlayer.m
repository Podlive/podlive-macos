//
//  Created by Frank Gregor on 24/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CCNPlayer.h"
#import "CCNChannel.h"

const CGFloat kCCNPlayerViewHeight = 65.0;

@interface CCNPlayer ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) CCNChannel *currentChannel;
@property (nonatomic, strong) CCNChannel *replacedChannel;
@property (nonatomic, strong) id playingTimeObserver;
@end

@implementation CCNPlayer

+ (instancetype)sharedInstance {
    static dispatch_once_t _onceToken;
    static id _sharedInstance;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [[self alloc] initSingleton];
        [_sharedInstance setupNotifications];
    });
    return _sharedInstance;
}

- (instancetype)initSingleton {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)init {
    @throw [[self class] initException];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [[self class] initException];
}

+ (NSException *)initException {
    let exceptionMessage = [NSString stringWithFormat:@"'%@' is a Singleton, and you must NOT init manually! Use +sharedInstance instead.", [self className]];
    return [NSException exceptionWithName:NSInternalInconsistencyException reason:exceptionMessage userInfo:nil];
}

- (void)setupNotifications {
    let nc = NSNotificationCenter.defaultCenter;
    [nc addObserver:self selector:@selector(handlePlayerItemDidPlayToEndTimeNotification:)      name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [nc addObserver:self selector:@selector(handlePlayerItemFailedToPlayToEndTimeNotification:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [nc addObserver:self selector:@selector(handlePlayerItemTimeJumpedNotification:)            name:AVPlayerItemTimeJumpedNotification object:nil];
    [nc addObserver:self selector:@selector(handlePlayerItemPlaybackStalledNotification:)       name:AVPlayerItemPlaybackStalledNotification object:nil];
}

- (void)handlePlayerItemDidPlayToEndTimeNotification:(NSNotification *)note {
    if ([self.delegate respondsToSelector:@selector(playerItemDidPlayToEndTime:)]) {
        let playerItem = (AVPlayerItem *)note.object;
        [self.delegate playerItemDidPlayToEndTime:playerItem];
    }
}

- (void)handlePlayerItemFailedToPlayToEndTimeNotification:(NSNotification *)note {
    if ([self.delegate respondsToSelector:@selector(playerItemFailedToPlayToEndTime:error:)]) {
        let playerItem = (AVPlayerItem *)note.object;
        let error = (NSError *)note.userInfo[AVPlayerItemFailedToPlayToEndTimeErrorKey];
        [self.delegate playerItemFailedToPlayToEndTime:playerItem error:error];
    }
}

- (void)handlePlayerItemTimeJumpedNotification:(NSNotification *)note {
    if ([self.delegate respondsToSelector:@selector(playerItemTimeJumped:)]) {
        let playerItem = (AVPlayerItem *)note.object;
        [self.delegate playerItemTimeJumped:playerItem];
    }
}

- (void)handlePlayerItemPlaybackStalledNotification:(NSNotification *)note {
    if ([self.delegate respondsToSelector:@selector(playerItemPlaybackStalled:)]) {
        let playerItem = (AVPlayerItem *)note.object;
        [self.delegate playerItemPlaybackStalled:playerItem];
    }
}

- (void)setupPlayerWithChannel:(nonnull CCNChannel *)channel {
    let notificationCenter = NSNotificationCenter.defaultCenter;
    __block var userInfo = NSMutableDictionary.new;
    __block var playerItem = (AVPlayerItem *)nil;

    if (self.currentChannel) {
        self.replacedChannel = self.currentChannel;
    }

    @weakify(self);
    let changedChannelBlock = ^{
        @strongify(self);

        userInfo[kUserInfoReplacedChannelKey] = self.currentChannel;
        userInfo[kUserInfoPlayingChannelKey] = channel;
        [notificationCenter postNotificationName:CCNPlayerDidChangedChannelNotification object:nil userInfo:userInfo];

        self.currentChannel = channel;
        playerItem = [AVPlayerItem playerItemWithURL:self.currentChannel.streamURL];

        [self.player pause];
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        [self.player play];

        [self startPlayingTimeObserver];
    };

    switch (self.status) {
        case CCNPlayerStatusUndefined: {
            self.currentChannel = channel;
            playerItem = [AVPlayerItem playerItemWithURL:self.currentChannel.streamURL];
            self.player = [AVPlayer playerWithPlayerItem:playerItem];
            self.player.volume = self.volume;
            [self play];

            [self startPlayingTimeObserver];

            break;
        }
        case CCNPlayerStatusPaused: {
            if ([self.currentChannel isEqual:channel]) {
                [self.player play];

                userInfo[kUserInfoPlayingChannelKey] = self.currentChannel;
                [notificationCenter postNotificationName:CCNPlayerDidResumePlayingNotification object:nil userInfo:userInfo];
            }
            else {
                changedChannelBlock();
            }
            break;
        }

        default: {
            if ([self.currentChannel isEqual:channel]) {
                [self pause];
            }
            else {
                changedChannelBlock();
            }
            break;
        }
    }
}

- (void)startPlayingTimeObserver {
    if (self.playingTimeObserver) {
        [self.player removeTimeObserver:self.playingTimeObserver];
        self.playingTimeObserver = nil;
    }

    @weakify(self);

    let startTime = NSDate.date;
    __block var endTime = (NSDate *)nil;

    CMTime interval = CMTimeMakeWithSeconds(0.5, 100);
    self.playingTimeObserver = [self.player addPeriodicTimeObserverForInterval:interval
                                                                         queue:NULL
                                                                    usingBlock:^(CMTime time) {
                                                                        endTime = NSDate.date;
                                                                        let secondsElapsed = [endTime timeIntervalSinceDate:startTime];

                                                                        @strongify(self);
                                                                        [self.delegate playerCurrentPlayingTime:secondsElapsed];
                                                                    }];
}

// MARK: - Audio Control

- (void)play {
    if (!self.currentChannel) {
        CCNLogError(@"Before playing, please set a channel using 'setupPlayerWithChannel:'");
        return;
    }

    [self.player play];

    let userInfo = @{ kUserInfoPlayingChannelKey: self.currentChannel };
    [NSNotificationCenter.defaultCenter postNotificationName:CCNPlayerDidStartPlayingNotification object:nil userInfo:userInfo];
}

- (void)resume {
    if (!self.currentChannel) {
        CCNLogError(@"Before playing, please set a channel using 'setupPlayerWithChannel:'");
        return;
    }

    [self.player play];

    let userInfo = @{ kUserInfoPlayingChannelKey: self.currentChannel };
    [NSNotificationCenter.defaultCenter postNotificationName:CCNPlayerDidResumePlayingNotification object:nil userInfo:userInfo];
}

- (void)pause {
    if (!self.currentChannel) {
        CCNLogInfo(@"Nothing to stop. The player isn't playing.");
        return;
    }

    [self.player pause];

    let userInfo = @{ kUserInfoPlayingChannelKey: self.currentChannel };
    [NSNotificationCenter.defaultCenter postNotificationName:CCNPlayerDidPausePlayingNotification object:nil userInfo:userInfo];
}

- (void)stop {
    if (!self.currentChannel) {
        CCNLogInfo(@"Nothing to stop. The player isn't playing.");
        return;
    }

    [self.player pause];
    [self.player removeTimeObserver:self.playingTimeObserver];
    self.playingTimeObserver = nil;
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;

    let userInfo = @{ kUserInfoPlayingChannelKey: self.currentChannel };
    [NSNotificationCenter.defaultCenter postNotificationName:CCNPlayerDidStopPlayingNotification object:nil userInfo:userInfo];

    self.currentChannel = nil;
    self.replacedChannel = nil;
}

// MARK: - Custom Accessors

- (CCNPlayerStatus)status {
    return (self.player ? (CCNPlayerStatus)self.player.timeControlStatus : CCNPlayerStatusUndefined);
}

- (void)setVolume:(float)volume {
    _volume = volume;
    self.player.volume = _volume;
}

@end
