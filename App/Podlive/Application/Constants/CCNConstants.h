//
//  Created by Frank Gregor on 21/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#define TESTSERVER 0

@interface CCNConstants : NSObject

// Parse Data
+ (NSString *)parseApplicationId;
+ (NSString *)parseClientKey;
+ (NSString *)parseServerUrl;

@end



// Autolayout
FOUNDATION_EXPORT const CGFloat kOuterEdgeMargin;
FOUNDATION_EXPORT const CGFloat kInnerEdgeMargin;
FOUNDATION_EXPORT const CGFloat kInnerEdgeDoubleMargin;

// Notifications
FOUNDATION_EXPORT NSString *const CCNUserUpdatedNotification;
FOUNDATION_EXPORT NSString *const CCNRealtimeNotifications;
FOUNDATION_EXPORT NSString *const CCNPushNotificationChannelStateUpdated;
FOUNDATION_EXPORT NSString *const CCNChannelSubscriptionUpdatedNotification;
FOUNDATION_EXPORT NSString *const CCNPushNotificationChannelListenerCountUpdated;

FOUNDATION_EXPORT NSString *const CCNLogInSuccessNotification;
FOUNDATION_EXPORT NSString *const CCNLogInFailureNotification;
FOUNDATION_EXPORT NSString *const CCNSignUpSuccessNotification;
FOUNDATION_EXPORT NSString *const CCNSignUpFailureNotification;
FOUNDATION_EXPORT NSString *const CCNLogOutNotification;


// Parse Notifications
FOUNDATION_EXPORT NSString *const CCNParseRealtimeNotifications;


// NSUserDefaults
FOUNDATION_EXPORT NSString *const CCNCurrentAppearance;


// Player
FOUNDATION_EXPORT NSString *const CCNPlayerDidStartPlayingNotification;     // notification object is nil, userInfo dictionary contains the current playing channel, identified with kChannelKeyPath
FOUNDATION_EXPORT NSString *const CCNPlayerDidChangedChannelNotification;   // notification object is nil, userInfo dictionary contains the current playing channel, identified with kChannelKeyPath
FOUNDATION_EXPORT NSString *const CCNPlayerDidPausePlayingNotification;     // notification object is nil, userInfo dictionary contains the stopped channel, identified with kChannelKeyPath
FOUNDATION_EXPORT NSString *const CCNPlayerDidStopPlayingNotification;      // notification object is nil, userInfo dictionary contains the stopped channel, identified with kChannelKeyPath
FOUNDATION_EXPORT NSString *const CCNPlayerDidResumePlayingNotification;    // notification object is nil, userInfo dictionary contains the current playing channel, identified with kChannelKeyPath
FOUNDATION_EXPORT NSString *const CCNPlayerErrorPlayingNotification;
FOUNDATION_EXPORT NSString *const CCNSearchViewShouldAppearNotification;
FOUNDATION_EXPORT NSString *const CCNSearchViewShouldDisappearNotification;

typedef NS_ENUM(NSInteger, CCNPlayerVolumeLevelPersistenceBehaviour) {
    CCNPlayerVolumeLevelPersistenceBehaviourGlobal,
    CCNPlayerVolumeLevelPersistenceBehaviourPerChannel                      // this default value
};


// KVO KeyPath's
FOUNDATION_EXPORT NSString *const kChannelKeyPath;
FOUNDATION_EXPORT NSString *const kChannelsKeyPath;
FOUNDATION_EXPORT NSString *const kUserKeyPath;


// userInfo Dictionary Keys
FOUNDATION_EXPORT NSString *const kUserInfoPlayingChannelKey;
FOUNDATION_EXPORT NSString *const kUserInfoReplacedChannelKey;

FOUNDATION_EXPORT NSString *const kUserInfoChannelStateId;
FOUNDATION_EXPORT NSString *const kUserInfoChannelStateOld;
FOUNDATION_EXPORT NSString *const kUserInfoChannelStateNew;


// main windiw toolbar item identifiers
FOUNDATION_EXPORT NSString *const kCCNChannelFilterSegmentControlIdentifier;
FOUNDATION_EXPORT NSString *const kCCNToolbarLoginButtonIdentifier;
