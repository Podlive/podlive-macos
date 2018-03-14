//
//  Created by Frank Gregor on 04.12.17.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSApplication (MainMenu)

- (void)populateMainMenu;

@property (nonnull, nonatomic, readonly) NSMenuItem *subscribedPodcastsMenuItem;

@end
