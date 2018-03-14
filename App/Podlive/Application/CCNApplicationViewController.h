//
//  Created by Frank Gregor on 30/04/16.
//  Copyright © 2016 cocoa:naut. All rights reserved.
//

@interface CCNApplicationViewController : NSViewController  <NSWindowDelegate, NSToolbarDelegate>

- (void)showPreferences;

- (void)showAvailablePodcasts;
- (void)showSubscribedPodcasts;

@end
