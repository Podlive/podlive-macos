//
//  Created by Frank Gregor on 28/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPlayerPlayPauseButton.h"
#import "PodliveDefaultStyleKit.h"

@implementation CCNPlayerPlayPauseButton

+ (instancetype)buttonWithSize:(NSSize)buttonSize actionHandler:(CCNButtonAction)actionHandler {
    let _button = [super buttonWithSize:buttonSize actionHandler:actionHandler];
    _button.style = CCNBaseButtonStyleRound;

    return _button;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *color = (self.isMouseHovered ? self.tintHighlightColor : self.tintColor);
    if (self.state == NSControlStateValueOn) {
        [PodliveGUIKit drawPauseButtonWithFrame:self.bounds resizing:PodliveGUIKitResizingBehaviorAspectFit color:color radius:self.cornerRadius borderWidth:self.borderWidth];
    }
    else {
        [PodliveGUIKit drawPlayButtonWithFrame:self.bounds resizing:PodliveGUIKitResizingBehaviorAspectFit color:color radius:self.cornerRadius borderWidth:self.borderWidth];
    }
}

@end
