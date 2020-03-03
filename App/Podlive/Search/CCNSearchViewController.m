//
//  Created by Frank Gregor on 03.03.20.
//  Copyright © 2020 cocoa:naut. All rights reserved.
//

#import "CCNSearchViewController.h"

#import "NSView+Podlive.h"

@interface CCNSearchViewController ()

@end

@implementation CCNSearchViewController

- (void)loadView {
    self.view = NSView.new;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addVibrancyBlendingMode:NSVisualEffectBlendingModeBehindWindow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)populateSearch {
    CCNLogInfo(@"** Show Search");
}

- (void)dismissSearch {
    CCNLogInfo(@"** Hide Search");
}

@end
