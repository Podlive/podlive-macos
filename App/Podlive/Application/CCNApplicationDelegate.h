//
//  Created by Frank Gregor on 07/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@import Cocoa;
@import Foundation;

@class CCNApplicationViewController;
@class CCNPlayerViewController;

@interface CCNApplicationDelegate : NSObject <NSApplicationDelegate>
@property (nonatomic, readonly) CCNPlayerViewController *playerViewController;
@property (nonatomic, readonly) CCNApplicationViewController *appViewController;

// MARK: - IBOutlets

- (void)populatePreferencesWindow:(id)sender;
- (void)populateMainWindow;

@end
