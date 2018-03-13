//
//  Created by Frank Gregor on 21/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@interface CCNNotificationCoordinator : NSObject

+ (instancetype)coordinatorWithRemoteNotification:(NSDictionary<NSString *, id> *)remoteNotification;
- (instancetype)init NS_UNAVAILABLE;

- (void)handleRemoteNotification;

@end

FOUNDATION_EXPORT NSString *const kRemoteNotificationApsKey;
FOUNDATION_EXPORT NSString *const kRemoteNotificationPayloadKey;
FOUNDATION_EXPORT NSString *const kRemoteNotificationCategoryKey;
FOUNDATION_EXPORT NSString *const kRemoteNotificationChannelIdKey;
FOUNDATION_EXPORT NSString *const kRemoteNotificationListenerCountKey;
