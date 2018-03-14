//
//  Created by Frank Gregor on 21/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <Parse/Parse.h>

typedef NS_ENUM(NSInteger, CCNChannelState) {
    CCNChannelStateUndefined = -1,
    CCNChannelStatePreshow   = 0,
    CCNChannelStateLive      = 1,
    CCNChannelStatePostShow  = 2,
    CCNChannelStateOffline   = 3,
    CCNChannelStateOnline    = 4,
    CCNChannelStateBreak     = 5
};

typedef NS_ENUM(NSUInteger, CCNStreamingBackend) {
    CCNStreamingBackendUndefined  = -1,
    CCNStreamingBackendXenim      = 0,
    CCNStreamingBackendStudioLink = 1
};

typedef void (^CCNChannelCoverartCompletion)(NSImage *_Nonnull fetchedImage);


@interface CCNChannel : NSObject <NSCopying>

+ (nullable instancetype)channelWithObject:(__kindof PFObject*_Nullable)inParseObject;
- (nullable instancetype)initWithObject:(__kindof PFObject*_Nullable)inParseObject NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)init NS_UNAVAILABLE;

@property (nonatomic, readonly) PFObject *_Nonnull parseObject;

// MARK: - Model Properties
@property (nonnull, nonatomic, readonly) NSString *channelId;
@property (nullable, nonatomic, readonly) NSString *creator;
@property (nullable, nonatomic, readonly) NSString *name;
@property (nullable, nonatomic, readonly) NSString *email;
@property (nullable, nonatomic, readonly) NSString *channelDescription;
@property (nullable, nonatomic, readonly) NSString *twitterUsername;
@property (nullable, nonatomic, readonly) NSURL *coverartURL;
@property (nullable, nonatomic, readonly) NSURL *coverartThumbnail200URL;
@property (nullable, nonatomic, readonly) NSURL *coverartThumbnail800URL;
@property (nullable, nonatomic, readonly) NSURL *streamURL;
@property (nullable, nonatomic, readonly) NSURL *websiteURL;
@property (nullable, nonatomic, readonly) NSURL *chatURL;
@property (nonatomic, readonly) CCNChannelState state;
@property (nonatomic, readonly) CCNStreamingBackend streamingBackend;
@property (nonatomic, assign) NSInteger listenerCount;
@property (nonatomic, assign) NSInteger followerCount;
@property (nonatomic, readonly) BOOL isEnabled;

// MARK: - Computed Properties
@property (nullable, nonatomic, readonly) NSURL *twitterURL;
@property (nonatomic, readonly) BOOL isOnline;

// MARK: - Custom Properties
@property (nonatomic, assign) NSInteger listenerCountPeak;

@end



FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldCoverart;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldCoverartThumbnail200;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldCoverartThumbnail800;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldCreator;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldName;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldEmail;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldDescription;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldStreamUrl;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldState;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldStreamingBackend;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldWebsiteUrl;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldChatUrl;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldListenerCount;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldTwitterUsername;
FOUNDATION_EXPORT NSString *_Nonnull const CCNChannelFieldIsEnabled;
