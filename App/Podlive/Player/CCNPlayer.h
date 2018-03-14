//
//  Created by Frank Gregor on 24/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//


@class CCNChannel;
@class AVPlayerItem;

typedef NS_ENUM(NSInteger, CCNPlayerStatus) {
    CCNPlayerStatusPaused,
    CCNPlayerStatusWaiting,
    CCNPlayerStatusPlaying,
    CCNPlayerStatusEnded,
    CCNPlayerStatusUndefined
};


@protocol CCNPlayerDelegate <NSObject>
- (void)playerCurrentPlayingTime:(NSTimeInterval)playingTime;

@optional
- (void)playerItemDidPlayToEndTime:(nonnull AVPlayerItem *)playerItem;
- (void)playerItemFailedToPlayToEndTime:(nonnull AVPlayerItem *)playerItem error:(nullable NSError *)error;
- (void)playerItemTimeJumped:(nonnull AVPlayerItem *)playerItem;
- (void)playerItemPlaybackStalled:(nonnull AVPlayerItem *)playerItem;
@end

@interface CCNPlayer : NSObject

+ (nonnull instancetype)sharedInstance;
- (void)setupPlayerWithChannel:(nonnull CCNChannel *)channel;

@property (nullable, nonatomic, weak) id<CCNPlayerDelegate> delegate;
@property (nonnull, nonatomic, readonly) CCNChannel *currentChannel;
@property (nonatomic, readonly) CCNPlayerStatus status;
@property (nonatomic) float volume;

- (void)play;
- (void)resume;
- (void)pause;
- (void)stop;

@end

FOUNDATION_EXTERN const CGFloat kCCNPlayerViewHeight;
