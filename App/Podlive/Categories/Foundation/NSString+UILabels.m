//
//  Created by Frank Gregor on 11/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSString+UILabels.h"

@implementation NSString (UILabels)

+ (NSString *)ok {
    static dispatch_once_t onceToken;
    static NSString *_string = nil;
    dispatch_once(&onceToken, ^{
        _string = NSLocalizedString(@"OK", @"Button Label");
    });
    return _string;
}

+ (NSString *)cancel {
    static dispatch_once_t onceToken;
    static NSString *_string = nil;
    dispatch_once(&onceToken, ^{
        _string = NSLocalizedString(@"Cancel", @"Button Label");
    });
    return _string;
}

+ (NSString *)abort {
    static dispatch_once_t onceToken;
    static NSString *_string = nil;
    dispatch_once(&onceToken, ^{
        _string = NSLocalizedString(@"Abort", @"Button Label");
    });
    return _string;
}

+ (NSString *)next {
    static dispatch_once_t onceToken;
    static NSString *_string = nil;
    dispatch_once(&onceToken, ^{
        _string = NSLocalizedString(@"Next", @"Button Label");
    });
    return _string;
}

+ (NSString *)previous {
    static dispatch_once_t onceToken;
    static NSString *_string = nil;
    dispatch_once(&onceToken, ^{
        _string = NSLocalizedString(@"Previous", @"Button Label");
    });
    return _string;
}

+ (NSString *)remove {
    static dispatch_once_t onceToken;
    static NSString *_string = nil;
    dispatch_once(&onceToken, ^{
        _string = NSLocalizedString(@"Delete", @"Button Label");
    });
    return _string;
}

+ (NSString *)save {
    static dispatch_once_t onceToken;
    static NSString *_string = nil;
    dispatch_once(&onceToken, ^{
        _string = NSLocalizedString(@"Save", @"Button Label");
    });
    return _string;
}

@end
