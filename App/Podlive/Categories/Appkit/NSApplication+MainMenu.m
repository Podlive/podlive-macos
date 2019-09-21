//
//  Created by Frank Gregor on 04.12.17.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSApplication+MainMenu.h"
#import "NSApplication+Tools.h"
#import "CCNApplicationDelegate.h"
#import "NSBundle+Localization.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation NSApplication (MainMenu)

- (void)populateMainMenu {
    let mainMenu = [[NSMenu alloc] initWithTitle:@"MainMenu"];
    mainMenu.autoenablesItems = YES;

    [mainMenu addItem:[self _applicationSubmenu]];
    [mainMenu addItem:[self _podcastsSubmenu]];
    [mainMenu addItem:[self _editSubmenu]];
    [mainMenu addItem:[self _viewSubmenu]];
    [mainMenu addItem:[self _windowSubmenu]];
    [mainMenu addItem:[self _helpSubmenu]];

    NSApp.mainMenu = mainMenu;
}

// MARK: - Custom Accessors

- (nonnull NSMenuItem *)subscribedPodcastsMenuItem {
    static dispatch_once_t onceToken;
    static NSMenuItem *_menuItem = nil;
    dispatch_once(&onceToken, ^{
        _menuItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Subscribed Podcasts", @"Main Menu Item Title")
                                               action:@selector(showSubscribedPodcasts)
                                        keyEquivalent:@"2"];
    });
    return _menuItem;
}

// MARK: - Build Submenus

- (NSMenuItem *)_applicationSubmenu {
    let applicationName = NSApplication.applicationName;
    let appDelegate = (CCNApplicationDelegate *)NSApp.delegate;

    let aboutMenuItem = [self _menuItemWithTitle:[NSString stringWithFormat:NSLocalizedString(@"About %@", @"Main Menu Item Title"), applicationName] action:@selector(orderFrontStandardAboutPanel:) target:NSApp];
    let prefsMenuItem = [self _menuItemWithTitle:NSLocalizedString(@"Preferences…", @"Main Menu Item Title") action:@selector(populatePreferencesWindow:) target:appDelegate];
    prefsMenuItem.keyEquivalent = @",";
    prefsMenuItem.keyEquivalentModifierMask = NSEventModifierFlagCommand;

    let servicesSubMenu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Services", @"Main Menu Item Title")];
    NSApp.servicesMenu = servicesSubMenu;
    let servicesMenuItem = NSMenuItem.new;
    servicesMenuItem.title = servicesSubMenu.title;
    servicesMenuItem.submenu = servicesSubMenu;

    let hideMenuItem = [self _menuItemWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@ Hide", @"Main Menu Item Title"), applicationName] action:@selector(hide:) target:NSApp];
    hideMenuItem.keyEquivalent = @"h";

    let hideOthersMenuItem = [self _menuItemWithTitle:NSLocalizedString(@"Hide Others", @"Main Menu Item Title") action:@selector(hideOtherApplications:) target:NSApp];
    hideOthersMenuItem.keyEquivalent = @"h";
    hideOthersMenuItem.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagOption;

    let showAllMenuItem = [self _menuItemWithTitle:NSLocalizedString(@"Show All", @"Main Menu Item Title") action:@selector(unhideAllApplications:) target:NSApp];
    let quitMenuItem = [self _menuItemWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Quit %@", @"Main Menu Item Title"), applicationName] action:@selector(terminate:) target:NSApp];
    quitMenuItem.keyEquivalent = @"q";

    // Build submenu
    let menu = NSMenu.new;
    [menu addItem:aboutMenuItem];
    [menu addItem:NSMenuItem.separatorItem];
    [menu addItem:prefsMenuItem];
    [menu addItem:NSMenuItem.separatorItem];
    [menu addItem:servicesMenuItem];
    [menu addItem:NSMenuItem.separatorItem];
    [menu addItem:hideMenuItem];
    [menu addItem:hideOthersMenuItem];
    [menu addItem:NSMenuItem.separatorItem];
    [menu addItem:showAllMenuItem];
    [menu addItem:NSMenuItem.separatorItem];
    [menu addItem:quitMenuItem];

    let menuItem = NSMenuItem.new;
    menuItem.submenu = menu;

    return menuItem;
}

- (NSMenuItem *)_podcastsSubmenu {
    let appDelegate = (CCNApplicationDelegate *)NSApp.delegate;

    let availablePodcastsMenuItem = [self _menuItemWithTitle:NSLocalizedString(@"Available Podcasts", @"Main Menu Item Title") action:@selector(showAvailablePodcasts) target:appDelegate.appViewController];
    availablePodcastsMenuItem.keyEquivalent = @"1";
    availablePodcastsMenuItem.keyEquivalentModifierMask = NSEventModifierFlagCommand;

    let subscribedPodcastsMenuItem = NSApp.subscribedPodcastsMenuItem;

    // Build submenu
    let menu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Podcasts", @"The File menu")];
    [menu addItem:availablePodcastsMenuItem];
    [menu addItem:subscribedPodcastsMenuItem];
    [menu addItem:NSMenuItem.separatorItem];

    let closeWindowMenuItem = [menu addItemWithTitle:NSLocalizedString(@"Close Window", @"Main Menu Item Title") action:@selector(performClose:) keyEquivalent:@"w"];
    closeWindowMenuItem.keyEquivalentModifierMask = NSEventModifierFlagCommand;

    let menuItem = NSMenuItem.new;
    menuItem.submenu = menu;

    return menuItem;
}

- (NSMenuItem *)_editSubmenu {
    // Build submenu
    let menu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Edit", @"The File menu")];
    [menu addItemWithTitle:NSLocalizedString(@"Cut", @"Main Menu Item Title") action:@selector(cut:) keyEquivalent:@"x"];
    [menu addItemWithTitle:NSLocalizedString(@"Copy", @"Main Menu Item Title") action:@selector(copy:) keyEquivalent:@"c"];
    [menu addItemWithTitle:NSLocalizedString(@"Paste", @"Main Menu Item Title") action:@selector(paste:) keyEquivalent:@"v"];

    var subMenuItem = [menu addItemWithTitle:NSLocalizedString( @"Paste and Match Style", nil ) action:@selector( pasteAsPlainText: ) keyEquivalent:@"V"];
    subMenuItem.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagOption;

    [menu addItemWithTitle:NSLocalizedString(@"Delete", @"Main Menu Item Title") action:@selector(delete:) keyEquivalent:[NSString stringWithFormat:@"%C", (unichar)NSBackspaceCharacter]];
    [menu addItemWithTitle:NSLocalizedString(@"Select All", @"Main Menu Item Title") action:@selector(selectAll:) keyEquivalent:@"a"];

    [menu addItem:NSMenuItem.separatorItem];

    // Find SubMenu
    let findSubMenuItem = [menu addItemWithTitle:NSLocalizedString(@"Find", @"Main Menu Item Title") action:nil keyEquivalent:@""];
    let findMenu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Find", @"Main Menu Item Title")];

    var findMenuItem = [findMenu addItemWithTitle:NSLocalizedString(@"Find", @"Main Menu Item Title") action:@selector(performFindPanelAction:) keyEquivalent:@"f"];
    findMenuItem.tag = NSFindPanelActionShowFindPanel;

    findMenuItem = [findMenu addItemWithTitle:NSLocalizedString(@"Find Next", @"Main Menu Item Title") action:@selector(performFindPanelAction:) keyEquivalent:@"g"];
    findMenuItem.tag = NSFindPanelActionNext;

    findMenuItem = [findMenu addItemWithTitle:NSLocalizedString(@"Find Previous", @"Main Menu Item Title") action:@selector(performFindPanelAction:) keyEquivalent:@"G"];
    findMenuItem.tag = NSFindPanelActionPrevious;

    findMenuItem = [findMenu addItemWithTitle:NSLocalizedString(@"Use Selection for Find", @"Main Menu Item Title") action:@selector(performFindPanelAction:) keyEquivalent:@"e"];
    findMenuItem.tag = NSFindPanelActionSetFindString;

    [findMenu addItemWithTitle:NSLocalizedString(@"Jump to Selection", @"Main Menu Item Title") action:@selector(centerSelectionInVisibleArea:) keyEquivalent:@"j"];
    [menu setSubmenu:findMenu forItem:findSubMenuItem];

    let menuItem = NSMenuItem.new;
    menuItem.submenu = menu;

    return menuItem;
}

- (NSMenuItem *)_viewSubmenu {
    // Build submenu
    let localizedMenuString = [NSBundle localizedMenuStringForKey:@"View"];
    let menu = [[NSMenu alloc] initWithTitle:localizedMenuString];

    let fullScreenMenuItem = [menu addItemWithTitle:NSLocalizedString(@"Enter Full Screen", @"Main Menu Item Title") action:@selector(toggleFullScreen:) keyEquivalent:@"f"];
    fullScreenMenuItem.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagControl;

    let menuItem = [[NSMenuItem alloc] initWithTitle:localizedMenuString action:NULL keyEquivalent:@""];
    menuItem.submenu = menu;

    return menuItem;
}

- (NSMenuItem *)_windowSubmenu {
    let appDelegate = (CCNApplicationDelegate *)NSApp.delegate;

    // Build submenu
    let localizedMenuString = NSLocalizedString(@"Window", @"Main Menu Item Title");
    let menu = [[NSMenu alloc] initWithTitle:localizedMenuString];

    [menu addItemWithTitle:NSLocalizedString(@"Minimize", @"Main Menu Item Title") action:@selector(performMiniaturize:) keyEquivalent:@"m"];
    [menu addItemWithTitle:NSLocalizedString(@"Zoom", @"Main Menu Item Title") action:@selector(performZoom:) keyEquivalent:@""];
    [menu addItem:NSMenuItem.separatorItem];

    var overviewMenuItem = [menu addItemWithTitle:NSLocalizedString(@"Podcast Overview", @"Main Menu Item Title") action:@selector(populateMainWindow) keyEquivalent:@"0"];
    overviewMenuItem.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagShift;
    overviewMenuItem.target = appDelegate;

    let menuItem = [[NSMenuItem alloc] initWithTitle:localizedMenuString action:NULL keyEquivalent:@""];
    menuItem.submenu = menu;
    NSApp.windowsMenu = menu;

    return menuItem;
}

- (NSMenuItem *)_helpSubmenu {
    // Build submenu
    let localizedMenuString = [NSBundle localizedMenuStringForKey:@"Help"];
    let menu = [[NSMenu alloc] initWithTitle:localizedMenuString];
    let applicationHelpMenuItem = [menu addItemWithTitle:[NSString stringWithFormat:@"%@ %@", NSApplication.applicationName, localizedMenuString]
                                                  action:@selector(showHelp:)
                                           keyEquivalent:@"?"];
    applicationHelpMenuItem.target = NSApp;
    
    let menuItem = [[NSMenuItem alloc] initWithTitle:localizedMenuString action:NULL keyEquivalent:@""];
    menuItem.submenu = menu;
    NSApp.helpMenu = menu;

    return menuItem;
}

// MARK: - Private Helper

- (NSMenuItem *)_menuItemWithTitle:(NSString *)title action:(SEL)action target:(id)target {
    let menuItem = NSMenuItem.new;
    menuItem.title = title;
    menuItem.action = action;
    menuItem.target = target;

    return menuItem;
}

@end

#pragma clang diagnostic pop
