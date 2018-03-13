//
//  Created by Frank Gregor on 25.11.15.
//  Copyright © 2015 cocoa:naut. All rights reserved.
//

@interface NSUserDefaults (Podlive)

@property (nonatomic, assign, getter=isFirstStart) BOOL firstStart;
@property (nonatomic, assign) CCNChannelFilterCriteria channelFilterCriteria;

@property (nonatomic, assign) CCNPlayerVolumeLevelPersistenceBehaviour volumeLevelPersistenceBehaviour;
@property (nonatomic, assign) float playerVolume;
- (void)setPlayerVolume:(float)playerVolume forChannelId:(NSString *_Nonnull)channelId;
- (float)playerVolumeForChannelId:(NSString *_Nonnull)channelId;

@end

FOUNDATION_EXPORT NSString * _Nonnull const NSUserDefaultsChannelFilterCriteriaKeyPath;
FOUNDATION_EXPORT const float kDefaultPlayerVolume;
