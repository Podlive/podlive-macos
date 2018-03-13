//
//  Created by Frank Gregor on 04/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPreferencesGeneral.h"
#import "CCNPreferencesWindowControllerProtocol.h"

@interface CCNPreferencesGeneral () <CCNPreferencesWindowControllerProtocol>
@property (weak) IBOutlet NSTextField *applicationAppearanceTextField;
@property (weak) IBOutlet NSPopUpButton *applicationAppearancePopup;
@end

@implementation CCNPreferencesGeneral

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.preferencesId = CCNPreferencesIdGeneral;

    return self;
}

- (void)viewDidLoad {
    [self setupUI];

    [super viewDidLoad];
}

- (void)setupUI {
    self.applicationAppearanceTextField.stringValue = NSLocalizedString(@"Set Application Theme to", @"Application Theme Selector Label");

    [self.applicationAppearancePopup removeAllItems];
    [self.applicationAppearancePopup addItemsWithTitles:@[
        NSLocalizedString(@"Aqua Theme", @"Application Theme"),
        NSLocalizedString(@"Dark Theme", @"Application Theme")
    ]];
    self.applicationAppearancePopup.target = self;
    self.applicationAppearancePopup.action = @selector(appearancePopupAction:);
    [self.applicationAppearancePopup selectItemAtIndex:NSAppearance.applicationAppearance];
}

// MARK: - Actions

- (IBAction)appearancePopupAction:(NSPopUpButton *)sender {
    [NSAppearance setApplicationAppearance:[sender indexOfSelectedItem]];

    for (NSWindow *aWindow in NSApp.windows) {
        [NSAppearance setApplicationAppearanceName:NSAppearance.applicationAppearanceName forWindow:aWindow];
    }
}

#pragma mark - CCNPreferencesWindowControllerDelegate

- (NSString *)preferenceIdentifier  { return self.preferencesIdentifier; }
- (NSString *)preferenceTitle       { return NSLocalizedString( @"General", @"Preferences ViewController Title"); }

- (NSImage *)preferenceIcon {
    let image = [NSImage imageNamed:@"prefs-general"];
    [image setTemplate:YES];
    return image;
}

@end
