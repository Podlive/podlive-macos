//
//  Created by Frank Gregor on 21/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNChannelManager.h"
#import "CCNChannel.h"
#import "CCNImageCache.h"

#import "PFUser+Podlive.h"
#import "NSUserDefaults+Podlive.h"


typedef void (^CCNChannelManagerFetchObjectsCompletion)(NSArray *_Nullable objects, NSError *_Nullable error);
NSString *const CCNDidChangeChannelFilterCriteriaNotification = @"CCNDidChangeChannelFilterCriteriaNotification";


@interface CCNChannelManager ()
@property (nonatomic, readonly) PFQuery *query;

@property (nullable, nonatomic, strong) NSArray<CCNChannel *> *liveChannels;
@property (nullable, nonatomic, strong) NSArray<CCNChannel *> *offlineChannels;
@end

@implementation CCNChannelManager

+ (instancetype)sharedManager {
    static dispatch_once_t _onceToken;
    static id _sharedInstance;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [[self alloc] initSingleton];
    });
    return _sharedInstance;
}

- (instancetype)initSingleton {
    self = [super init];
    if (!self) return nil;

    _channelFilterCriteria = NSUserDefaults.standardUserDefaults.channelFilterCriteria;

    return self;
}

- (instancetype)init {
    @throw [[self class] initException];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [[self class] initException];
}

// MARK: - Init Exception

+ (NSException *)initException {
    NSString *exceptionMessage = [NSString stringWithFormat:@"'%@' is a Singleton, and you must NOT init manually! Use +sharedInstance instead.", [self className]];
    return [NSException exceptionWithName:NSInternalInconsistencyException reason:exceptionMessage userInfo:nil];
}

// MARK: - API

- (void)updateWithCompletion:(CCNEmptyHandler)completion {
    [self _fetchChannelsWithCompletion:^(NSArray *objects, NSError *error) {
        completion();
    }];
}

- (NSDictionary<NSNumber *,NSArray<CCNChannel *> *> *_Nullable)channelsForCurrentFilterCriteria {
    NSDictionary<NSNumber *,NSArray<CCNChannel *> *> *_channels = nil;

    switch (self.channelFilterCriteria) {
        case CCNChannelFilterCriteriaAvailable: {
            _channels = @{
                @(CCNChannelSectionLive): self.liveChannels,
                @(CCNChannelSectionOffline): self.offlineChannels
            };
            break;
        }
        case CCNChannelFilterCriteriaSubscribed: {
            let _subscribedLiveChannels = NSMutableArray.new;
            [self.liveChannels enumerateObjectsUsingBlock:^(CCNChannel *theChannel, NSUInteger idx, BOOL *stop) {
                if ([PFUser.currentUser isSubscribedToChannel:theChannel]) {
                    [_subscribedLiveChannels addObject:theChannel];
                }
            }];

            let _subscribedOfflineChannels = NSMutableArray.new;
            [self.offlineChannels enumerateObjectsUsingBlock:^(CCNChannel *theChannel, NSUInteger idx, BOOL *stop) {
                if ([PFUser.currentUser isSubscribedToChannel:theChannel]) {
                    [_subscribedOfflineChannels addObject:theChannel];
                }
            }];

            _channels = @{
                @(CCNChannelSectionLive): _subscribedLiveChannels,
                @(CCNChannelSectionOffline): _subscribedOfflineChannels
            };
            break;
        }
    }

    return _channels;
}

- (CCNChannel *_Nullable)channelWithId:(NSString *_Nonnull)channelId {
    let _channels = self.channelsForCurrentFilterCriteria.allValues;
    let _flattenedChannels = NSMutableArray.new;

    for (NSUInteger idx = 0; idx < _channels.count; idx++) {
        [_flattenedChannels addObjectsFromArray:_channels[idx]];
    }

    for (CCNChannel *theChannel in _flattenedChannels) {
        if ([theChannel.channelId isEqualToString:channelId]) {
            return theChannel;
        }
    }

    return nil;
}

// MARK: - Custom Accessors

- (PFQuery *)query {
    static PFQuery *_query = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _query =[PFQuery queryWithClassName:@"Channel"];
        [_query whereKey:@"isEnabled" equalTo:@(YES)];
        [_query orderByDescending:@"followerCount"];
        [_query addAscendingOrder:@"name"];
        // hide channels with no activity in the last months
        NSDate *pastDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMonth value:-6 toDate:[NSDate date] options: 0];
        [_query whereKey:@"lastActivityAt" greaterThan:pastDate];
        _query.cachePolicy = kPFCachePolicyNetworkOnly;
        _query.limit = 1000;
    });
    return _query;
}

- (void)setChannelFilterCriteria:(CCNChannelFilterCriteria)channelFilterCriteria {
    _channelFilterCriteria = channelFilterCriteria;
    NSUserDefaults.standardUserDefaults.channelFilterCriteria = _channelFilterCriteria;
    [NSNotificationCenter.defaultCenter postNotificationName:CCNDidChangeChannelFilterCriteriaNotification object:nil];
}

// MARK: - Private Helper

- (void)_fetchChannelsWithCompletion:(CCNChannelManagerFetchObjectsCompletion)completion {
    let serialQueue = dispatch_queue_create("com.cocoanaut.serial-queue", DISPATCH_QUEUE_SERIAL);
    var liveChannels = NSMutableArray.new;
    var offlineChannels = NSMutableArray.new;

    @weakify(self);

    [self.query cancel];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_async(serialQueue, ^{
            @strongify(self);

            for (PFObject *theObject in objects) {
                let theChannel = [CCNChannel channelWithObject:theObject];
                [NSImage cacheImageInBackgroundWithURL:theChannel.coverartThumbnail200URL];

                if (theChannel.isOnline) {
                    [liveChannels addObject:theChannel];
                }
                else {
                    [offlineChannels addObject:theChannel];
                }
            }

            CCNLog(@"liveChannels: %@", liveChannels);
            CCNLog(@"offlineChannels: %@", offlineChannels);

            self.liveChannels    = [NSArray arrayWithArray:liveChannels];
            self.offlineChannels = [NSArray arrayWithArray:offlineChannels];
            
            if (completion) {
                completion(nil, nil);
            }
        });
    }];
}

@end
