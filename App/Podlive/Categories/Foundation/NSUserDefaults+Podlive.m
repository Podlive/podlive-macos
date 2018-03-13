//
//  Created by Frank Gregor on 25.11.15.
//  Copyright © 2015 cocoa:naut. All rights reserved.
//

#import "NSUserDefaults+Podlive.h"

NSString *const CCNPrefFirstStart                          = @"IsFirstStart";
NSString *const CCNPrefPlayerVolume                        = @"PlayerVolume";
NSString *const CCNPrefVolumePersistanceBehaviour          = @"VolumePersistanceBehaviour";

NSString *const CCNPrefChannelFilterCriteria               = @"ChannelFilterCriteria";
NSString *const NSUserDefaultsChannelFilterCriteriaKeyPath = @"channelFilterCriteria";

const float kDefaultPlayerVolume = 0.75;

@implementation NSUserDefaults (PodLive)

- (BOOL)isFirstStart {
    return [self boolForKey:CCNPrefFirstStart];
}

- (void)setFirstStart:(BOOL)firstStart {
    [self setBool:firstStart forKey:CCNPrefFirstStart];
    [self synchronize];
}

- (CCNChannelFilterCriteria)channelFilterCriteria {
    if (![self objectForKey:CCNPrefChannelFilterCriteria]) {
        self.channelFilterCriteria = CCNChannelFilterCriteriaAvailable;
    }
    return [self integerForKey:CCNPrefChannelFilterCriteria];
}

- (void)setChannelFilterCriteria:(CCNChannelFilterCriteria)channelFilterCriteria {
    [self setInteger:channelFilterCriteria forKey:CCNPrefChannelFilterCriteria];
    [self synchronize];
}

- (float)playerVolume {
    if (![self objectForKey:CCNPrefPlayerVolume]) {
        self.playerVolume = 0.75;
    }
    return [self floatForKey:CCNPrefPlayerVolume];
}

- (void)setPlayerVolume:(float)playerVolume {
    [self setFloat:playerVolume forKey:CCNPrefPlayerVolume];
    [self synchronize];
}

- (CCNPlayerVolumeLevelPersistenceBehaviour)volumeLevelPersistenceBehaviour {
    if (![self objectForKey:CCNPrefVolumePersistanceBehaviour]) {
        self.volumeLevelPersistenceBehaviour = CCNPlayerVolumeLevelPersistenceBehaviourPerChannel;
    }
    return [self integerForKey:CCNPrefVolumePersistanceBehaviour];
}

- (void)setVolumeLevelPersistenceBehaviour:(CCNPlayerVolumeLevelPersistenceBehaviour)volumeLevelPersistenceBehaviour {
    [self setInteger:volumeLevelPersistenceBehaviour forKey:CCNPrefVolumePersistanceBehaviour];
    [self synchronize];
}

- (void)setPlayerVolume:(float)playerVolume forChannelId:(NSString *)channelId {
    [self setFloat:playerVolume forKey:channelId];
    [self synchronize];
}

- (float)playerVolumeForChannelId:(NSString *)channelId{
    if (![self objectForKey:channelId]) {
        [self setPlayerVolume:kDefaultPlayerVolume forChannelId:channelId];
    }
    return [self floatForKey:channelId];
}

@end
