//
//  Created by Frank Gregor on 30/04/16.
//  Copyright © 2016 cocoa:naut. All rights reserved.
//

@class CCNSearchViewController;

@interface CCNApplicationViewController : NSViewController  <NSWindowDelegate>

- (void)showPreferences;
- (void)showAvailablePodcasts;
- (void)showSubscribedPodcasts;

@end
