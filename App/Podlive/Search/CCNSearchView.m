//
//  Created by Frank Gregor on 03.03.20.
//  Copyright © 2020 cocoa:naut. All rights reserved.
//

#import "CCNSearchView.h"

#import "NSView+Podlive.h"

@implementation CCNSearchView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.wantsLayer = YES;
    [self addVibrancyBlendingMode:NSVisualEffectBlendingModeWithinWindow];

    [self setupUI];
    [self setupConstraints];
    [self setupNotifications];

    return self;
}

- (void)setupUI {
}

- (void)setupNotifications {
    
}

- (void)setupConstraints {
    
}

@end
