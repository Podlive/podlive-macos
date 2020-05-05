//
//  Created by Frank Gregor on 21/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNConstants.h"

typedef NS_ENUM(NSInteger, CCNBackendType) {
    CCNBackendTypeTest = 0,
    CCNBackendTypeProduction = 1
};

static NSString *const CCNParseApplicationId = @"ParseApplicationId";
static NSString *const CCNParseClientKey     = @"ParseClientKey";
static NSString *const CCNParseServerUrl     = @"ParseServerUrl";

@implementation CCNConstants

// MARK: - Parse Data

+ (NSString *)parseApplicationId {
#if TESTSERVER
    return [self valueForBackendType:CCNBackendTypeTest withKey:CCNParseApplicationId];
#else
    return [self valueForBackendType:CCNBackendTypeProduction withKey:CCNParseApplicationId];
#endif
}

+ (NSString *)parseClientKey {
#if TESTSERVER
    return [self valueForBackendType:CCNBackendTypeTest withKey:CCNParseClientKey];
#else
    return [self valueForBackendType:CCNBackendTypeProduction withKey:CCNParseClientKey];
#endif
}

+ (NSString *)parseServerUrl {
#if TESTSERVER
    return [self valueForBackendType:CCNBackendTypeTest withKey:CCNParseServerUrl];
#else
    return [self valueForBackendType:CCNBackendTypeProduction withKey:CCNParseServerUrl];
#endif
}

+ (NSString *)valueForBackendType:(CCNBackendType)backendType withKey:(NSString *)key {
    let parsePlist = [NSBundle.mainBundle pathForResource:@"Parse" ofType:@"plist"];
    if (parsePlist) {
        let parseArray = [NSArray arrayWithContentsOfFile:parsePlist];
        return parseArray[backendType][key];
    }

    return nil;
}

@end



// Autolayout
const CGFloat kOuterEdgeMargin       = 20.0;
const CGFloat kInnerEdgeMargin       = 8.0;
const CGFloat kInnerEdgeDoubleMargin = kInnerEdgeMargin * 2;



// Push Notifications
NSString *const CCNPushNotificationChannelStateUpdated         = @"CCNPushNotificationChannelStateUpdated";
NSString *const CCNPushNotificationChannelListenerCountUpdated = @"CCNPushNotificationChannelListenerCountUpdated";


// Internal Notifications
NSString *const CCNUserUpdatedNotification                     = @"CCNUserUpdatedNotification";
NSString *const CCNChannelSubscriptionUpdatedNotification      = @"CCNChannelSubscriptionUpdatedNotification";

NSString *const CCNLogInSuccessNotification                    = @"CCNLogInSuccessNotification";
NSString *const CCNLogInFailureNotification                    = @"CCNLogInFailureNotification";
NSString *const CCNSignUpSuccessNotification                   = @"CCNSignUpSuccessNotification";
NSString *const CCNSignUpFailureNotification                   = @"CCNSignUpFailureNotification";
NSString *const CCNLogOutNotification                          = @"CCNLogOutNotification";


// Parse Notifications
NSString *const CCNParseRealtimeNotifications                       = @"realtimeNotifications";


// NSUserDefaults
NSString *const CCNCurrentAppearance                       = @"CCNCurrentAppearance";


// Player
NSString *const CCNPlayerDidStartPlayingNotification       = @"CCNPlayerDidStartPlayingNotification";
NSString *const CCNPlayerDidChangedChannelNotification     = @"CCNPlayerDidChangedChannelNotification";
NSString *const CCNPlayerDidPausePlayingNotification       = @"CCNPlayerDidPausePlayingNotification";
NSString *const CCNPlayerDidStopPlayingNotification        = @"CCNPlayerDidStopPlayingNotification";
NSString *const CCNPlayerDidResumePlayingNotification      = @"CCNPlayerDidResumePlayingNotification";
NSString *const CCNPlayerErrorPlayingNotification          = @"CCNPlayerErrorPlayingNotification";
NSString *const CCNSearchViewShouldAppearNotification      = @"CCNSearchViewShouldAppearNotification";
NSString *const CCNSearchViewShouldDisappearNotification   = @"CCNSearchViewShouldDisappearNotification";



// KVO KeyPath's
NSString *const kChannelKeyPath                            = @"channel";
NSString *const kChannelsKeyPath                           = @"channels";
NSString *const kUserKeyPath                               = @"user";


// userInfo Dictionary Keys
NSString *const kUserInfoPlayingChannelKey                 = @"playingChannel";
NSString *const kUserInfoReplacedChannelKey                = @"replacedChannel";

NSString *const kUserInfoChannelStateId                    = @"channelId";
NSString *const kUserInfoChannelStateOld                   = @"oldState";
NSString *const kUserInfoChannelStateNew                   = @"newState";
