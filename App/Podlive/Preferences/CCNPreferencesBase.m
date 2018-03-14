//
//  Created by Frank Gregor on 30/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPreferencesBase.h"

@interface CCNPreferencesBase ()
@end

@implementation CCNPreferencesBase

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    _preferencesId = CCNPreferencesIdUndefined;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

// MARK: - Custom Accessors

- (NSString *)preferencesIdentifier {
    switch (self.preferencesId) {
        case CCNPreferencesIdUndefined:     return nil; break;
        case CCNPreferencesIdGeneral:       return @"PreferencesGeneral"; break;
        case CCNPreferencesIdAudio:         return @"PreferencesAudio"; break;
        case CCNPreferencesIdSync:          return @"PreferencesSync"; break;
    }
}

@end
