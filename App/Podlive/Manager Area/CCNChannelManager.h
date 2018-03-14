//
//  Created by Frank Gregor on 21/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@class CCNChannel;

typedef void(^CCNEmptyHandler)(void);

typedef NS_ENUM(NSInteger, CCNChannelListSection) {
    CCNChannelSectionLive = 0,
    CCNChannelSectionOffline = 1
};

typedef NS_ENUM(NSInteger, CCNChannelFilterCriteria) {
    CCNChannelFilterCriteriaAvailable = 0,
    CCNChannelFilterCriteriaSubscribed = 1
};

@interface CCNChannelManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign) CCNChannelFilterCriteria channelFilterCriteria;

- (void)updateWithCompletion:(CCNEmptyHandler)completion;
- (NSDictionary<NSNumber *,NSArray<CCNChannel *> *> *_Nullable)channelsForCurrentFilterCriteria;
- (CCNChannel *_Nullable)channelWithId:(NSString *_Nonnull)channelId;

@end

FOUNDATION_EXPORT NSString *const CCNDidChangeChannelFilterCriteriaNotification;

NS_ASSUME_NONNULL_END
