//
//  Created by Frank Gregor on 31/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

typedef NS_ENUM(NSInteger, CCNAuthenticationType) {
    CCNAuthenticationTypeLogin,
    CCNAuthenticationTypeSignup,
    CCNAuthenticationTypeForgotPassword
};

@interface CCNAuthView : NSView

@property (nonatomic, assign) CCNAuthenticationType authType;
@property (nonatomic, readonly) NSTextField *headline;
@property (nonatomic, readonly) NSTextField *headlineSubtext;
@property (nonatomic, readonly) NSTextField *username;
@property (nonatomic, readonly) NSSecureTextField *password;
@property (nonatomic, readonly) NSTextField *email;
@property (nonatomic, readonly) NSButton *actionButton;
@property (nonatomic, readonly) NSButton *switchButton;
@property (nonatomic, readonly) NSButton *cancelButton;
@property (nonatomic, readonly) NSButton *forgetPasswordButton;
@property (nonatomic, readonly) NSProgressIndicator *authProgress;

@end
