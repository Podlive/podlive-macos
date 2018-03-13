//
//  Created by Frank Gregor on 11/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSString+Podlive.h"

@implementation NSString (Podlive)

+ (NSString *)listenerCountSingularFormatString {
    return NSLocalizedString(@"%li Listener", @"litenerCountSingularFormatString");
}

+ (NSString *)listenerCountPluralFormatString {
    return NSLocalizedString(@"%li Listeners", @"litenerCountPluralFormatString");
}

+ (NSString *)followerCountSingularFormatString {
    return NSLocalizedString(@"%li Follower", @"followerCountFormatString");
}

+ (NSString *)followerCountPluralFormatString {
    return NSLocalizedString(@"%li Followers", @"followerCountFormatString");
}

@end
