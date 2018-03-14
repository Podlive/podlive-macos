//
//  Created by Frank Gregor on 23/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNUserInfoViewController.h"

@implementation CCNUserInfoViewController

- (void)loadView {
    self.view = CCNUserInfoView.new;
}

- (NSSize)preferredContentSize {
    return NSMakeSize(280.0, 250.0);
}

- (void)setDelegate:(id<CCNUserInfoViewDelegate>)delegate {
    [(CCNUserInfoView *)self.view setDelegate:delegate];
}

- (void)dealloc {
    CCNLog(@"dealloc");
}

@end
