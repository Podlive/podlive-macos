//
//  Created by Frank Gregor on 04.12.17.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@import CCNAppKit;
#import "NSApplication+MainMenu.h"
#import "CCNApplicationDelegate.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation NSApplication (MainMenu)

- (void)populateMainMenu {
    let mainMenu = [[NSMenu alloc] initWithTitle:@"MainMenu"];

    // The titles of the menu items are for identification purposes only and shouldn't be localized.
    // The strings in the menu bar come from the submenu titles,
    // except for the application menu, whose title is ignored at runtime.

    var menuItem = [mainMenu addItemWithTitle:@"Application" action:nil keyEquivalent:@""];
    var submenu = [[NSMenu alloc] initWithTitle:@"Application"];
    [self _populateApplicationMenu:submenu];
    [mainMenu setSubmenu:submenu forItem:menuItem];

    menuItem = [mainMenu addItemWithTitle:@"File" action:nil keyEquivalent:@""];
    submenu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Podcasts", @"The File menu")];
    [self _populateFileMenu:submenu];
    [mainMenu setSubmenu:submenu forItem:menuItem];

    menuItem = [mainMenu addItemWithTitle:@"Edit" action:nil keyEquivalent:@""];
    submenu = [[NSMenu alloc] initWithTitle:NSLocalizedString( @"Edit", @"The Edit menu" )];
    [self _populateEditMenu:submenu];
    [mainMenu setSubmenu:submenu forItem:menuItem];

    menuItem = [mainMenu addItemWithTitle:@"View" action:nil keyEquivalent:@""];
    submenu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"View", @"The View menu")];
    [self _populateViewMenu:submenu];
    [mainMenu setSubmenu:submenu forItem:menuItem];

    menuItem = [mainMenu addItemWithTitle:@"Window" action:nil keyEquivalent:@""];
    submenu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Window", @"The Window menu")];
    [self _populateWindowMenu:submenu];
    [mainMenu setSubmenu:submenu forItem:menuItem];
    NSApp.windowsMenu = submenu;

//    let helpMenu = [[NSMenu alloc] initWithTitle:@"HelpMenu"];
//    menuItem = [helpMenu addItemWithTitle:@"Help" action:nil keyEquivalent:@""];
//    submenu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Help", @"The Help menu")];
//    [self _populateHelpMenu:submenu];
//    [helpMenu setSubmenu:submenu forItem:menuItem];
//    NSApp.helpMenu = submenu;

    NSApp.mainMenu = mainMenu;
}

- (void)_populateApplicationMenu:(NSMenu *)menu {
    let applicationName = NSApplication.applicationName;
    let appDelegate = (CCNApplicationDelegate *)NSApp.delegate;

    var menuTitle = [NSString stringWithFormat:NSLocalizedString(@"About %@", @"Main Menu Item Title"), applicationName];
    var menuItem = [menu addItemWithTitle:menuTitle action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];
    [menuItem setTarget:NSApp];

    [menu addItem:[NSMenuItem separatorItem]];

    menuItem = [menu addItemWithTitle:NSLocalizedString(@"Preferences", @"Main Menu Item Title") action:@selector(populatePreferencesWindow:) keyEquivalent:@","];
    menuItem.target = appDelegate;

    [menu addItem:[NSMenuItem separatorItem]];

    menuItem = [menu addItemWithTitle:NSLocalizedString(@"Services", @"Main Menu Item Title") action:nil keyEquivalent:@""];

    let servicesMenu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Services", @"Main Menu Item Title")];
    [menu setSubmenu:servicesMenu forItem:menuItem];
    [NSApp setServicesMenu:servicesMenu];

    [menu addItem:[NSMenuItem separatorItem]];

    menuTitle = [NSString stringWithFormat:NSLocalizedString(@"%@ Hide", @"Main Menu Item Title"), applicationName];
    menuItem = [menu addItemWithTitle:menuTitle action:@selector(hide:) keyEquivalent:@"h"];
    [menuItem setTarget:NSApp];

    menuItem = [menu addItemWithTitle:NSLocalizedString(@"Hide Others", @"Main Menu Item Title") action:@selector(hideOtherApplications:) keyEquivalent:@"h"];
    [menuItem setKeyEquivalentModifierMask:NSEventModifierFlagCommand | NSEventModifierFlagOption];
    [menuItem setTarget:NSApp];

    menuItem = [menu addItemWithTitle:NSLocalizedString(@"Show All", @"Main Menu Item Title") action:@selector(unhideAllApplications:) keyEquivalent:@""];
    [menuItem setTarget:NSApp];

    [menu addItem:[NSMenuItem separatorItem]];

    menuTitle = [NSString stringWithFormat:NSLocalizedString(@"Quit %@", @"Main Menu Item Title"), applicationName];
    menuItem = [menu addItemWithTitle:menuTitle action:@selector(terminate:) keyEquivalent:@"q"];
    [menuItem setTarget:NSApp];
}

- (void)_populateFileMenu:(NSMenu *)menu {
    let appDelegate = (CCNApplicationDelegate *)NSApp.delegate;

    var menuTitle = NSLocalizedString(@"Available Podcasts", @"Main Menu Item Title");
    var menuItem = [menu addItemWithTitle:menuTitle action:@selector(showAvailablePodcasts) keyEquivalent:@"1"];
    [menuItem setTarget:appDelegate.appViewController];

    [menu addItem:NSApp.subscribedPodcastsMenuItem];
    [menuItem setTarget:appDelegate.appViewController];

    [menu addItem:[NSMenuItem separatorItem]];

    [menu addItemWithTitle:NSLocalizedString(@"Close Window", @"Main Menu Item Title") action:@selector(performClose:) keyEquivalent:@"w"];
}

- (void)_populateEditMenu:(NSMenu *)menu {
    [menu addItemWithTitle:NSLocalizedString(@"Cut", @"Main Menu Item Title") action:@selector(cut:) keyEquivalent:@"x"];
    [menu addItemWithTitle:NSLocalizedString(@"Copy", @"Main Menu Item Title") action:@selector(copy:) keyEquivalent:@"c"];
    [menu addItemWithTitle:NSLocalizedString(@"Paste", @"Main Menu Item Title") action:@selector(paste:) keyEquivalent:@"v"];

    var menuItem = [menu addItemWithTitle:NSLocalizedString( @"Paste and Match Style", nil ) action:@selector( pasteAsPlainText: ) keyEquivalent:@"V"];
    [menuItem setKeyEquivalentModifierMask:NSEventModifierFlagCommand | NSEventModifierFlagOption];

    [menu addItemWithTitle:NSLocalizedString(@"Delete", @"Main Menu Item Title") action:@selector(delete:) keyEquivalent:[NSString stringWithFormat:@"%C", (unichar)NSBackspaceCharacter]];
    [menu addItemWithTitle:NSLocalizedString(@"Select All", @"Main Menu Item Title") action:@selector(selectAll:) keyEquivalent:@"a"];

    [menu addItem:[NSMenuItem separatorItem]];

    menuItem = [menu addItemWithTitle:NSLocalizedString(@"Find", @"Main Menu Item Title") action:nil keyEquivalent:@""];

    let findMenu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Find", @"Main Menu Item Title")];
    [self _populateFindMenu:findMenu];
    [menu setSubmenu:findMenu forItem:menuItem];
}

- (void)_populateViewMenu:(NSMenu *)menu {
    var menuItem = [menu addItemWithTitle:NSLocalizedString(@"Enter Full Screen", @"Main Menu Item Title") action:@selector(toggleFullScreen:) keyEquivalent:@"f"];
    [menuItem setKeyEquivalentModifierMask:NSEventModifierFlagCommand | NSEventModifierFlagControl];
}

- (void)_populateWindowMenu:(NSMenu *)menu {
    let appDelegate = (CCNApplicationDelegate *)NSApp.delegate;

    [menu addItemWithTitle:NSLocalizedString(@"Minimize", @"Main Menu Item Title") action:@selector(performMiniaturize:) keyEquivalent:@"m"];
    [menu addItemWithTitle:NSLocalizedString(@"Zoom", @"Main Menu Item Title") action:@selector(performZoom:) keyEquivalent:@""];

    [menu addItem:[NSMenuItem separatorItem]];

    var menuItem = [menu addItemWithTitle:NSLocalizedString(@"Podcast Overview", @"Main Menu Item Title") action:@selector(populateMainWindow) keyEquivalent:@"0"];
    [menuItem setKeyEquivalentModifierMask:NSEventModifierFlagCommand | NSEventModifierFlagShift];
    menuItem.target = appDelegate;

    [menu addItem:[NSMenuItem separatorItem]];

    [menu addItemWithTitle:NSLocalizedString(@"Bring All to Front", @"Main Menu Item Title") action:@selector(arrangeInFront:) keyEquivalent:@""];
}

- (void)_populateHelpMenu:(NSMenu *)menu {
    let menuTitle = [NSString stringWithFormat:@"%@ %@", NSApplication.applicationName, NSLocalizedString( @"Help", @"Help Menu Item Title" )];
    var menuItem = [menu addItemWithTitle:menuTitle action:@selector(showHelp:) keyEquivalent:@"?"];
    menuItem.target = NSApp;
}

- (void)_populateFindMenu:(NSMenu *)menu {
    var menuItem = [menu addItemWithTitle:NSLocalizedString(@"Find…", @"Main Menu Item Title") action:@selector(performFindPanelAction:) keyEquivalent:@"f"];
    [menuItem setTag:NSFindPanelActionShowFindPanel];

    menuItem = [menu addItemWithTitle:NSLocalizedString(@"Find Next", @"Main Menu Item Title") action:@selector(performFindPanelAction:) keyEquivalent:@"g"];
    [menuItem setTag:NSFindPanelActionNext];

    menuItem = [menu addItemWithTitle:NSLocalizedString(@"Find Previous", @"Main Menu Item Title") action:@selector(performFindPanelAction:) keyEquivalent:@"G"];
    [menuItem setTag:NSFindPanelActionPrevious];

    menuItem = [menu addItemWithTitle:NSLocalizedString(@"Use Selection for Find", @"Main Menu Item Title") action:@selector(performFindPanelAction:) keyEquivalent:@"e"];
    [menuItem setTag:NSFindPanelActionSetFindString];

    [menu addItemWithTitle:NSLocalizedString(@"Jump to Selection", @"Main Menu Item Title") action:@selector(centerSelectionInVisibleArea:) keyEquivalent:@"j"];
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

@end

#pragma clang diagnostic pop
