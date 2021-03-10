//
//  Created by Frank Gregor on 21/05/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSWindow+Podlive.h"
#import "NSAppearance+Podlive.h"
#import "NSApplication+Tools.h"

@implementation NSWindow (Podlive)

+ (instancetype)mainWindowWithContentViewController:(__kindof NSViewController *)contentViewController {
    let windowMinFrame = NSMakeRect(0, 0, 692.0, 360.0);
    let windowInitialFrame = NSMakeRect(0, 0, 880.0, 700.0);

    let styleMask = (NSWindowStyleMaskTitled | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable);

    let _window = [[NSWindow alloc] initWithContentRect:windowInitialFrame styleMask:styleMask backing:NSBackingStoreBuffered defer:NO];
    _window.minSize               = windowMinFrame.size;
    _window.maxSize               = NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX);
    _window.contentViewController = contentViewController;
    _window.delegate              = contentViewController;
    _window.titleVisibility       = NSWindowTitleHidden;
    _window.tabbingMode           = NSWindowTabbingModeDisallowed;
    _window.showsToolbarButton    = NO;
    _window.releasedWhenClosed    = NO;
    _window.alphaValue            = 0.0;

    // handle automatic frame save
    NSString *windowFrameAutosaveName = [NSString stringWithFormat:@"%@ %@", NSApplication.applicationName , @"Application Window"];
    if ([_window.stringWithSavedFrame isEqualToString:windowFrameAutosaveName]) {
        [_window setFrameFromString:_window.stringWithSavedFrame];
    }
    else {
        [_window setFrame:windowInitialFrame display:YES];
        [_window center];
        [_window setFrameAutosaveName:windowFrameAutosaveName];
    }

    let toolbar = [[NSToolbar alloc] initWithIdentifier:@"mainToolBar"];
    toolbar.displayMode = NSToolbarDisplayModeIconOnly;
    toolbar.delegate = contentViewController;
    toolbar.allowsUserCustomization = NO;

    _window.toolbar = toolbar;
    _window.appearance = [NSAppearance appearanceNamed:NSAppearance.applicationAppearanceName];

    [_window makeKeyAndOrderFront:nil];

    return _window;
}

- (CGFloat)titlebarHeight {
    CGFloat contentHeight = [self contentRectForFrameRect: self.frame].size.height;
    return self.frame.size.height - contentHeight;
}

@end
