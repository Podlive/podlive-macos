//
//  Created by Frank Gregor on 30/04/16.
//  Copyright © 2016 cocoa:naut. All rights reserved.
//

#import "CCNApplicationDelegate.h"
#import "CCNApplicationViewController.h"
#import "CCNChannelGridViewController.h"
#import "CCNPlayerViewController.h"
#import "CCNUserInfoViewController.h"
#import "CCNAuthViewController.h"
#import "CCNSearchViewController.h"
#import "CCNSearchViewController_Private.h"
#import "CCNLoginLogoutButton.h"

#import "CCNPreferencesWindowController.h"
#import "CCNPreferencesGeneral.h"
#import "CCNPreferencesAudio.h"
#import "CCNPreferencesSync.h"

#import "NSAppearance+Podlive.h"
#import "NSApplication+MainMenu.h"
#import "NSApplication+Tools.h"
#import "NSColor+Podlive.h"
#import "NSImage+Podlive.h"
#import "NSImage+Tools.h"
#import "NSString+UILabels.h"
#import "NSViewController+Podlive.h"
#import "NSWindow+Podlive.h"

#import "PFUser+Podlive.h"


typedef void(^CCNLoginLogoutButtonAction)(__kindof NSButton *actionButton);

@interface CCNApplicationViewController () <NSPopoverDelegate, NSToolbarDelegate, CCNUserInfoViewDelegate>
@property (nonatomic, strong) CCNPlayerViewController *playerViewController;
@property (nonatomic, strong) NSLayoutConstraint *playerViewBottomConstraint;
@property (nonatomic, strong) CCNChannelGridViewController *gridViewController;

@property (nonatomic, readonly) NSArray<NSString *> *defaultToolbarItemIdentifiers;
@property (nonatomic, readonly) NSArray<NSString *> *selectableToolbarItemIdentifiers;
@property (nonatomic, readonly) CCNPreferencesWindowController *preferences;

@property (nonatomic, readonly) CCNLoginLogoutButton *authenticateButton;
@property (nonatomic, readonly) CCNLoginLogoutButtonAction authenticateButtonLoggedOutStateAction;
@property (nonatomic, readonly) CCNLoginLogoutButtonAction authenticateButtonLoggedInStateAction;
@property (nonatomic, readonly) NSSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSPopover *userInfoPopover;
@property (nonatomic, strong) CCNUserInfoViewController *userInfoViewController;

@property (nonatomic, strong) CCNSearchViewController *searchViewController;
@property (nonatomic, strong) NSLayoutConstraint *searchViewTopConstraint;
@end

@implementation CCNApplicationViewController

- (void)loadView {
    self.view = NSView.new;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.wantsLayer = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self setupConstraints];
    [self setupNotifications];
}

- (void)viewWillAppear {
    [super viewWillAppear];

    let currentUserHasSubscribedChannels = PFUser.currentUser.hasSubscribedChannels;
    [self.segmentedControl setEnabled:currentUserHasSubscribedChannels forSegment:CCNChannelFilterCriteriaSubscribed];
}

// MARK: - Setup

- (void)setupUI {
    self.gridViewController = CCNChannelGridViewController.viewController;
    [self.view addSubview:self.gridViewController.view];

    self.playerViewController = CCNPlayerViewController.viewController;
    [self addChildViewController:self.playerViewController];
    [self.view addSubview:self.playerViewController.view];
    
    self.searchViewController = CCNSearchViewController.viewController;
    [self addChildViewController:self.searchViewController];
    [self.view addSubview:self.searchViewController.view];
}

- (void)setupNotifications {
    let nc = NSNotificationCenter.defaultCenter;
    [nc addObserver:self selector:@selector(handleLogInSignupNotification:)                 name:CCNSignUpSuccessNotification               object:nil];
    [nc addObserver:self selector:@selector(handleLogInSignupNotification:)                 name:CCNLogInSuccessNotification                object:nil];
    [nc addObserver:self selector:@selector(handleLogInFailureNotification:)                name:CCNLogInFailureNotification                object:nil];
    [nc addObserver:self selector:@selector(handleLogOutNotification:)                      name:CCNLogOutNotification                      object:nil];
    [nc addObserver:self selector:@selector(handleChannelSubscriptionUpdatedNotification:)  name:CCNChannelSubscriptionUpdatedNotification  object:nil];
    [nc addObserver:self selector:@selector(handlePlayerDidStartPlayingNotification:)       name:CCNPlayerDidStartPlayingNotification       object:nil];
    [nc addObserver:self selector:@selector(handlePlayerDidStopPlayingNotification:)        name:CCNPlayerDidStopPlayingNotification        object:nil];
//    [nc addObserver:self selector:@selector(handleSearchViewShouldAppearNotification:)      name:CCNSearchViewShouldAppearNotification      object:nil];
    [nc addObserver:self selector:@selector(handleSearchViewShouldDisappearNotification:)   name:CCNSearchViewShouldDisappearNotification   object:nil];
}

// MARK: - Auto Layout

- (void)setupConstraints {
    if (!self.playerViewBottomConstraint) {
        self.playerViewBottomConstraint = [self.playerViewController.view.bottomAnchor constraintEqualToAnchor:self.playerViewController.view.superview.bottomAnchor];
        self.playerViewBottomConstraint.constant = kCCNPlayerViewHeight;
    }

    if (!self.searchViewTopConstraint) {
        self.searchViewTopConstraint = [self.searchViewController.view.topAnchor constraintEqualToAnchor:self.searchViewController.view.superview.topAnchor];
        self.searchViewTopConstraint.constant = -kCCNSearchViewHeight;
    }

    [NSLayoutConstraint activateConstraints:@[
        [self.gridViewController.view.topAnchor constraintEqualToAnchor:self.gridViewController.view.superview.topAnchor],
        [self.gridViewController.view.leftAnchor constraintEqualToAnchor:self.gridViewController.view.superview.leftAnchor],
        [self.gridViewController.view.rightAnchor constraintEqualToAnchor:self.gridViewController.view.superview.rightAnchor],
        [self.gridViewController.view.bottomAnchor constraintEqualToAnchor:self.gridViewController.view.superview.bottomAnchor],
        
        [self.playerViewController.view.leftAnchor constraintEqualToAnchor:self.playerViewController.view.superview.leftAnchor],
        [self.playerViewController.view.rightAnchor constraintEqualToAnchor:self.playerViewController.view.superview.rightAnchor],
        [self.playerViewController.view.heightAnchor constraintEqualToConstant:kCCNPlayerViewHeight],
        
        [self.searchViewController.view.leftAnchor constraintEqualToAnchor:self.searchViewController.view.superview.leftAnchor],
        [self.searchViewController.view.rightAnchor constraintEqualToAnchor:self.searchViewController.view.superview.rightAnchor],
        [self.searchViewController.view.heightAnchor constraintEqualToConstant:kCCNSearchViewHeight],

        self.playerViewBottomConstraint,
        self.searchViewTopConstraint
    ]];
}

// MARK: - Custom Accessors

- (NSSegmentedControl *)segmentedControl {
    static dispatch_once_t _onceToken;
    static var _segmentedControl = (NSSegmentedControl *)nil;

    @weakify(self);
    dispatch_once(&_onceToken, ^{
        @strongify(self);

        let _imageNames = @[
            @"segment-podcasts",
            @"segment-subscribed"
        ];

        var _images = NSMutableArray.new;
        for (NSInteger idx = 0; idx < _imageNames.count; idx++) {
            let _image = [NSImage imageNamed:_imageNames[idx]];
            [_image setTemplate:YES];
            [_images addObject:_image];
        }

        _segmentedControl = [NSSegmentedControl segmentedControlWithImages:_images
                                                              trackingMode:NSSegmentSwitchTrackingSelectOne
                                                                    target:self
                                                                    action:@selector(handleSegmentedControl:)];
        [_segmentedControl setSelected:YES
                            forSegment:CCNChannelManager.sharedManager.channelFilterCriteria];
    });

    return _segmentedControl;
}

- (NSArray<NSString *> *)defaultToolbarItemIdentifiers {
    static dispatch_once_t _onceToken;
    static NSArray<NSString *> *_segmentControlIdentifier = nil;
    
    dispatch_once(&_onceToken, ^{
        _segmentControlIdentifier = @[
            NSToolbarFlexibleSpaceItemIdentifier,
            kCCNChannelFilterSegmentControlIdentifier,
            NSToolbarFlexibleSpaceItemIdentifier,
            kCCNToolbarLoginButtonIdentifier,
        ];
    });
    
    return _segmentControlIdentifier;
}

- (NSArray<NSString *> *)selectableToolbarItemIdentifiers {
    static dispatch_once_t _onceToken;
    static NSArray<NSString *> *_segmentControlIdentifier = nil;
    
    dispatch_once(&_onceToken, ^{
        _segmentControlIdentifier = @[
            kCCNChannelFilterSegmentControlIdentifier,
            kCCNToolbarLoginButtonIdentifier,
        ];
    });
    
    return _segmentControlIdentifier;
}

- (CCNPreferencesWindowController *)preferences {
    static dispatch_once_t _onceToken;
    static CCNPreferencesWindowController *_preferences = nil;

    dispatch_once(&_onceToken, ^{
        _preferences = CCNPreferencesWindowController.new;
        _preferences.centerToolbarItems = YES;
        _preferences.showToolbarSeparator = YES;
        _preferences.allowsVibrancy = YES;

        [_preferences setPreferencesViewControllers:@[
            CCNPreferencesGeneral.new,
//            CCNPreferencesAudio.new,
//            CCNPreferencesSync.new
        ]];
    });
    [_preferences.window setAppearance:[NSAppearance appearanceNamed:NSAppearance.applicationAppearanceName]];

    return _preferences;
}

- (CCNLoginLogoutButton *)authenticateButton {
    static dispatch_once_t _onceToken;
    static CCNLoginLogoutButton *_button = nil;

    dispatch_once(&_onceToken, ^{
        let user = PFUser.currentUser;
        let avatarImage = [[NSImage anonymousAvatarWithSize:NSMakeSize(25.0, 25.0)] imageTintedWithColor:NSColor.userLoggedOutStatusColor];

        _button = [CCNLoginLogoutButton
                   buttonWithImage:avatarImage
                   actionHandler:(CCNUserManager.sharedManager.userIsAuthenticated ? self.authenticateButtonLoggedInStateAction : self.authenticateButtonLoggedOutStateAction)
        ];
        _button.frame = NSMakeRect(0, 0, avatarImage.size.width, avatarImage.size.height);

        if (user.email) {
            _button.loggedIn = user.isAuthenticated;
            [CCNUserManager.sharedManager avatarImageForUser:user withPlaceholderImage:avatarImage completion:^(NSImage *fetchedImage) {
                if (user.isAuthenticated) {
                    _button.image = fetchedImage;
                }
                else {
                    _button.image = [fetchedImage imageTintedWithColor:NSColor.userLoggedOutStatusColor];
                }
            }];
        }
    });
    return _button;
}

- (CCNLoginLogoutButtonAction)authenticateButtonLoggedOutStateAction {
    @weakify(self);
    return ^(NSButton *actionButton) {
        @strongify(self);
        [self showLoginSignupSheet];
    };
}

- (CCNLoginLogoutButtonAction)authenticateButtonLoggedInStateAction {
    @weakify(self);
    return ^(NSButton *actionButton) {
        @strongify(self);
        if (self.userInfoPopover) {
            [self closeUserInfoPopover];
        }
        else {
            [self showUserInfoPopover:actionButton];
        }
    };
}

// MARK: - Notifications

- (void)handleLogInSignupNotification:(NSNotification *)note {
    PFUser *user = note.object;
    self.authenticateButton.loggedIn = YES;
    self.authenticateButton.actionHandler = self.authenticateButtonLoggedInStateAction;

    [self.segmentedControl setSelected:YES forSegment:CCNChannelFilterCriteriaAvailable];
    [self.segmentedControl setEnabled:PFUser.currentUser.hasSubscribedChannels
                           forSegment:CCNChannelFilterCriteriaSubscribed];
    [self handleSegmentedControl:self.segmentedControl];

    @weakify(self);
    [CCNUserManager.sharedManager avatarImageForUser:user withPlaceholderImage:[NSImage anonymousAvatarWithSize:NSMakeSize(25.0, 25.0)] completion:^(NSImage *fetchedImage) {
        @strongify(self);
        self.authenticateButton.image = fetchedImage;
    }];
}

- (void)handleLogInFailureNotification:(NSNotification *)note {
    [self showLoginFailureAlert];
}

- (void)handleLogOutNotification:(NSNotification *)note {
    self.authenticateButton.loggedIn = NO;
    self.authenticateButton.actionHandler = self.authenticateButtonLoggedOutStateAction;
    self.authenticateButton.image = [[NSImage anonymousAvatarWithSize:NSMakeSize(25.0, 25.0)] imageTintedWithColor:NSColor.userLoggedOutStatusColor];
    self.authenticateButton.image.size = self.authenticateButton.frame.size;

    // reset gridViewController to show all available podcasts
    [self.segmentedControl setSelected:YES forSegment:CCNChannelFilterCriteriaAvailable];
    [self.segmentedControl setEnabled:PFUser.currentUser.hasSubscribedChannels
                           forSegment:CCNChannelFilterCriteriaSubscribed];
    [self handleSegmentedControl:self.segmentedControl];
}

- (void)handleChannelSubscriptionUpdatedNotification:(NSNotification *)note {
    let hasSubscribedChannels = PFUser.currentUser.hasSubscribedChannels;

    [self.segmentedControl setEnabled:hasSubscribedChannels forSegment:CCNChannelFilterCriteriaSubscribed];
    NSApp.subscribedPodcastsMenuItem.enabled = hasSubscribedChannels;
}

- (void)handlePlayerDidStartPlayingNotification:(NSNotification *)note {
    let newConstant = (self.playerViewBottomConstraint.constant > 0 ? 0 : kCCNPlayerViewHeight);
    var contentInsets = self.gridViewController.scrollView.contentInsets;
    contentInsets.bottom = kCCNPlayerViewHeight;

    @weakify(self);
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.25;
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        @strongify(self);
        self.playerViewBottomConstraint.animator.constant = newConstant;
        self.gridViewController.scrollView.animator.contentInsets = contentInsets;

    } completionHandler:nil];
}

- (void)handlePlayerDidStopPlayingNotification:(NSNotification *)note {
    var contentInsets = self.gridViewController.scrollView.contentInsets;
    contentInsets.bottom = 0;

    @weakify(self);
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.25;
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        @strongify(self);
        self.playerViewBottomConstraint.animator.constant = kCCNPlayerViewHeight;
        self.gridViewController.scrollView.animator.contentInsets = contentInsets;

    } completionHandler:nil];
}

- (void)handleSearchViewShouldAppearNotification:(NSNotification *)note {
    if (self.searchViewController.isVisible) {
        return;
    }
    self.searchViewController.isVisible = YES;

    let newConstant = (self.searchViewTopConstraint.constant > 0 ? -kCCNSearchViewHeight : 0);
    var contentInsets = self.gridViewController.scrollView.contentInsets;
    contentInsets.top = kCCNSearchViewHeight;
    
//    self.window = [NSWindow mainWindowWithContentViewController:self.appViewController];
    double titleBarHeight = self.view.window.titlebarHeight;
    NSLog(@"titleBarHeight: %f", titleBarHeight);

    @weakify(self);
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.25;
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        @strongify(self);
        self.searchViewTopConstraint.animator.constant = newConstant;
        self.gridViewController.scrollView.animator.contentInsets = contentInsets;

    } completionHandler:nil];
}

- (void)handleSearchViewShouldDisappearNotification:(NSNotification *)note {
    CCNLogInfo(@"** Hide Search");
}

// MARK: - Actions

- (void)handleSegmentedControl:(NSSegmentedControl *)control {
    let channelManager = CCNChannelManager.sharedManager;
    let filterCriteria = (CCNChannelFilterCriteria)control.selectedSegment;
    if (channelManager.channelFilterCriteria != filterCriteria) {
        channelManager.channelFilterCriteria = filterCriteria;
    }
}

- (void)showLoginSignupSheet {
    let loginViewController = CCNAuthViewController.viewController;
    loginViewController.authType = CCNAuthenticationTypeLogin;

    let navigationController = [[CCNNavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewControllerAsSheet:navigationController];
}

- (void)showUserInfoPopover:(NSButton *)sender {
    self.userInfoViewController = CCNUserInfoViewController.viewController;
    self.userInfoViewController.delegate = self;

    self.userInfoPopover = NSPopover.new;
    self.userInfoPopover.contentViewController = self.userInfoViewController;
    self.userInfoPopover.delegate = self;
    self.userInfoPopover.behavior = NSPopoverBehaviorSemitransient;
    [self.userInfoPopover showRelativeToRect:NSZeroRect ofView:sender preferredEdge:NSRectEdgeMaxY];
}

- (void)closeUserInfoPopover {
    [self.userInfoPopover close];
    self.userInfoPopover = nil;
}

- (void)showLoginFailureAlert {

}

// MARK: - NSToolbarDelegate

- (NSArray<NSString *> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return self.defaultToolbarItemIdentifiers;
}

- (NSArray<NSString *> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return self.defaultToolbarItemIdentifiers;
}

- (NSArray<NSString *> *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
    return self.selectableToolbarItemIdentifiers;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    let toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];

    if ([itemIdentifier isEqualToString:kCCNChannelFilterSegmentControlIdentifier]) {
        toolbarItem.view = self.segmentedControl;
    }
    else if ([itemIdentifier isEqualToString:kCCNToolbarLoginButtonIdentifier]) {
        toolbarItem.view = self.authenticateButton;
    }

    return toolbarItem;
}

// MARK: - NSPopoverDelegate

- (void)popoverDidClose:(NSNotification *)note {
    [self closeUserInfoPopover];
}

// MARK: - CCNUserInfoViewDelegate

- (void)userInfoViewControllerWantsLogoutAction {
    [CCNUserManager.sharedManager logOutInBackgroundWithCompletion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self closeUserInfoPopover];
        });
    }];
}

- (void)userInfoViewControllerWantsUserDeleteAction {
    NSInteger result = [self presentConfirmationWithTitle:NSLocalizedString(@"Delete Account", @"Alert Title")
                                              messageText:NSLocalizedString(@"Do you really want to delete your account?", @"Alert Message")
                                          informativeText:nil
                                        actionButtonTitle:NSString.remove];

    switch (result) {
        // Cancel
        case NSAlertFirstButtonReturn: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self closeUserInfoPopover];
            });
            break;
        }

        // Delete Account
        case NSAlertSecondButtonReturn: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CCNUserManager.sharedManager deleteAccountWithCompletion:^(Boolean deleteExecuted) {
                    [self closeUserInfoPopover];
                }];
            });
            break;
        }
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    if ([menuItem isEqual:NSApp.subscribedPodcastsMenuItem]) {
        return PFUser.currentUser.hasSubscribedChannels;
    }
    return YES;
}

// MARK: - Public API

- (void)showPreferences {
    [self.preferences showPreferencesWindow];
}

- (void)showAvailablePodcasts {
    if (CCNChannelManager.sharedManager.channelFilterCriteria == CCNChannelFilterCriteriaAvailable) {
        return;
    }
    self.segmentedControl.selectedSegment = CCNChannelFilterCriteriaAvailable;
    CCNChannelManager.sharedManager.channelFilterCriteria = self.segmentedControl.selectedSegment;
}

- (void)showSubscribedPodcasts {
    if (PFUser.currentUser.hasSubscribedChannels) {
        if (CCNChannelManager.sharedManager.channelFilterCriteria == CCNChannelFilterCriteriaSubscribed) {
            return;
        }
        self.segmentedControl.selectedSegment = CCNChannelFilterCriteriaSubscribed;
        CCNChannelManager.sharedManager.channelFilterCriteria = self.segmentedControl.selectedSegment;
    }
}

@end
