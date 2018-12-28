//
//  Created by Frank Gregor on 23/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNUserInfoView.h"

#import "NSColor+Podlive.h"
#import "NSImage+Podlive.h"

static const CGFloat kAvatarImageEdgeLength = 128.0;
static const CGFloat kAvatarImageViewEdgeLength = 64.0;

@interface CCNUserInfoView ()
@property (nonatomic, strong) NSImageView *avatar;
@property (nonatomic, strong) NSTextField *usernameLabel;
@property (nonatomic, strong) NSTextField *usernameTextField;
@property (nonatomic, strong) NSTextField *emailLabel;
@property (nonatomic, strong) NSTextField *emailTextField;
@property (nonatomic, strong) NSButton *logoutButton;
@end

@implementation CCNUserInfoView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    [self setupUI];
    [self setupConstraints];

    return self;
}

- (void)setupUI {
    let avatarImage = [NSImage anonymousAvatarWithSize:NSMakeSize(kAvatarImageEdgeLength, kAvatarImageEdgeLength)];
    let avatar = [NSImageView imageViewWithImage:avatarImage];
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    avatar.wantsLayer = YES;
    avatar.imageFrameStyle = NSImageFrameNone;
    avatar.layer.cornerRadius = kAvatarImageViewEdgeLength/2;
    avatar.layer.masksToBounds = YES;
    avatar.layer.borderWidth = 2.0;
    avatar.layer.borderColor = NSColor.userLoggedOutStatusColor.CGColor;
    self.avatar = avatar;
    [self addSubview:self.avatar];

    let user = PFUser.currentUser;
    if (user.email) {
        @weakify(self);
        [CCNUserManager.sharedManager avatarImageForUser:user withPlaceholderImage:avatarImage completion:^(NSImage *fetchedImage) {
            @strongify(self);
            self.avatar.image = fetchedImage;
        }];
    }


    let usernameLabel = [self defaultTextField];
    usernameLabel.font = [NSFont systemFontOfSize:NSFont.systemFontSize];
    usernameLabel.textColor = NSColor.lightGrayColor;
    usernameLabel.stringValue = NSLocalizedString(@"Username", @"TextField Label");
    [usernameLabel sizeToFit];
    self. usernameLabel = usernameLabel;
    [self addSubview:self.usernameLabel];


    let usernameTextField = [self defaultTextField];
    usernameTextField.font = [NSFont boldSystemFontOfSize:NSFont.systemFontSize];
    usernameTextField.textColor = NSColor.textColor;
    usernameTextField.stringValue = user.username;
    [usernameTextField sizeToFit];
    self.usernameTextField = usernameTextField;
    [self addSubview:self.usernameTextField];


    let emailLabel = [self defaultTextField];
    emailLabel.font = [NSFont systemFontOfSize:NSFont.systemFontSize];
    emailLabel.textColor = [NSColor lightGrayColor];
    emailLabel.stringValue = NSLocalizedString(@"Email Address", @"TextField Label");
    [emailLabel sizeToFit];
    self.emailLabel = emailLabel;
    [self addSubview:self.emailLabel];


    let emailTextField = [self defaultTextField];
    emailTextField.font = [NSFont boldSystemFontOfSize:NSFont.systemFontSize];
    emailTextField.textColor = NSColor.textColor;
    emailTextField.stringValue = user.email;
    [emailTextField sizeToFit];
    self.emailTextField = emailTextField;
    [self addSubview:self.emailTextField];


    let logoutButton = [NSButton buttonWithTitle:NSLocalizedString(@"Logout", @"Button Title") target:self action:@selector(handleLogoutButtonAction:)];
    logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    logoutButton.wantsLayer = YES;
    [logoutButton sizeToFit];
    self.logoutButton = logoutButton;
    [self addSubview:self.logoutButton];
}

// MARK: - Actions

- (void)handleLogoutButtonAction:(NSButton *)sender {
    [self.delegate userInfoViewControllerWantsLogoutAction];
}

// MARK: - Auto Layout

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.avatar.topAnchor constraintEqualToAnchor:self.avatar.superview.topAnchor constant:kOuterEdgeMargin],
        [self.avatar.centerXAnchor constraintEqualToAnchor:self.avatar.superview.centerXAnchor],
        [self.avatar.widthAnchor constraintEqualToConstant:kAvatarImageViewEdgeLength],
        [self.avatar.heightAnchor constraintEqualToAnchor:self.avatar.widthAnchor],

        [self.usernameLabel.topAnchor constraintEqualToAnchor:self.avatar.bottomAnchor constant:kOuterEdgeMargin],
        [self.usernameLabel.centerXAnchor constraintEqualToAnchor:self.usernameLabel.superview.centerXAnchor],
        [self.usernameLabel.heightAnchor constraintEqualToConstant:self.usernameLabel.font.boundingRectForFont.size.height],

        [self.usernameTextField.topAnchor constraintEqualToAnchor:self.usernameLabel.bottomAnchor],
        [self.usernameTextField.centerXAnchor constraintEqualToAnchor:self.usernameTextField.superview.centerXAnchor],
        [self.usernameTextField.heightAnchor constraintEqualToConstant:self.usernameTextField.font.boundingRectForFont.size.height],

        [self.emailLabel.topAnchor constraintEqualToAnchor:self.usernameTextField.bottomAnchor constant:kOuterEdgeMargin/2],
        [self.emailLabel.centerXAnchor constraintEqualToAnchor:self.emailLabel.superview.centerXAnchor],
        [self.emailLabel.heightAnchor constraintEqualToConstant:self.emailLabel.font.boundingRectForFont.size.height],

        [self.emailTextField.topAnchor constraintEqualToAnchor:self.emailLabel.bottomAnchor],
        [self.emailTextField.centerXAnchor constraintEqualToAnchor:self.emailTextField.superview.centerXAnchor],
        [self.emailTextField.heightAnchor constraintEqualToConstant:self.emailTextField.font.boundingRectForFont.size.height],

        [self.logoutButton.centerXAnchor constraintEqualToAnchor:self.logoutButton.superview.centerXAnchor],
        [self.logoutButton.bottomAnchor constraintEqualToAnchor:self.logoutButton.superview.bottomAnchor constant:-kOuterEdgeMargin],
    ]];
}

// MARK: - Helper

- (NSTextField *)defaultTextField {
    let _textField = NSTextField.new;
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.font            = [NSFont systemFontOfSize:NSFont.systemFontSize];
    _textField.textColor       = NSColor.textColor;
    _textField.backgroundColor = NSColor.clearColor;
    _textField.wantsLayer      = YES;
    _textField.selectable      = NO;
    _textField.editable        = NO;
    _textField.bordered        = NO;

    return _textField;
}

@end
