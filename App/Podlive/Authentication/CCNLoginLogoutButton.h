//
//  Created by Frank Gregor on 11/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//
//  http://en.gravatar.com/site/implement/images/

#import "NSButton+Tools.h"

@interface CCNLoginLogoutButton : NSButton

+ (instancetype)buttonWithImage:(NSImage *)image actionHandler:(CCNButtonActionhandler)actionHandler;
+ (instancetype)buttonWithTitle:(NSString *)title image:(NSImage *)image actionHandler:(CCNButtonActionhandler)actionHandler NS_UNAVAILABLE;
+ (instancetype)buttonWithTitle:(NSString *)title actionHandler:(CCNButtonActionhandler)actionHandler NS_UNAVAILABLE;
+ (instancetype)checkboxWithTitle:(NSString *)title actionHandler:(CCNButtonActionhandler)actionHandler NS_UNAVAILABLE;
+ (instancetype)radioButtonWithTitle:(NSString *)title actionHandler:(CCNButtonActionhandler)actionHandler NS_UNAVAILABLE;

@property (nonatomic, assign, getter=isLoggedIn) BOOL loggedIn;

@end
