//
//  Created by Frank Gregor on 07/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNAuthViewController.h"
#import <Parse/PFConstants.h>
#import "NSImage+Podlive.h"

@interface CCNAuthViewController ()
@property (nonatomic, readonly) BOOL hasValidLoginData;
@end

@implementation CCNAuthViewController

- (void)loadView {
    self.view = CCNAuthView.new;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.wantsLayer = YES;
    self.view.frame = NSMakeRect(0, 0, 400.0, 370.0);
}

- (void)viewDidLoad {
    // set the view controller (self) as the next responder after the view
    [self.view setNextResponder:self];

    @weakify(self);
    [NSNotificationCenter.defaultCenter addObserverForName:NSTextDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        @strongify(self);
        self.contentView.actionButton.enabled = self.hasValidLoginData;
    }];

    [super viewDidLoad];
}

- (void)viewWillAppear {
    [super viewWillAppear];

    [NSAppearance setApplicationAppearanceName:NSAppearance.applicationAppearanceName forWindow:self.view.window];

    // navigation conroller config
    self.navigationController.configuration.transitionDuration = 0.25;

    @weakify(self);

    switch (self.contentView.authType) {
        case CCNAuthenticationTypeLogin: {
            self.contentView.headline.stringValue        = [NSString stringWithFormat:NSLocalizedString(@"%@ Login", @"Login Window Headline"), NSApplication.applicationName];
            self.contentView.headlineSubtext.stringValue = [NSString stringWithFormat:NSLocalizedString(@"If you already have a \"%@\" account just enter your username and password to synchronize your favourite podcasts to all your devices.", @"Login Window Headline Subtext"), [NSApplication applicationName]];
            self.contentView.switchButton.title          = NSLocalizedString(@"Signup →", @"Button Title");

            self.contentView.actionButton.actionHandler = ^(NSButton *actionButton) {
                [self performLogin:actionButton];
            };

            self.contentView.switchButton.actionHandler = ^(NSButton *actionButton) {
                @strongify(self);
                [self clearTextFields];
                let signupViewController = CCNAuthViewController.viewController;
                signupViewController.contentView.authType = CCNAuthenticationTypeSignup;

                self.navigationController.configuration.transition = CCNNavigationControllerTransitionToLeft;
                [self.navigationController pushViewController:signupViewController animated:YES];
            };

            self.contentView.forgetPasswordButton.actionHandler = ^(NSButton *actionButton) {
                @strongify(self);
                [self clearTextFields];
                let forgotPasswordViewController = CCNAuthViewController.viewController;
                forgotPasswordViewController.contentView.authType = CCNAuthenticationTypeForgotPassword;

                self.navigationController.configuration.transition = CCNNavigationControllerTransitionToRight;
                [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
            };
            break;
        }
        case CCNAuthenticationTypeSignup: {
            self.contentView.headline.stringValue        = [NSString stringWithFormat:NSLocalizedString(@"%@ Signup", @"Signup Window Headline"), NSApplication.applicationName];
            self.contentView.headlineSubtext.stringValue = [NSString stringWithFormat:NSLocalizedString(@"Signup to \"%@\" to synchronize your favourite podcasts to all your connected devices.", @"Signup Window Headline Subtext"), [NSApplication applicationName]];
            self.contentView.switchButton.title          = NSLocalizedString(@"← Login", @"Button Title");

            self.contentView.switchButton.actionHandler = ^(NSButton *actionButton) {
                @strongify(self);
                [self clearTextFields];
                [self.navigationController popViewControllerAnimated:YES];
            };

            self.contentView.actionButton.actionHandler = ^(NSButton *actionButton) {
                [self performSignup:actionButton];
            };
            break;
        }
        case CCNAuthenticationTypeForgotPassword: {
            self.contentView.headline.stringValue        = [NSString stringWithFormat:NSLocalizedString(@"%@ Password Reset", @"Password Reset Window Headline"), [NSApplication applicationName]];
            self.contentView.headlineSubtext.stringValue = NSLocalizedString(@"Please enter your email address in the textfield below. We will send you an email with a link to reset your password.", @"Password Reset Window Headline Subtext");
            self.contentView.switchButton.title          = NSLocalizedString(@"Login →", @"Button Title");

            self.contentView.switchButton.actionHandler = ^(NSButton *actionButton) {
                @strongify(self);
                [self clearTextFields];
                [self.navigationController popViewControllerAnimated:YES];
            };

            self.contentView.actionButton.actionHandler = ^(NSButton *actionButton) {
                @strongify(self);
                [self performResetPassword:actionButton];
            };
            break;
        }
    }

    self.contentView.actionButton.enabled = self.hasValidLoginData;
    self.contentView.cancelButton.actionHandler = ^(NSButton *actionButton) {
        @strongify(self);
        [self.navigationController dismissViewController:self.navigationController];
    };
}

- (void)viewDidAppear {
    [super viewDidAppear];

    [self.contentView.window makeFirstResponder:nil];
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.28 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        switch (self.contentView.authType) {
            case CCNAuthenticationTypeLogin:
            case CCNAuthenticationTypeSignup:
                [self.contentView.window makeFirstResponder:self.contentView.username];
                break;

            case CCNAuthenticationTypeForgotPassword:
                [self.contentView.window makeFirstResponder:self.contentView.email];
                break;
        }
    });
}

- (void)viewWillDisappear {
    [super viewWillDisappear];

    [self.contentView.username resignFirstResponder];
}

- (CCNAuthView *)contentView {
    return (CCNAuthView *)self.view;
}

// MARK: - Custom Accessors

- (void)setAuthType:(CCNAuthenticationType)authType {
    self.contentView.authType = authType;
}

- (CCNAuthenticationType)authType {
    return self.contentView.authType;
}

// MARK: - Actions

- (void)performLogin:(NSButton *)sender {
    sender.enabled = NO;
    [self.contentView.authProgress startAnimation:self];

    @weakify(self);
    [CCNUserManager.sharedManager loginInBackgroundWithUsername:self.contentView.username.stringValue
                                                       password:self.contentView.password.stringValue
                                                        success:^(PFUser *user) {
                                                            @strongify(self);
                                                            [self.navigationController dismissViewController:self.navigationController];
                                                        }
                                                        failure:^(NSError *error) {
                                                            @strongify(self);

                                                            let title = NSLocalizedString(@"Login Failed", @"Alert Title");
                                                            var message = @"";

                                                            if (error.code == kPFErrorObjectNotFound) {
                                                                message = NSLocalizedString(@"The username and password you entered don't match.", @"Alert Message");
                                                            } else {
                                                                message = NSLocalizedString(@"Something went wrong...", @"Alert Message");
                                                            }

                                                            [self presentAlertWithTitle:title
                                                                            messageText:message
                                                                        informativeText:NSLocalizedString(@"Please check your entries and try again.", @"Alert Sub-Message")
                                                                                  style:NSAlertStyleWarning];

                                                            sender.enabled = YES;
                                                            [self.contentView.authProgress stopAnimation:self];
                                                        }];
}

- (void)performSignup:(NSButton *)sender {
    sender.enabled = NO;
    let email = [self.contentView.email.stringValue stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];

    [self.contentView.authProgress startAnimation:self];

    @weakify(self);
    [CCNUserManager.sharedManager signupInBackgroundWithUsername:self.contentView.username.stringValue
                                                        password:self.contentView.password.stringValue
                                                           email:email
                                                         success:^(PFUser *user) {
                                                             @strongify(self);
                                                             [self.navigationController dismissViewController:self.navigationController];

                                                             let message = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", @"Alert Message"), user.username];
                                                             let informativeText = [NSString stringWithFormat:NSLocalizedString(@"You successfully registered to %@. In order to validate your registration we sent a confirmation message to your email address at:\n\n%@", @"Alert Message"), [NSApplication applicationName], user.email];

                                                             [self presentAlertWithTitle:nil messageText:message informativeText:informativeText style:NSAlertStyleInformational];
                                                         }
                                                         failure:^(NSError *error) {
                                                             @strongify(self);

                                                             let errorCode = [error code];
                                                             var message = @"";
                                                             NSResponder *responder = nil;

                                                             switch (errorCode) {
                                                                 case kPFErrorUsernameTaken: {
                                                                     let format = NSLocalizedString(@"The username '%@' is taken. Please try choosing a different username.", @"Alert Message");
                                                                     message = [NSString stringWithFormat:format, self.contentView.username.stringValue];
                                                                     responder = self.contentView.username;
                                                                     break;
                                                                 }
                                                                 case kPFErrorUserEmailTaken: {
                                                                     let format = NSLocalizedString(@"The email '%@' is taken. Please try using a different email.", @"Alert Message");
                                                                     message = [NSString stringWithFormat:format, email];
                                                                     responder = self.contentView.email;
                                                                     break;
                                                                 }
                                                             }

                                                             if ([message isNotEmptyString]) {
                                                                 [self presentAlertWithTitle:NSLocalizedString(@"Sign Up Error", @"Alert Title")
                                                                                 messageText:message
                                                                             informativeText:NSLocalizedString(@"Please check your entries and try again.", @"Alert Sub-Message")
                                                                                       style:NSAlertStyleWarning];
                                                                 [responder becomeFirstResponder];
                                                             }
                                                         }];
}

- (void)performResetPassword:(NSButton *)sender {
    sender.enabled = NO;
    let email = [self.contentView.email.stringValue stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    
    [self.contentView.authProgress startAnimation:self];

    @weakify(self);
    [CCNUserManager.sharedManager resetPasswordForEmail:email
                                                success:^{
                                                    @strongify(self);
                                                    [self.navigationController dismissViewController:self.navigationController];

                                                    let message = [NSString stringWithFormat:NSLocalizedString(@"Password Reset", @"Alert Message")];
                                                    let informativeText = [NSString stringWithFormat:NSLocalizedString(@"Please check your mailbox, we sent you an email to\n\n%@\n\n with a link to reset your password.", @"Alert Message"), email];

                                                    [self presentAlertWithTitle:nil messageText:message informativeText:informativeText style:NSAlertStyleInformational];
                                                }
                                                failure:^(NSError *error) {
                                                    @strongify(self);

                                                    let format = NSLocalizedString(@"Unfortunately we found no user with an email address\n\n%@\n\nPlease try again.", @"Alert Sub-Message");
                                                    let informativeText = [NSString stringWithFormat:format, email];
                                                    let responder = self.contentView.email;

                                                    [self presentAlertWithTitle:NSLocalizedString(@"Password Reset Error", @"Alert Title")
                                                                    messageText:NSLocalizedString(@"No email address found.", @"Alert Message")
                                                                informativeText:informativeText
                                                                          style:NSAlertStyleWarning];
                                                    [responder becomeFirstResponder];
                                                    
                                                    sender.enabled = YES;
                                                    [self.contentView.authProgress stopAnimation:self];
                                                }];
}

// MARK: - Helper

- (BOOL)hasValidLoginData {
    var hasValidLoginData = NO;
    switch (self.contentView.authType) {
        case CCNAuthenticationTypeLogin: {
            hasValidLoginData = (self.contentView.username.stringValue.length >= 2
                                 && self.contentView.password.stringValue.length >= 2);
            break;
        }
        case CCNAuthenticationTypeSignup: {
            hasValidLoginData = (self.contentView.username.stringValue.length >= 2
                                 && self.contentView.password.stringValue.length >= 2
                                 && [self.contentView.email.stringValue isValidEmailAddress]);
            break;
        }
        case CCNAuthenticationTypeForgotPassword: {
            hasValidLoginData = [self.contentView.email.stringValue isValidEmailAddress];
            break;
        }
    }
    return hasValidLoginData;
}

- (void)clearTextFields {
    self.contentView.username.stringValue = @"";
    self.contentView.password.stringValue = @"";
    self.contentView.email.stringValue    = @"";
    self.contentView.actionButton.enabled = self.hasValidLoginData;
}

- (void)presentAlertWithTitle:(NSString *)alertTitle messageText:(NSString *)messageText informativeText:(NSString *)informativeText style:(NSAlertStyle)alertStyle {
    let alert = NSAlert.new;
    alert.messageText     = messageText;
    alert.informativeText = (informativeText ?: @"");
    alert.alertStyle      = alertStyle;
    switch (alertStyle) {
        case NSAlertStyleInformational:
            alert.icon = NSImage.alertSignInfo;
            break;

        case NSAlertStyleWarning:
        case NSAlertStyleCritical:
            alert.icon = NSImage.alertSignError;
            break;
    }

    [alert addButtonWithTitle:NSString.ok];
    [alert runModal];
}

@end
