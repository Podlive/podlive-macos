//
//  Created by Frank Gregor on 04/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPlayerStopButton.h"
#import "PodliveGUIKit.h"

@implementation CCNPlayerStopButton

+ (instancetype)buttonWithSize:(NSSize)buttonSize actionHandler:(CCNButtonAction)actionHandler {
    let _button = [super buttonWithSize:buttonSize actionHandler:actionHandler];
    _button.style = CCNBaseButtonStyleRound;

    return _button;
}

- (void)drawRect:(NSRect)dirtyRect {
    let color = (self.isMouseHovered ? self.tintHighlightColor : self.tintColor);
    [PodliveGUIKit drawStopButtonWithFrame:self.bounds resizing:PodliveGUIKitResizingBehaviorAspectFit color:color radius:self.cornerRadius borderWidth:self.borderWidth];
}

@end
