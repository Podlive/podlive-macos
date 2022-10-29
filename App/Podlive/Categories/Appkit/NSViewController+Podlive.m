//
//  Created by Frank Gregor on 03/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSViewController+Podlive.h"
#import "NSImage+Podlive.h"
#import "NSString+UILabels.h"

@implementation NSViewController (Podlive)

+ (instancetype)viewController {
    return [[[self class] alloc] initWithNibName:nil bundle:nil];
}

- (void)configureDefaults {}

- (void)presentAlertWithTitle:(NSString *)alertTitle messageText:(NSString *)messageText informativeText:(NSString *)informativeText style:(NSAlertStyle)alertStyle {
    let alert = NSAlert.new;
    alert.messageText = messageText;
    alert.informativeText = (informativeText ?: @"");
    alert.alertStyle = alertStyle;
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

- (NSInteger)presentConfirmationWithTitle:(NSString *)title messageText:(NSString *)messageText informativeText:(NSString *)informativeText actionButtonTitle:(NSString *)actionButtonTitle {
    let alert = NSAlert.new;
    alert.messageText = messageText;
    alert.informativeText = (informativeText ?: @"");
    alert.alertStyle = NSAlertStyleInformational;
    alert.icon = NSImage.alertSignInfo;

    [alert addButtonWithTitle:NSString.cancel];
    [alert addButtonWithTitle:actionButtonTitle];

    return [alert runModal];
}

@end
