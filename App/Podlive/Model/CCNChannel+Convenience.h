//
//  Created by Frank Gregor on 21/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNChannel.h"

@interface CCNChannel (Convenience)

+ (CCNChannelState)channelStateForStateString:(NSString *_Nonnull)stateString;
+ (NSString *_Nonnull)stateStringForChannelState:(CCNChannelState)state;
+ (NSString *_Nonnull)humanReadableStateStringForChannelState:(CCNChannelState)state;
+ (CCNStreamingBackend)streamingBackendForBackendString:(NSString *_Nonnull)backendString;

@end
