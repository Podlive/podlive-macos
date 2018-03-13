//
//  Created by Frank Gregor on 30/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPreferencesSync.h"
#import "CCNPreferencesWindowControllerProtocol.h"

@interface CCNPreferencesSync () <CCNPreferencesWindowControllerProtocol>
@property (weak) IBOutlet NSTextField *loggedInUserLabel;
@property (weak) IBOutlet NSTextField *loggedInStatusDescription;
@property (weak) IBOutlet NSTextField *forgotPasswordLabel;
@property (weak) IBOutlet NSTextField *loggedInUsername;
@property (weak) IBOutlet NSButton *loginButton;
@property (weak) IBOutlet NSButton *signupButton;
@property (weak) IBOutlet NSButton *forgotPasswordButton;
@end

@implementation CCNPreferencesSync

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.preferencesId = CCNPreferencesIdSync;

    return self;
}

- (void)viewDidLoad {
    [self setupUI];

    [super viewDidLoad];
}

- (void)setupUI {
    let userManager = CCNUserManager.sharedManager;

    self.loggedInUserLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"%@ Username:", @""), NSApplication.applicationName];
    self.loggedInStatusDescription.stringValue = NSLocalizedString(@"PREF_LOGIN_STATUS_DESCRIPTION", @"");

    self.loginButton.title = NSLocalizedString(@"Log In...", @"Button Title");
    self.signupButton.title = NSLocalizedString(@"Signup...", @"Button Title");


    if (userManager.userIsAuthenticated) {
        self.loggedInUsername.stringValue = userManager.userEmail;
        self.forgotPasswordLabel.stringValue = NSLocalizedString(@"I forgot my password", nil);
    }
    else {
        self.loggedInUsername.stringValue = NSLocalizedString(@"Not Logged In", @"Username Label");
        self.forgotPasswordLabel.stringValue = NSLocalizedString(@"I have an account, but forgot my password", nil);
    }
}

// MARK: - Actions

- (IBAction)loginButtonAction:(NSButton *)sender {
}

- (IBAction)signupButtonAction:(NSButton *)sender {
}

- (IBAction)forgotPasswordButtonAction:(NSButton *)sender {
}

// MARK: - CCNPreferencesWindowControllerDelegate

- (NSString *)preferenceIdentifier  { return self.preferencesIdentifier; }
- (NSString *)preferenceTitle       { return NSLocalizedString( @"Sync", @"Preferences ViewController Title"); }

- (NSImage *)preferenceIcon {
    let image = [NSImage imageNamed:@"prefs-sync"];
    [image setTemplate:YES];
    return image;
}

@end
