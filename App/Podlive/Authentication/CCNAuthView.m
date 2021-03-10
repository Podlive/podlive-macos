//
//  Created by Frank Gregor on 31/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNAuthView.h"
#import "NSImage+Podlive.h"
#import "NSButton+Tools.h"

@interface CCNAuthView ()
@property(nonatomic, strong) NSImageView *appIcon;
@property(nonatomic, strong) NSTextField *headline;
@property(nonatomic, strong) NSTextField *headlineSubtext;
@property(nonatomic, strong) NSTextField *username;
@property(nonatomic, strong) NSSecureTextField *password;
@property(nonatomic, strong) NSTextField *email;
@property(nonatomic, strong) NSButton *actionButton;
@property(nonatomic, strong) NSButton *switchButton;
@property(nonatomic, strong) NSButton *cancelButton;
@property(nonatomic, strong) NSButton *forgetPasswordButton;
@property(nonatomic, strong) NSProgressIndicator *authProgress;
@end

@implementation CCNAuthView

- (void)setupUI {
    let applicationIcon = NSImage.applicationIcon;
    applicationIcon.size = NSMakeSize(64.0, 64.0);
    let appIcon = [NSImageView imageViewWithImage:applicationIcon];
    appIcon.translatesAutoresizingMaskIntoConstraints = NO;
    appIcon.wantsLayer = YES;
    _appIcon = appIcon;
    [self addSubview:_appIcon];


    let headline = [self defaultTextFieldAsLabel:YES secure:NO];
    headline.font = [NSFont boldSystemFontOfSize:18.0];
    headline.alignment = NSTextAlignmentCenter;
    _headline = headline;
    [self addSubview:_headline];
    [_headline sizeToFit];


    let headlineSubtext = [self defaultTextFieldAsLabel:YES secure:NO];
    headlineSubtext.textColor = NSColor.disabledControlTextColor;
    headlineSubtext.font = [NSFont systemFontOfSize:NSFont.systemFontSize];
    headlineSubtext.usesSingleLineMode = NO;
    headlineSubtext.alignment = NSTextAlignmentCenter;
    _headlineSubtext = headlineSubtext;
    [self addSubview:_headlineSubtext];
    [_headlineSubtext sizeToFit];


    if (self.authType == CCNAuthenticationTypeLogin || self.authType == CCNAuthenticationTypeSignup) {
        let username = [self defaultTextFieldAsLabel:NO secure:NO];
        username.placeholderString = NSLocalizedString(@"Your Username", @"Username Textfield Placeholder String");
        _username = username;
        [self addSubview:_username];

        let password = [self defaultTextFieldAsLabel:NO secure:YES];
        password.placeholderString = NSLocalizedString(@"Your Password", @"Password Textfield Placeholder String");
        _password = password;
        [self addSubview:_password];
    }

    if (self.authType == CCNAuthenticationTypeLogin) {
        let forgetPasswordButton = [self defaultButtonWithTitle:NSLocalizedString(@"← Forgot Password", @"Button Title")];
        _forgetPasswordButton = forgetPasswordButton;
        [self addSubview:_forgetPasswordButton];
    }

    if (self.authType == CCNAuthenticationTypeSignup || self.authType == CCNAuthenticationTypeForgotPassword) {
        let email = [self defaultTextFieldAsLabel:NO secure:NO];
        email.placeholderString = NSLocalizedString(@"Your Email Address", @"Email Textfield Placeholder String");
        _email = email;
        [self addSubview:_email];
    }


    var actionButtonTitle = @"";
    switch (self.authType) {
        case CCNAuthenticationTypeLogin:
            actionButtonTitle = NSLocalizedString(@"Login", @"Button Title");
            break;
        case CCNAuthenticationTypeSignup:
            actionButtonTitle = NSLocalizedString(@"Signup", @"Button Title");
            break;
        case CCNAuthenticationTypeForgotPassword:
            actionButtonTitle = NSLocalizedString(@"Reset", @"Button Title");
            break;
    }

    let actionButton = [self defaultButtonWithTitle:actionButtonTitle];
    actionButton.keyEquivalent = @"\r";
    _actionButton = actionButton;
    [self addSubview:_actionButton];


    let switchButton = [self defaultButtonWithTitle:@""];
    _switchButton = switchButton;
    [self addSubview:_switchButton];


    let cancelButton = [self defaultButtonWithTitle:NSLocalizedString(@"Cancel", @"Button Label")];
    cancelButton.keyEquivalent = @"\E";
    _cancelButton = cancelButton;
    [self addSubview:_cancelButton];


    let authProgress = NSProgressIndicator.new;
    authProgress.translatesAutoresizingMaskIntoConstraints = NO;
    authProgress.wantsLayer = YES;
    authProgress.indeterminate = YES;
    authProgress.style = NSProgressIndicatorStyleSpinning;
    authProgress.displayedWhenStopped = NO;
    authProgress.frame = NSMakeRect(0, 0, 16, 16);
    authProgress.controlSize = NSControlSizeSmall;
    _authProgress = authProgress;
    [self addSubview:_authProgress];


    // responder chain
    _username.nextKeyView     = _password;
    _password.nextKeyView     = _email;
    _email.nextKeyView        = _cancelButton;
    _cancelButton.nextKeyView = _actionButton;
    _actionButton.nextKeyView = _username;
}

- (void)setupConstraints {
    var constraints = NSMutableArray.new;

    [constraints addObjectsFromArray:@[
        [self.appIcon.topAnchor constraintEqualToAnchor:self.appIcon.superview.topAnchor constant:kOuterEdgeMargin],
        [self.appIcon.centerXAnchor constraintEqualToAnchor:self.appIcon.superview.centerXAnchor],
        [self.appIcon.widthAnchor constraintEqualToConstant:self.appIcon.image.size.width],
        [self.appIcon.heightAnchor constraintEqualToAnchor:self.appIcon.widthAnchor],

        [self.headline.topAnchor constraintEqualToAnchor:self.appIcon.bottomAnchor constant:kInnerEdgeMargin],
        [self.headline.centerXAnchor constraintEqualToAnchor:self.headline.superview.centerXAnchor],

        [self.headlineSubtext.topAnchor constraintEqualToAnchor:self.headline.bottomAnchor constant:kInnerEdgeDoubleMargin],
        [self.headlineSubtext.centerXAnchor constraintEqualToAnchor:self.headlineSubtext.superview.centerXAnchor],
        [self.headlineSubtext.widthAnchor constraintEqualToConstant:NSWidth(self.frame) - kOuterEdgeMargin * 2],

        [self.actionButton.rightAnchor constraintEqualToAnchor:self.actionButton.superview.rightAnchor constant:-kOuterEdgeMargin],
        [self.cancelButton.leftAnchor constraintEqualToAnchor:self.cancelButton.superview.leftAnchor constant:kOuterEdgeMargin],
        [self.actionButton.centerYAnchor constraintEqualToAnchor:self.cancelButton.centerYAnchor],

        [self.authProgress.centerXAnchor constraintEqualToAnchor:self.actionButton.superview.centerXAnchor],
        [self.authProgress.centerYAnchor constraintEqualToAnchor:self.actionButton.centerYAnchor],
        [self.authProgress.widthAnchor constraintEqualToConstant:NSWidth(self.authProgress.frame)],
        [self.authProgress.heightAnchor constraintEqualToAnchor:self.authProgress.widthAnchor],
    ]];

    // TextField Setup
    if (self.authType == CCNAuthenticationTypeLogin || self.authType == CCNAuthenticationTypeSignup) {
        [constraints addObjectsFromArray:@[
            [self.username.topAnchor constraintEqualToAnchor:self.headlineSubtext.bottomAnchor constant:kInnerEdgeDoubleMargin],
            [self.username.centerXAnchor constraintEqualToAnchor:self.username.superview.centerXAnchor],
            [self.username.widthAnchor constraintEqualToConstant:NSWidth(self.frame) - kOuterEdgeMargin * 2],

            [self.password.topAnchor constraintEqualToAnchor:self.username.bottomAnchor constant:kInnerEdgeMargin],
            [self.password.centerXAnchor constraintEqualToAnchor:self.password.superview.centerXAnchor],
            [self.password.widthAnchor constraintEqualToConstant:NSWidth(self.frame) - kOuterEdgeMargin * 2],
        ]];
    }

    switch (self.authType) {
        case CCNAuthenticationTypeLogin: {
            [constraints addObjectsFromArray:@[
                [self.actionButton.topAnchor constraintEqualToAnchor:self.password.bottomAnchor constant:kInnerEdgeMargin],

                [self.switchButton.rightAnchor constraintEqualToAnchor:self.switchButton.superview.rightAnchor constant:-kOuterEdgeMargin],
                [self.switchButton.bottomAnchor constraintEqualToAnchor:self.switchButton.superview.bottomAnchor constant:-kOuterEdgeMargin],
                [self.switchButton.centerYAnchor constraintEqualToAnchor:self.forgetPasswordButton.centerYAnchor],

                [self.forgetPasswordButton.leftAnchor constraintEqualToAnchor:self.forgetPasswordButton.superview.leftAnchor constant:kOuterEdgeMargin],
            ]];
            break;
        }
        case CCNAuthenticationTypeSignup: {
            [constraints addObjectsFromArray:@[
                [self.email.topAnchor constraintEqualToAnchor:self.password.bottomAnchor constant:kInnerEdgeMargin],
                [self.email.centerXAnchor constraintEqualToAnchor:self.email.superview.centerXAnchor],
                [self.email.widthAnchor constraintEqualToConstant:NSWidth(self.frame) - kOuterEdgeMargin * 2],

                [self.actionButton.topAnchor constraintEqualToAnchor:self.email.bottomAnchor constant:kInnerEdgeMargin],
                [self.switchButton.leftAnchor constraintEqualToAnchor:self.switchButton.superview.leftAnchor constant:kOuterEdgeMargin],
                [self.switchButton.bottomAnchor constraintEqualToAnchor:self.switchButton.superview.bottomAnchor constant:-kOuterEdgeMargin],
            ]];
            break;
        }
        case CCNAuthenticationTypeForgotPassword: {
            [constraints addObjectsFromArray:@[
                [self.email.topAnchor constraintEqualToAnchor:self.headlineSubtext.bottomAnchor constant:kInnerEdgeDoubleMargin * 2],
                [self.email.centerXAnchor constraintEqualToAnchor:self.email.superview.centerXAnchor],
                [self.email.widthAnchor constraintEqualToConstant:NSWidth(self.frame) - kOuterEdgeMargin * 2],

                [self.actionButton.topAnchor constraintEqualToAnchor:self.email.bottomAnchor constant:kInnerEdgeMargin],
                [self.switchButton.rightAnchor constraintEqualToAnchor:self.switchButton.superview.rightAnchor constant:-kOuterEdgeMargin],
                [self.switchButton.bottomAnchor constraintEqualToAnchor:self.switchButton.superview.bottomAnchor constant:-kOuterEdgeMargin],
            ]];
            break;
        }
    }
    [NSLayoutConstraint activateConstraints:constraints];
    constraints = nil;
}

// MARK: - Custom Accessors

- (void)setAuthType:(CCNAuthenticationType)authType {
    _authType = authType;
    [self setupUI];
    [self setupConstraints];
    [self setNeedsDisplay:YES];
//    [self setNeedsUpdateConstraints:YES];
}

// MARK: - Helper

- (__kindof NSTextField *)defaultTextFieldAsLabel:(BOOL)asLabel secure:(BOOL)secure {
    let _textField = (secure ? NSSecureTextField.new : NSTextField.new);
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.wantsLayer = YES;
    _textField.font = [NSFont systemFontOfSize:NSFont.systemFontSize];
    _textField.bezelStyle = NSTextFieldRoundedBezel;
    _textField.textColor = NSColor.controlTextColor;

    if (asLabel) {
        _textField.backgroundColor = NSColor.clearColor;
        _textField.bordered = NO;
        _textField.editable = NO;
        _textField.selectable = NO;
    }

    return _textField;
}

- (NSButton *)defaultButtonWithTitle:(NSString *)buttonTitle {
    let _button = [NSButton buttonWithTitle:buttonTitle actionHandler:nil];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
//    _button.bezelStyle = NSBezelStyleRegularSquare;
    _button.wantsLayer = YES;
    _button.controlSize = NSControlSizeRegular;
    _button.font = [NSFont systemFontOfSize:NSFont.systemFontSize];
    _button.state = NSControlStateValueOff;

    return _button;
}

@end
