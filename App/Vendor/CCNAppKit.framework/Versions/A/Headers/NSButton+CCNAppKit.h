//
//  Created by Frank Gregor on 26/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

typedef void (^CCNButtonActionhandler)(NSButton *actionButton);

@interface NSButton (CCNAppKit)

/**
 Creates and returns an NSButton instance with a given image and title.
 
 If the `actionHandler` is given the receivers target is set to self.

 @param title The button title string.
 @param image The button image visible on the left side of title.
 @param actionHandler A handler that will be executed on button press.
 @return An NSButton instance.
 */
+ (instancetype)buttonWithTitle:(NSString *)title image:(NSImage *)image actionHandler:(CCNButtonActionhandler)actionHandler;

/**
 Creates and returns an NSButton instance with a given title.

 If the `actionHandler` is given the receivers target is set to self.

 @param title The button title string.
 @param actionHandler A handler that will be executed on button press.
 @return An NSButton instance.
 */
+ (instancetype)buttonWithTitle:(NSString *)title actionHandler:(CCNButtonActionhandler)actionHandler;

/**
 Creates and returns an NSButton instance with a given image.

 If the `actionHandler` is given the receivers target is set to self.

 @param image The button image visible on the left side of title.
 @param actionHandler A handler that will be executed on button press.
 @return An NSButton instance.
 */
+ (instancetype)buttonWithImage:(NSImage *)image actionHandler:(CCNButtonActionhandler)actionHandler;

/**
 Creates and returns an NSButton instance of type checkbox with a given title.

 If the `actionHandler` is given the receivers target is set to self.

 @param title The button title string.
 @param actionHandler A handler that will be executed on button press.
 @return An NSButton instance.
 */
+ (instancetype)checkboxWithTitle:(NSString *)title actionHandler:(CCNButtonActionhandler)actionHandler;
+ (instancetype)radioButtonWithTitle:(NSString *)title actionHandler:(CCNButtonActionhandler)actionHandler;

/**
 Returns the receivers actionHandler otherwise `nil`.
 
 Setting the actionHandler will disable the target (it is set to self).
 */
@property (nonatomic, assign) CCNButtonActionhandler actionHandler;

@end
