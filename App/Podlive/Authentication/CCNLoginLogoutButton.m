//
//  Created by Frank Gregor on 11/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNLoginLogoutButton.h"
#import "NSColor+Podlive.h"

@implementation CCNLoginLogoutButton

+ (instancetype)buttonWithImage:(NSImage *)image actionHandler:(CCNButtonActionhandler)actionHandler {
    let theButton = CCNLoginLogoutButton.new;
    theButton.image         = image;
    theButton.image.size    = NSMakeSize(25.0, 25.0);
    theButton.bordered      = NO;
    theButton.actionHandler = actionHandler;
    theButton.wantsLayer    = YES;
    theButton.loggedIn      = NO;
    return theButton;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    let bounds = self.bounds;
    let path = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:self.image.size.width/2 yRadius:self.image.size.width/2];
    path.lineWidth = 2.0;

    let strokeColor = (self.isLoggedIn ? NSColor.userLoggedInStatusColor : NSColor.userLoggedOutStatusColor);
    [strokeColor setStroke];
    [path stroke];
    [path closePath];
}

// MARK: - Custom Accessors

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = self.image.size.width/2;
    self.layer.masksToBounds = YES;
}

- (void)setLoggedIn:(BOOL)loggedIn {
    _loggedIn = loggedIn;
    [self setNeedsDisplay];
}

@end
