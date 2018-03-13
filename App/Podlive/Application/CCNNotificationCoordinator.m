//
//  Created by Frank Gregor on 21/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNNotificationCoordinator.h"

NSString *const kRemoteNotificationApsKey           = @"aps";
NSString *const kRemoteNotificationPayloadKey       = @"payload";
NSString *const kRemoteNotificationCategoryKey      = @"category";
NSString *const kRemoteNotificationChannelIdKey     = @"channelId";
NSString *const kRemoteNotificationListenerCountKey = @"listenerCount";

static NSString *const kPushNotificationChannelCreatedKey              = @"CHANNEL_CREATED";
static NSString *const kPushNotificationChannelRemovedKey              = @"CHANNEL_REMOVED";
static NSString *const kPushNotificationChannelStateUpdatedKey         = @"CHANNEL_STATE_UPDATED";
static NSString *const kPushNotificationChannelListenerCountUpdatedKey = @"CHANNEL_LISTENER_COUNT_UPDATED";
static NSString *const kPushNotificationUserUpdatedKey                 = @"USER_UPDATED";
static NSString *const kPushNotificationUserChannelsUpdatedKey         = @"USER_CHANNELS_UPDATED";

@interface CCNNotificationCoordinator ()
@property (nonatomic, copy) NSDictionary<NSString *, id> *remoteNotification;
@end

@implementation CCNNotificationCoordinator

+ (instancetype)coordinatorWithRemoteNotification:(NSDictionary<NSString *, id> *)remoteNotification {
    return [[[self class] alloc] initWithRemoteNotification:remoteNotification];
}

- (instancetype)initWithRemoteNotification:(NSDictionary<NSString *, id> *)remoteNotification {
    self = [super init];
    if (!self) return nil;

    self.remoteNotification = remoteNotification;

    return self;
}

- (void)dealloc {
    CCNLogInfo(@"dealloc");
}

// MARK: - Process Push Notification Categories

- (void)handleRemoteNotification {
    NSDictionary<NSString *, id> *aps = self.remoteNotification[kRemoteNotificationApsKey];
    NSDictionary<NSString *, id> *payload = self.remoteNotification[kRemoteNotificationPayloadKey];

    CCNLogInfo(@"aps: %@", aps);
    CCNLogInfo(@"payload: %@", payload);

    let category = (NSString *)aps[kRemoteNotificationCategoryKey];

    if ([category isEqualToString:kPushNotificationChannelCreatedKey]) {
        [self handlePushNotificationChannelCreated:payload];
    }
    else if ([category isEqualToString:kPushNotificationChannelRemovedKey]) {
        [self handlePushNotificationChannelRemoved:payload];
    }
    else if ([category isEqualToString:kPushNotificationChannelStateUpdatedKey]) {
        [self handlePushNotificationChannelStateUpdated:payload];
    }
    else if ([category isEqualToString:kPushNotificationChannelListenerCountUpdatedKey]) {
        [self handlePushNotificationChannelListenerCountUpdated:payload];
    }
    else if ([category isEqualToString:kPushNotificationUserUpdatedKey] || [category isEqualToString:kPushNotificationUserChannelsUpdatedKey]) {
        [self handlePushNotificationUserUpdated:payload];
    }
}

// MARK: - Handle Push Notifications

- (void)handlePushNotificationChannelCreated:(NSDictionary<NSString *, id> *)payload {
}

- (void)handlePushNotificationChannelRemoved:(NSDictionary<NSString *, id> *)payload {
}

- (void)handlePushNotificationChannelStateUpdated:(NSDictionary<NSString *, id> *)payload {
    let nc = NSNotificationCenter.defaultCenter;
    [nc postNotificationName:CCNPushNotificationChannelStateUpdated object:nil userInfo:payload];
}

- (void)handlePushNotificationChannelListenerCountUpdated:(NSDictionary<NSString *, id> *)payload {
    let nc = NSNotificationCenter.defaultCenter;
    [nc postNotificationName:CCNPushNotificationChannelListenerCountUpdated object:nil userInfo:payload];
}

- (void)handlePushNotificationUserUpdated:(NSDictionary<NSString *, id> *)payload {
    [CCNUserManager.sharedManager updateUserWithCompletion:^{
        let nc = NSNotificationCenter.defaultCenter;
        [nc postNotificationName:CCNChannelSubscriptionUpdatedNotification object:payload];
    }];
}

@end
