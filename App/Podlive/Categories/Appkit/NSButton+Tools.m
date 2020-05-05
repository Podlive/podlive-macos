//
//  Created by Frank Gregor on 26/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <Availability.h>
#import <objc/runtime.h>
#import "NSButton+Tools.h"

@implementation NSButton (Tools)

+ (instancetype)buttonWithTitle:(NSString *)title image:(NSImage *)image actionHandler:(CCNButtonActionhandler)actionHandler {
    NSButton *theButton = [NSButton buttonWithTitle:title image:image target:(actionHandler ? self : nil) action:(actionHandler ? @selector(handleButtonAction:) : nil)];
    theButton.actionHandler = actionHandler;
    return theButton;
}

+ (instancetype)buttonWithTitle:(NSString *)title actionHandler:(CCNButtonActionhandler)actionHandler {
    NSButton *theButton = [NSButton buttonWithTitle:title target:(actionHandler ? self : nil) action:(actionHandler ? @selector(handleButtonAction:) : nil)];
    theButton.actionHandler = actionHandler;
    return theButton;
}

+ (instancetype)buttonWithImage:(NSImage *)image actionHandler:(CCNButtonActionhandler)actionHandler {
    NSButton *theButton = [NSButton buttonWithImage:image target:(actionHandler ? self : nil) action:(actionHandler ? @selector(handleButtonAction:) : nil)];
    theButton.actionHandler = actionHandler;
    return theButton;
}

+ (instancetype)checkboxWithTitle:(NSString *)title actionHandler:(CCNButtonActionhandler)actionHandler {
    NSButton *theButton = [NSButton checkboxWithTitle:title target:(actionHandler ? self : nil) action:(actionHandler ? @selector(handleButtonAction:) : nil)];
    theButton.actionHandler = actionHandler;
    return theButton;
}

+ (instancetype)radioButtonWithTitle:(NSString *)title actionHandler:(CCNButtonActionhandler)actionHandler{
    NSButton *theButton = [NSButton radioButtonWithTitle:title target:(actionHandler ? self : nil) action:(actionHandler ? @selector(handleButtonAction:) : nil)];
    theButton.actionHandler = actionHandler;
    return theButton;
}

// MARK: - Custom Accessors

- (CCNButtonActionhandler)actionHandler {
    return objc_getAssociatedObject(self, @selector(actionHandler));
}

- (void)setActionHandler:(CCNButtonActionhandler)actionHandler {
    if (actionHandler) {
        self.target = self;
        self.action = @selector(handleButtonAction:);
        objc_setAssociatedObject(self, @selector(actionHandler), actionHandler, OBJC_ASSOCIATION_COPY);
    }
    else {
        objc_setAssociatedObject(self, @selector(actionHandler), NULL, OBJC_ASSOCIATION_COPY);
    }
}


// MARK: - Actions

- (void)handleButtonAction:(NSButton *)button {
    __weak typeof(self) weakSelf = self;
    if (self.actionHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.actionHandler(weakSelf);
        });
    }
}

@end
