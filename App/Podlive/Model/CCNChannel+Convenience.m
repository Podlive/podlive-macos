//
//  Created by Frank Gregor on 21/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNChannel+Convenience.h"

@implementation CCNChannel (Convenience)

+ (NSArray *)channelStates {
    static NSArray *_channelStates = nil;
    if (!_channelStates) {
        _channelStates = @[ @"preshow", @"live", @"postshow", @"offline", @"online", @"break", @"invalid", @"test" ];
    }
    return _channelStates;
}

+ (CCNChannelState)channelStateForStateString:(NSString *_Nonnull)stateString {
    var _state = CCNChannelStateUndefined;
    for (NSInteger idx = 0; idx < self.channelStates.count; idx++) {
        if ([self.channelStates[idx] isEqualToString:stateString]) {
            _state = idx;
            break;
        }
    }
    return _state;
}

+ (NSString *_Nonnull)stateStringForChannelState:(CCNChannelState)state {
    return self.channelStates[state];
}

+ (NSString *_Nonnull)humanReadableStateStringForChannelState:(CCNChannelState)state {
    let stateString = [self stateStringForChannelState:state];
    let firstCharacterUpperCase = [[stateString substringToIndex:1] uppercaseString];
    let result = [NSString stringWithFormat:@"%@%@", firstCharacterUpperCase, [stateString substringFromIndex:1]];

    return result;
}

+ (NSArray *)streamingBackends {
    static NSArray *_streamingBackends = nil;
    if (!_streamingBackends) {
        _streamingBackends = @[ @"xenim", @"studiolink" ];
    }
    return _streamingBackends;
}

+ (CCNStreamingBackend)streamingBackendForBackendString:(NSString *_Nonnull)backendString {
    var _backend = CCNStreamingBackendUndefined;
    for (NSInteger idx = 0; idx < self.streamingBackends.count; idx++) {
        if ([self.streamingBackends[idx] isEqualToString:backendString]) {
            _backend = idx;
            break;
        }
    }
    return _backend;
}

@end
