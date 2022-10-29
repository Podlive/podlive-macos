//
//  Created by Frank Gregor on 03/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@interface NSViewController (Podlive)

+ (instancetype)viewController;
- (void)configureDefaults NS_REQUIRES_SUPER;
- (void)presentAlertWithTitle:(NSString *)alertTitle messageText:(NSString *)messageText informativeText:(NSString *)informativeText style:(NSAlertStyle)alertStyle;
- (NSInteger)presentConfirmationWithTitle:(NSString *)title messageText:(NSString *)messageText informativeText:(NSString *)informativeText actionButtonTitle:(NSString *)actionButtonTitle;

@end
