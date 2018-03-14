//
//  Created by Frank Gregor on 01/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <Parse/Parse.h>

@class CCNChannel;

@interface PFUser (Podlive)

@property (nonnull, nonatomic, readonly) NSString *userId;
@property (nullable, nonatomic, readonly) NSArray<NSString *> *channelIds;

@property (nonatomic, readonly) BOOL hasSubscribedChannels;

- (BOOL)isSubscribedToChannel:(CCNChannel *_Nonnull)channel;
- (void)toggleSubscriptionForChannel:(CCNChannel *_Nonnull)channel;

@end
