//
//  Created by Frank Gregor on 21/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSDictionary+Podlive.h"
#import "CCNChannel.h"

@implementation NSDictionary (Podlive)

- (NSIndexPath *)indexPathForChannelWithId:(NSString *)channelId {
    __block NSIndexPath *_indexPath = nil;

    [self enumerateKeysAndObjectsUsingBlock:^(NSNumber *sectionNumber, NSOrderedSet<CCNChannel *> *sectionChannels, BOOL *stop) {
        [sectionChannels enumerateObjectsUsingBlock:^(CCNChannel *theChannel, NSUInteger idx, BOOL *stop) {
            if ([theChannel.channelId isEqualToString:channelId]) {
                _indexPath = [NSIndexPath indexPathForItem:idx inSection:sectionNumber.integerValue];
                *stop = YES;
            }
        }];
    }];

    return _indexPath;
}

@end
