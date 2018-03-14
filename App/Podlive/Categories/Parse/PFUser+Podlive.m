//
//  Created by Frank Gregor on 01/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "PFUser+Podlive.h"
#import "CCNChannel.h"

@implementation PFUser (Podlive)

- (NSString *)userId {
    return self.objectId;
}

- (NSArray<NSString *> *)channelIds {
    return self[kChannelsKeyPath];
}

- (BOOL)hasSubscribedChannels {
    return self.channelIds.count > 0;
}

- (BOOL)isSubscribedToChannel:(CCNChannel *)channel {
    return [self.channelIds containsObject:channel.channelId];
}

- (void)toggleSubscriptionForChannel:(CCNChannel *)channel{
    if ([self isSubscribedToChannel:channel]) {
        CCNLogInfo(@"turn off subscription");
        [self removeObject:channel.channelId forKey:kChannelsKeyPath];
    }
    else {
        CCNLogInfo(@"turn on subscription");
        [self addUniqueObject:channel.channelId forKey:kChannelsKeyPath];
    }
    [self saveInBackground];
}

@end
