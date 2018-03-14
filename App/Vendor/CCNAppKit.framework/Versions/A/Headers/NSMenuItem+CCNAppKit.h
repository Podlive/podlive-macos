//
//  Created by Frank Gregor on 11/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

typedef void (^CCNMenuItemAction)(__kindof NSMenuItem *menuItem);

@interface NSMenuItem (CCNAppKit)

+ (instancetype)itemWithTitle:(NSString *)title keyEquivalent:(NSString *)charCode actionHandler:(CCNMenuItemAction)actionHandler;

@property (nonatomic, assign) CCNMenuItemAction actionHandler;

@end
