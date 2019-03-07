//
//  Created by Frank Gregor on 07/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNApplicationDelegate.h"
#import "CCNApplicationViewController.h"
#import "CCNNotificationCoordinator.h"

#import "NSApplication+MainMenu.h"
#import "NSViewController+Podlive.h"
#import "NSWindow+Podlive.h"

@interface CCNApplicationDelegate () <NSUserNotificationCenterDelegate>
@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, strong) CCNApplicationViewController *appViewController;
@end

// MARK: - AppDelegate

@implementation CCNApplicationDelegate

+ (void)load {
    @autoreleasepool {
        let defaults = NSUserDefaults.standardUserDefaults;
        var currentAppearance = NSAppearanceNameAqua;

        // now we check if system is set to "Dark menu bar and Dock"
        let dict = [defaults persistentDomainForName:NSGlobalDomain];
        id interfaceStyle = [dict objectForKey:@"AppleInterfaceStyle"];
        if ([interfaceStyle isKindOfClass:[NSString class]] && [interfaceStyle caseInsensitiveCompare:@"dark"] == NSOrderedSame) {
            currentAppearance = NSAppearanceNameVibrantDark;
        }

        let userDefaults = @{ CCNCurrentAppearance: currentAppearance };
        [defaults registerDefaults:userDefaults];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupParse];
    [self setupNotifications];

    [NSApp populateMainMenu];
    [self populateMainWindow];

    [CCNUserManager.sharedManager startListening];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [PFInstallation.currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [NSApp replyToApplicationShouldTerminate:YES];
            }];
        }
        else {
            [NSApp replyToApplicationShouldTerminate:YES];
        }
    }];
    return NSTerminateLater;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    let isAnonynousUser = [PFAnonymousUtils isLinkedWithUser:PFUser.currentUser];
    if (isAnonynousUser) {
        // if the user isn't logged in (anonymous) we have to keep the
        // last selected filter criteria in user defaults set to CCNGridViewFilterCriteriaAvailable
        CCNChannelManager.sharedManager.channelFilterCriteria = CCNChannelFilterCriteriaAvailable;
    }
}

- (void)application:(NSApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    let currentInstallation = PFInstallation.currentInstallation;
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            CCNLog(@"successfully registered for push notifications with token: %@", deviceToken);
        }
        else {
            CCNLog(@"registration for push notifications failed: %@", error);
        }
        [CCNUserManager.sharedManager saveAnonymousUser];

        [PFPush subscribeToChannelInBackground:@"realtimeNotifications"];
    }];
}

- (void)application:(NSApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    CCNLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
    [CCNUserManager.sharedManager saveAnonymousUser];
}

- (void)application:(NSApplication *)application didReceiveRemoteNotification:(NSDictionary<NSString *, id> *)userInfo {
    let notificationCoordinator = [CCNNotificationCoordinator coordinatorWithRemoteNotification:userInfo];
    [notificationCoordinator handleRemoteNotification];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (!flag){
        [[self window] makeKeyAndOrderFront:self];
    }

    [NSApp activateIgnoringOtherApps:YES];
    [self populateMainWindow];

    let player = CCNPlayer.sharedInstance;
    if (player.status == CCNPlayerStatusPlaying) {

    }

    return YES;
}

// MARK: - Setup

- (void)setupParse {
    let parseConfiguration = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = CCNConstants.parseApplicationId;
        configuration.clientKey     = CCNConstants.parseClientKey;
        configuration.server        = CCNConstants.parseServerUrl;
        CCNLog(@"using parse server: %@", configuration.server);
    }];
    [Parse initializeWithConfiguration:parseConfiguration];

    if (!PFUser.currentUser) {
        [PFUser enableAutomaticUser];
    }

    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        [PFUser.currentUser fetchInBackground];
        CCNLog(@"installation: %@", PFInstallation.currentInstallation);
    };
}

- (void)setupNotifications {
    NSUserNotificationCenter.defaultUserNotificationCenter.delegate = self;
    [NSApp registerForRemoteNotificationTypes:(NSRemoteNotificationTypeAlert | NSRemoteNotificationTypeSound)];
}

// MARK: - Custom Accessors

- (CCNPlayerViewController *)playerViewController {
    return [self.appViewController valueForKeyPath:@"playerViewController"];
}

// MARK: - IBOutlets

- (void)populatePreferencesWindow:(id)sender {
    [self.appViewController showPreferences];
}

- (void)populateMainWindow {
    if (self.window) {
        if (self.window.isVisible) {
            return;
        }

        if (!self.window.isKeyWindow) {
            [self.window makeKeyAndOrderFront:self];
            return;
        }
    }

    if (!self.appViewController) {
        self.appViewController = CCNApplicationViewController.viewController;
    }
    
    self.window = [NSWindow mainWindowWithContentViewController:self.appViewController];

    @weakify(self);
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.42;
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        @strongify(self);
        self.window.animator.alphaValue = 1.0;

    } completionHandler:nil];
}

// MARK: - NSUserNotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification {
    CCNLog(@"didDeliverNotification: %@", notification);
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    CCNLog(@"didActivateNotification: %@", notification);
}

@end
