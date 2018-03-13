//
//  Created by Frank Gregor on 21/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNConstants.h"

@implementation CCNConstants

// MARK: - Parse Data

+ (NSString *)parseApplicationId {
#if TESTSERVER
    return @"iePaewo3chah2cis0ophei9moosh5ief7ooviereithiemaech";
#else
    return @"ni2aeFaed4goo3feis2doo7vegeoy5iJaip0Aexech5Iegahp1";
#endif
}

+ (NSString *)parseClientKey {
#if TESTSERVER
    return @"eiquudihe5Ohgh6IeVu2Ahy1pai0iDie4aJai0iewohW4ju9Oo";
#else
    return @"boopup4quoludoh0ohSh8du8iophohhouYixaighi0ohp0Pah2";
#endif
}

+ (NSString *)parseServer{
#if TESTSERVER
    return @"https://podlive-parse-server-test.herokuapp.com/parse";
#else
    return @"https://podlive-parse-server.herokuapp.com/parse";
#endif
}

@end


// NSEvent keyCode's
unsigned short CCNReturnKeyCode = 13;
unsigned short CCNEscapeKeyCode = 53;


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


// NSUserDefaults
NSString *const CCNCurrentAppearance                       = @"CCNCurrentAppearance";


// Player
NSString *const CCNPlayerDidStartPlayingNotification       = @"CCNPlayerDidStartPlayingNotification";
NSString *const CCNPlayerDidChangedChannelNotification     = @"CCNPlayerDidChangedChannelNotification";
NSString *const CCNPlayerDidPausePlayingNotification       = @"CCNPlayerDidPausePlayingNotification";
NSString *const CCNPlayerDidStopPlayingNotification        = @"CCNPlayerDidStopPlayingNotification";
NSString *const CCNPlayerDidResumePlayingNotification      = @"CCNPlayerDidResumePlayingNotification";
NSString *const CCNPlayerErrorPlayingNotification          = @"CCNPlayerErrorPlayingNotification";



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
