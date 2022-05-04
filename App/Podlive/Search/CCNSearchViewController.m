//
//  Created by Frank Gregor on 03.03.20.
//  Copyright © 2020 cocoa:naut. All rights reserved.
//

#import "CCNSearchViewController.h"
#import "CCNSearchViewController_Private.h"
#import "CCNSearchView.h"

#import "NSView+Podlive.h"

const CGFloat kCCNSearchViewHeight = 56.0;

@interface CCNSearchViewController ()
@end

@implementation CCNSearchViewController

- (void)loadView {
    self.view = CCNSearchView.new;
    self.isVisible = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
